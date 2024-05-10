__author__ = 'Omri'

import zlib
import pyaudio
import networks
import threading
import os.path
import glob
import pickle
import cv2
import socket
import base64
import sys
from kivymd.app import MDApp
from kivy.uix.image import Image
from kivy.clock import Clock
from kivy.graphics.texture import Texture
from kivymd.uix.dialog import MDDialog
from kivymd.uix.button import MDRectangleFlatButton, MDFlatButton
from kivymd.uix.floatlayout import MDFloatLayout
from kivymd.uix.filemanager import MDFileManager
from kivymd.uix.list import TwoLineAvatarListItem, ImageLeftWidget
from kivymd.uix.tab import MDTabsBase
from kivy.uix.screenmanager import NoTransition
from kivy.lang import Builder

CHUNK = 1024
FORMAT = pyaudio.paInt16
CHANNELS = 2
RATE = 44100


class Description(MDFloatLayout):
    pass


class Camara(Image):
    def __init__(self, capture, fps, **kwargs):
        super(Camara, self).__init__(**kwargs)
        self.capture = capture
        Clock.schedule_interval(self.update, 1.0 / fps)

    def update(self, dt):
        ret, frame = self.capture.read()
        if ret:
            # convert it to texture
            buf1 = cv2.flip(frame, 0)
            buf = buf1.tobytes()
            image_texture = Texture.create(
                size=(frame.shape[1], frame.shape[0]), colorfmt='bgr')
            image_texture.blit_buffer(buf, colorfmt='bgr', bufferfmt='ubyte')
            # display image from the texture
            self.texture = image_texture


class Stream(Image):
    def __init__(self, sock, fps, **kwargs):
        super(Stream, self).__init__(**kwargs)
        self.sock = sock
        self.stop = False
        sock.settimeout(1)
        Clock.schedule_interval(self.update, 1.0 / fps)

    def update(self, dt):
        if self.stop:
            return
        try:
            data, addr = self.sock.recvfrom(1000000)
        except Exception as e:
            print(e)
            return
        data = zlib.decompress(data)
        frame = cv2.imdecode(pickle.loads(data), cv2.IMREAD_COLOR)
        # convert it to texture
        buf1 = cv2.flip(frame, 0)
        buf = buf1.tobytes()
        image_texture = Texture.create(
            size=(frame.shape[1], frame.shape[0]), colorfmt='bgr')
        image_texture.blit_buffer(buf, colorfmt='bgr', bufferfmt='ubyte')
        # display image from the texture
        self.texture = image_texture



class ClientApp(MDApp):
    dialog = None
    capture = None
    feed = False
    TFA_username = None
    TFA_next_screen = None
    username = None
    filemanager = None

    def __init__(self, sock, aes_key, **kwargs):
        super(ClientApp, self).__init__(**kwargs)
        self.sock = sock
        self.aes_key = aes_key
        self.path = os.path.expanduser("~") or os.path.expanduser("/")
        self.filemanager = MDFileManager(
            exit_manager=self.exit_manager,
            select_path=self.select_path
        )

    def build(self, **kwargs):
        self.theme_cls.theme_style = "Dark"
        self.theme_cls.primary_palette = "BlueGray"
        return Builder.load_file('client.kv')

    def login(self, username, password):
        networks.send_data(self.sock, (b'LOGI~' +
                                       base64.b64encode(username.encode()) + b'~' +
                                       base64.b64encode(password.encode())), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if base64.b64decode(data.split(b'~')[-1]) != b'FailToLogin':
            self.TFA_username = username
            self.TFA_next_screen = "Home"
            self.change_screen("screen_manager_authentication", "TFA")
        else:
            self.pop_up('username or password is incorrect')

    def sign_up(self, username, email, password, re_password):
        networks.send_data(self.sock, (b'SNGU~' +
                                       base64.b64encode(username.encode()) + b'~' +
                                       base64.b64encode(email.encode()) + b'~' +
                                       base64.b64encode(password.encode()) + b'~' +
                                       base64.b64encode(re_password.encode())), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if base64.b64decode(data.split(b'~')[-1]) != b'SingedUp':
            self.pop_up(base64.b64decode(data.split(b'~')[-1]).decode())
        else:
            self.pop_up('Singed Up')

    def forgot_password(self, username):
        networks.send_data(self.sock, b'FGPS~' + base64.b64encode(username.encode()), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if base64.b64decode(data.split(b'~')[-1]) != b'WrongUsername':
            self.TFA_username = username
            self.TFA_next_screen = "ChangePassword"
            self.change_screen("screen_manager_authentication", "TFA")
        else:
            self.pop_up('user is not registered')

    def submit_code(self, code):
        networks.send_data(self.sock, b'2FAC~' + base64.b64encode(code.encode()), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if base64.b64decode(data.split(b'~')[-1]) == b'NotVerified':
            self.pop_up('Code is incorrect')
        else:
            if self.TFA_next_screen == 'Home':
                self.username = self.TFA_username
                self.get_profile(self.TFA_username)
            self.change_screen("screen_manager_authentication", self.TFA_next_screen)

    def change_password(self, new_password, re_new_password):
        networks.send_data(self.sock, b'CHPS~' + base64.b64encode(new_password.encode()) + b'~' +
                           base64.b64encode(re_new_password.encode()), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if base64.b64decode(data.split(b'~')[-1]) == b'ChangedPassword':
            self.change_screen("screen_manager_authentication", 'Login')
            self.pop_up('Password changed')
        else:
            self.pop_up('Renter password is incorrect')

    def get_profile(self, username):
        networks.send_data(self.sock, b'GTUD~' + base64.b64encode(username.encode()), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if data.split(b'~')[1] != b'GUDR':
            self.pop_up(base64.b64decode(data.split(b'~')[-1]).decode())
            return
        args = [base64.b64decode(a) for a in data.split(b'~')[2:]]
        self.root.ids["profile_info"].text = username
        self.root.ids["profile_info"].secondary_text = args[0].decode()
        if args[1] == b'Default':
            self.root.ids["profile_image"].source = "data/logo/kivy-icon-256.png"
        else:
            with open(f'tmp/{username}.png', 'wb') as f:
                f.write(args[1])
            self.root.ids["profile_image"].source = f'tmp/{username}.png'
        if username == self.username:
            self.root.ids["profile_image"].on_press = self.open_filemanager
            self.root.ids["profile_info"].on_press = self.change_description
        else:
            self.root.ids["profile_image"].on_press = lambda: True
            self.root.ids["profile_info"].on_press = lambda: True
        self.root.ids["profile_info"].tertiary_text = self.get_status(args[2])
        self.root.ids["followers"].text = "Followers: " + args[3].decode()
        self.root.ids["following"].text = "Following: " + args[4].decode()

        self.change_screen("screen_manager_home", "Profile")

    def get_users_list(self):
        networks.send_data(self.sock, b'GTUL', self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        return pickle.loads(base64.b64decode(data.split(b'~')[-1]))

    def change_description(self, *args):
        if not self.dialog:
            self.dialog = MDDialog(
                title="Change Description:",
                type="custom",
                content_cls=Description(),
                buttons=[
                    MDFlatButton(
                        text="CANCEL",
                        theme_text_color="Custom",
                        text_color=self.theme_cls.primary_color,
                        on_release=self.close_dialog
                    ),
                    MDFlatButton(
                        text="OK",
                        theme_text_color="Custom",
                        text_color=self.theme_cls.primary_color,
                        on_release=self.change_description_text
                    ),
                ],
            )
        self.dialog.open()

    def change_description_text(self, obj):
        description = self.dialog.content_cls.ids["description"].text
        networks.send_data(self.sock, b'CHDS~' + base64.b64encode(description.encode()), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if data.split(b'~')[1] == b'CHDR':
            self.pop_up('Description changed')
            self.root.ids["profile_info"].secondary_text = description
            self.close_dialog(None)

    def change_profile(self, path):
        with open(path, 'rb') as f:
            data = f.read()
            networks.send_data(self.sock, b'CHPI~' + base64.b64encode(data), self.aes_key)
        icon = networks.recv_by_size(self.sock, self.aes_key)
        if icon.split(b'~')[1] == b'CPIR':
            self.pop_up('Profile changed')
            self.root.ids["profile_image"].source = path

    @staticmethod
    def get_status(data):
        if data == b'1':
            return 'Online'
        elif data == b'2':
            return 'Live'
        elif data == b'0':
            return 'Offline'
        else:
            return "Watching " + data.decode()

    def refresh_feed(self):
        users = self.get_users_list()
        if self.feed:
            self.root.ids["Feed_list"].clear_widgets()
        self.load_feed(users)
        self.feed = True
        self.change_screen("screen_manager_home", "Feed")

    def load_feed(self, users):
        for user in users:
            networks.send_data(app.sock, b'GTUD~' + base64.b64encode(user), app.aes_key)
            data = networks.recv_by_size(app.sock, app.aes_key)
            if data.split(b'~')[1] != b'GUDR':
                continue
            source = "data/logo/kivy-icon-256.png"
            if base64.b64decode(data.split(b'~')[3]) != b'Default':
                with open(f'tmp/{user.decode()}.png', 'wb') as icon:
                    icon.write(base64.b64decode(data.split(b'~')[3]))
                source = f'tmp/{user.decode()}.png'
            self.root.ids["Feed_list"].add_widget(TwoLineAvatarListItem(ImageLeftWidget(source=source,
                                                                                        on_press=lambda
                                                                                            x: self.get_profile(
                                                                                            x.parent.parent.text)),
                                                                        text=user.decode(),
                                                                        secondary_text=base64.b64decode(
                                                                            data.split(b'~')[2]).decode(),
                                                                        tertiary_text=self.get_status(
                                                                            base64.b64decode(data.split(b'~')[4])),
                                                                        on_press=lambda x: self.watch_stream(x.text)))

    def stream(self, title):
        networks.send_data(self.sock, b'STRM~' + base64.b64encode(title.encode()) + b'~' +
                           base64.b64encode(self.sock.getsockname()[0].encode()), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if data.split(b'~')[1] != b'STMR':
            self.pop_up(base64.b64decode(data.split(b'~')[-1]).decode())
            return
        self.root.ids["Stream_video"].children[0].text = title
        self.capture = cv2.VideoCapture(0)
        self.capture.set(3, 640)
        self.capture.set(4, 480)
        video_port = int(base64.b64decode(data.split(b'~')[-2]).decode())
        audio_port = int(base64.b64decode(data.split(b'~')[-1]).decode())
        audio_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        audio_sock.connect((sys.argv[1], audio_port))
        t2 = threading.Thread(target=self.send_audio, args=(audio_sock,))
        t1 = threading.Thread(target=self.send_frames, args=(video_port,))
        t1.start()
        t2.start()
        self.root.ids["Stream_video"].add_widget(Camara(capture=self.capture, fps=30))

        self.change_screen("screen_manager_stream", "Stream_view")

    def send_frames(self, port):
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 1000000)
        while self.capture:
            ret, frame = self.capture.read()
            if ret:
                tmp, buffer = cv2.imencode('.jpg', frame, [int(cv2.IMWRITE_JPEG_QUALITY), 30])
                data = pickle.dumps(buffer)
                try:
                    s.sendto(zlib.compress(data), (sys.argv[1], port))
                except OSError:
                    continue
        print('stop')
        s.close()

    def send_audio(self, audio_sock):
        def callback_record(in_data, frame_count, time_info, status):
            audio_sock.send(in_data)
            return in_data, pyaudio.paContinue

        p = pyaudio.PyAudio()
        stream = p.open(format=FORMAT,
                        channels=CHANNELS,
                        rate=RATE,
                        input=True,
                        output=False,
                        stream_callback=callback_record)
        stream.start_stream()

        while stream.is_active() and self.capture:
            pass
        stream.stop_stream()
        stream.close()
        audio_sock.close()

    def play_audio(self, audio_sock):
        def callback_play(in_data, frame_count, time_info, status):
            in_data = audio_sock.recv(50000)
            return in_data, pyaudio.paContinue

        p = pyaudio.PyAudio()
        stream = p.open(format=FORMAT,
                        channels=CHANNELS,
                        rate=RATE,
                        input=False,
                        output=True,
                        stream_callback=callback_play)
        stream.start_stream()
        while stream.is_active() and len(self.root.ids["Watch_layout"].children) == 2:
            pass
        stream.stop_stream()
        stream.close()
        audio_sock.close()

    def stop_stream(self):
        if self.capture != None:
            networks.send_data(self.sock, b'STOP', self.aes_key)
            self.root.ids["Stream_video"].remove_widget(self.root.ids["Stream_video"].children[0])
            self.capture.release()
            self.capture = None
            networks.recv_by_size(self.sock, self.aes_key)
        self.change_screen("screen_manager_authentication", "Home")
        self.change_screen("screen_manager_stream", "Preview")

    def watch_stream(self, streamer):
        networks.send_data(self.sock, b'WSTM~' + base64.b64encode(streamer.encode()) + b'~' +
                           base64.b64encode(self.sock.getsockname()[0].encode()), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if data.split(b'~')[1] == b'WTSR' and base64.b64decode(data.split(b'~')[2]) != b'Not streaming':
            self.root.ids["Watch_layout"].children[0].title = base64.b64decode(data.split(b'~')[4]).decode()
            video_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            video_sock.bind(('127.0.0.1', int(sys.argv[3])))
            audio_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            audio_sock.connect((sys.argv[1], int(base64.b64decode(data.split(b'~')[3]).decode())))
            self.root.ids["Watch_layout"].add_widget(Stream(video_sock, 30))
            t = threading.Thread(target=self.play_audio, args=(audio_sock,))
            t.start()
            self.change_screen("screen_manager_authentication", "Watch")
        elif data.split(b'~')[1] == b'WTSR':
            self.pop_up('User is not streaming')
        else:
            self.pop_up(base64.b64decode(data.split(b'~')[-1]).decode())


    def stop_watch(self):
        networks.send_data(self.sock, b'STWS', self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        self.root.ids["Watch_layout"].children[0].stop = True
        self.root.ids["Watch_layout"].children[0].sock.close()
        self.root.ids["Watch_layout"].remove_widget(self.root.ids["Watch_layout"].children[0])
        self.change_screen("screen_manager_authentication", "Home")
        self.pop_up(base64.b64decode(data.split(b'~')[-1]).decode())

    def open_filemanager(self):
        self.filemanager.show(self.path)

    def select_path(self, path):
        if path.split('.')[-1] == "png":
            self.change_profile(path)
            self.exit_manager()
        else:
            self.pop_up('select a png file')

    def exit_manager(self, *args):
        self.filemanager.close()

    def follow(self, username):
        networks.send_data(self.sock, b'FOLL~' + base64.b64encode(username.encode()), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if base64.b64decode(data.split(b'~')[-1]) == b'Followed':
            self.get_profile(username)
            self.pop_up('Followed')
        else:
            self.pop_up(base64.b64decode(data.split(b'~')[-1]).decode())

    def unfollow(self, username):
        networks.send_data(self.sock, b'UFOL~' + base64.b64encode(username.encode()), self.aes_key)
        data = networks.recv_by_size(self.sock, self.aes_key)
        if base64.b64decode(data.split(b'~')[-1]) == b'Unfollowed':
            self.get_profile(username)
            self.pop_up('Unfollowed')
        else:
            self.pop_up(base64.b64decode(data.split(b'~')[-1]).decode())

    def pop_up(self, text):
        if not self.dialog:
            self.dialog = MDDialog(text=text,
                                   buttons=[MDRectangleFlatButton(text="ok", text_color=self.theme_cls.primary_color,
                                                                  on_release=self.close_dialog)]
                                   )
        self.dialog.open()

    def close_dialog(self, obj):
        self.dialog.dismiss()
        self.dialog = None

    def cancel(self):
        networks.send_data(self.sock, b'CNCL', self.aes_key)
        networks.recv_by_size(self.sock, self.aes_key)
        self.change_screen("screen_manager_authentication", "Login")
        self.TFA_username = None
        self.TFA_next_screen = None

    def change_screen(self, screen_manager, screen):
        self.root.ids[screen_manager].transition = NoTransition()
        self.root.ids[screen_manager].current = screen


class Tab(MDFloatLayout, MDTabsBase):
    pass


if __name__ == '__main__':
    connected = False

    sock = socket.socket()

    try:
        sock.connect((sys.argv[1], int(sys.argv[2])))
        print(f'Conaction succeeded {sys.argv[1]}:{int(sys.argv[2])}')
        connected = True
    except OSError:
        print(f'Error while trying to connect.  Check ip or port -- {sys.argv[1]}:{int(sys.argv[2])}')

    if connected:
        aes_key = networks.AES_key_exchange(sock)
        app = ClientApp(sock, aes_key)
        app.run()
        tmp_files = glob.glob('tmp/*')
        for f in tmp_files:
            os.remove(f)
