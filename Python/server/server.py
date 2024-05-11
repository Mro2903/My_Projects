__author__ = 'Omri'

import base64
import os
import socket
import sys
import threading
import traceback
import pickle
import random
import string
import pyaudio
from Crypto.Hash import SHA256
import smtplib
import ssl
from email.message import EmailMessage
import re
import networks

STREAM_PORT = 54321
PORT = 12345
# globals
users_lock = threading.Lock()
all_to_die = False
users = {}
streams = []
pepper = 'peper'
FORMAT = pyaudio.paInt16
CHANNELS = 2
RATE = 44100


class User:
    def __init__(self, email, password, salt, code):
        self.email = email
        self.password = password
        self.salt = salt
        self.code = code
        self.followers = []
        self.following = []
        self.description = "No description"
        self.online = False
        self.streaming = False
        self.video_port = None
        self.audio_port = None
        self.title = "No title"
        self.viewers = []
        self.watching = ""


class Viewer:
    def __init__(self, name, ip, sock):
        self.name = name
        self.ip = ip
        self.sock = sock


def sign_up(username, email, password, renter):
    with users_lock:
        if username in users:
            return b"UsernameUsed"
        elif not re.fullmatch(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}', email.decode()):
            return b"InvalidEmail"
        elif password != renter:
            return b"WrongRenter"
        salt = ''.join(random.choices(string.ascii_letters + string.digits, k=10))
        hashed_password = SHA256.new((password.decode() + salt + pepper).encode()).hexdigest()
        users[username] = User(email, hashed_password, salt, None)
        with open('users.pickle', 'wb') as p:
            pickle.dump(users, p)

    return b'SingedUp'


def login(username, password):
    with users_lock:
        if not (username and username in users and
                SHA256.new((password.decode() + users[username].salt + pepper).encode()).hexdigest() == users[
                    username].password and users[username].code is None and not users[username].online):
            return b'FailToLogin'
        user_email = users[username].email.decode()
    verification = send_email_verification(user_email)
    with users_lock:
        users[username].code = verification.encode()
        t = threading.Timer(300, clear_users_code, args=(username,))
        t.start()
        return verification.encode()


def send_email_verification(email_receiver):
    email_sender = "omribareket1@gmail.com"
    email_password = "ugnw vyob dkfl ryog"

    em = EmailMessage()
    em['from'] = email_sender
    em['to'] = email_receiver
    em['subject'] = 'verification'
    verification = str(random.randint(0, 9999)).zfill(4)
    em.set_content(f'your verification code is ' + verification)
    context = ssl.create_default_context()

    with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as smtp:
        smtp.login(email_sender, email_password)
        smtp.sendmail(email_sender, email_receiver, em.as_string())
        print('sent')
    return verification


def clear_users_code(username):
    with users_lock:
        users[username].code = None


def forgot_password(username):
    with users_lock:
        if username in users and users[username].code is None:
            verification = send_email_verification(users[username].email.decode())
            users[username].code = verification.encode()
            t = threading.Timer(300, clear_users_code, args=(username,))
            t.start()
            return verification.encode()
    return b'WrongUsername'


def change_password(username, password, renter):
    with users_lock:
        if password != renter:
            return b'WrongRenter'
        salt = users[username].salt
        hashed_password = SHA256.new((password.decode() + salt + pepper).encode()).hexdigest()
        users[username].password = hashed_password
        with open('users.pickle', 'wb') as p:
            pickle.dump(users, p)
    return b'ChangedPassword'


def get_status(username):
    with users_lock:
        if users[username].online:
            if users[username].streaming:
                return b'2'
            if users[username].watching != "":
                return users[username].watching
            return b'1'
        return b'0'


def start_stream(username, title, ip):
    if username in streams:
        return b'Already streaming'
    video_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    video_sock.bind(('0.0.0.0', 0))
    audio_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    audio_sock.bind(('0.0.0.0', 0))
    with users_lock:
        users[username].streaming = True
        users[username].title = title
        users[username].video_port = video_sock.getsockname()[1]
        users[username].audio_port = audio_sock.getsockname()[1]
        streams.append(username)
    t1 = threading.Thread(target=get_frames, args=(username, video_sock, ip.decode()))
    t2 = threading.Thread(target=get_audio, args=(username, audio_sock, ip.decode()))
    t1.start()
    t2.start()
    print(username.decode() + " has started a stream: " + title.decode())
    return (base64.b64encode(str(video_sock.getsockname()[1]).encode()) + b'~' +
            base64.b64encode(str(audio_sock.getsockname()[1]).encode()))


def get_frames(username, sock, ip):
    while True:
        try:
            data, addr = sock.recvfrom(1000000)
        except Exception as e:
            print(f'Error: {e}')
            continue
        if addr[0] != ip:
            continue
        if data == b'':
            break
        threading.Thread(target=send_frames, args=(users[username].viewers, data, sock)).start()
    sock.close()


def send_frames(viewers, data, sock):
    with users_lock:
        for viewer in viewers:
            sock.sendto(data, (viewer.ip, STREAM_PORT))


def get_audio(username, sock, ip):
    sock.listen(5)
    while True:
        streamer, addr = sock.accept()
        if addr[0] != ip:
            streamer.close()
            continue
        break

    def callback_play(in_data, frame_count, time_info, status):
        in_data = streamer.recv(50000)
        with users_lock:
            socks = [viewer.sock for viewer in users[username].viewers if viewer.sock is not None]
        threading.Thread(target=send_audio, args=(socks, in_data)).start()
        return in_data, pyaudio.paContinue

    p = pyaudio.PyAudio()
    stream = p.open(format=FORMAT,
                    channels=CHANNELS,
                    rate=RATE,
                    input=False,
                    output=True,
                    stream_callback=callback_play)

    stream.start_stream()
    print(username.decode() + " has started audio stream")
    while stream.is_active():
        conn, addr = sock.accept()
        with users_lock:
            if addr[0] not in [viewer.ip.decode() for viewer in users[username].viewers]:
                print(addr[0] + " is not in viewers")
                conn.close()
                continue
            i = [viewer.ip.decode() for viewer in users[username].viewers].index(addr[0])
            users[username].viewers[i].sock = conn
    print(username.decode() + " has stopped audio stream")
    stream.stop_stream()
    stream.close()
    streamer.close()
    sock.close()


def send_audio(socks, in_data):
    for sock in socks:
        try:
            sock.send(in_data)
        except ConnectionResetError:
            print(sock.getpeername()[0] + " has disconnected")


def stop_stream(username):
    if username not in streams:
        return b'Not streaming'
    with users_lock:
        users[username].streaming = False
        streams.remove(username)
        for viewer in users[username].viewers:
            users[viewer.name].watching = ""
            viewer.sock.close()
        users[username].viewers = []
    print(username.decode() + " has stopped the stream")
    return b'Stopped'


def watch_stream(username, streamer, ip):
    with users_lock:
        users[username].watching = streamer
        users[streamer].viewers.append(Viewer(username, ip, None))
        title = users[streamer].title
    return str(users[streamer].audio_port).encode(), title


def stop_watch(username):
    with users_lock:
        if users[username].watching == "" or users[username].watching not in streams:
            return b'005'
        viewers = [viewer.name for viewer in users[users[username].watching].viewers]
        if username not in viewers:
            return base64.b64encode(b'Not watching')
        users[users[username].watching].viewers.pop(viewers.index(username))
        users[username].watching = ""
        return base64.b64encode(b'Stopped watching')


def set_icon(icon, username):
    print(len(icon))
    with open(f'icons/{username.decode()}.png', 'wb') as f:
        f.write(icon)
    return b'IconSet'


def get_icon(username):
    if os.path.exists(f'icons/{username.decode()}.png'):
        with open(f'icons/{username.decode()}.png', 'rb') as f:
            return f.read()
    return b'Default'


def follow(username, following):
    if following in users[username].following:
        return b'Already followed'
    with users_lock:
        users[username].following.append(following)
        users[following].followers.append(username)
        with open('users.pickle', 'wb') as p:
            pickle.dump(users, p)
    return b'Followed'


def unfollow(username, following):
    if following not in users[username].following:
        return b'Not followed'
    with users_lock:
        users[username].following.remove(following)
        users[following].followers.remove(username)
        with open('users.pickle', 'wb') as p:
            pickle.dump(users, p)
    return b'Unfollowed'


def follow_status(username):
    with users_lock:
        return (base64.b64encode(str(len(users[username].followers)).encode()) + b'~' +
                base64.b64encode(str(len(users[username].following)).encode()))


def handle_anonymous_request(request_code, fields):
    if request_code == 'SNGU' and len(fields) == 4:
        return (b'SNGR' + b'~' + base64.b64encode(fields[0]) + b'~' +
                base64.b64encode(sign_up(fields[0], fields[1], fields[2], fields[3]))), 'anonymous'
    elif request_code == 'LOGI' and len(fields) == 2:
        verification = login(fields[0], fields[1])
        if verification != b'FailToLogin':
            return b'2FAR', 'LOGI'
        return b'LOGR' + b'~' + base64.b64encode(b'FailToLogin'), 'anonymous'
    elif request_code == 'FGPS' and len(fields) == 1:
        verification = forgot_password(fields[0])
        if verification != b'WrongUsername':
            return b'2FAR', 'ForgotPassword'
        return b'FGPR' + b'~' + base64.b64encode(b'WrongUsername'), 'anonymous'
    elif request_code == 'EXIT' and len(fields) == 0:
        return b'EXIT', 'anonymous'
    else:
        if request_code not in ['SNGU', 'LOGI', 'FGPS']:
            return b'002', 'anonymous'
        return b'004', 'anonymous'


def handle_login_request(request_code, fields, username):
    if request_code == '2FAC' and len(fields) == 1:
        if fields[0] == users[username].code:
            with users_lock:
                users[username].code = None
            return b'2FAV' + b'~' + base64.b64encode(b'Verified'), 'Home'
        return b'2FAV' + b'~' + base64.b64encode(b'NotVerified'), 'LOGI'
    else:
        if request_code != '2FAC':
            return b'002', 'LOGI'
        return b'004', 'LOGI'


def handle_forgot_password_request(request_code, fields, username):
    if request_code == '2FAC' and len(fields) == 1:
        if fields[0] == users[username].code:
            with users_lock:
                users[username].code = None
            return b'2FAV' + b'~' + base64.b64encode(b'Verified'), 'change password'
        return b'2FAV' + b'~' + base64.b64encode(b'NotVerified'), 'ForgotPassword'
    else:
        if request_code != '2FAC':
            return b'002', 'ForgotPassword'
        return b'004', 'ForgotPassword'


def handle_change_password_request(request_code, fields, username):
    if request_code == 'CHPS' and len(fields) == 2:
        change = change_password(username, fields[0], fields[1])
        if change == b'ChangedPassword':
            return b'CHPR' + b'~' + base64.b64encode(change), 'anonymous'
        return b'CHPR' + b'~' + base64.b64encode(change), 'change password'
    else:
        if request_code != 'CHPS':
            return b'002', 'change password'
        return b'004', 'change password'


def handle_home_request(request_code, fields, username):
    if request_code == 'GTUD' and len(fields) == 1:
        if fields[0] not in users.keys():
            print(fields[0], users.keys())
            return b'005', 'Home'
        return (b'GUDR' + b'~' + base64.b64encode(users[fields[0]].description.encode()) + b'~' +
                base64.b64encode(get_icon(fields[0])) + b'~' +
                base64.b64encode(get_status(fields[0])) + b'~' +
                follow_status(username), 'Home')
    elif request_code == 'GTUL' and len(fields) == 0:
        return b'GTUR~' + base64.b64encode(pickle.dumps(list(users.keys()))), 'Home'
    elif request_code == 'CHPI' and len(fields) == 1:
        return b'CPIR~' + base64.b64encode(set_icon(fields[0], username)), 'Home'
    elif request_code == 'CHDS' and len(fields) == 1:
        try:
            with users_lock:
                users[username].description = fields[0].decode()
        except UnicodeDecodeError:
            return b'CHDR~' + base64.b64encode(b'not a valid description'), 'Home'
        return b'CHDR~' + base64.b64encode(b'description changed'), 'Home'
    elif request_code == 'FOLL' and len(fields) == 1:
        if fields[0] not in users:
            return b'005', 'Home'
        return b'FOLR~' + base64.b64encode(follow(username, fields[0])), 'Home'
    elif request_code == 'UFOL' and len(fields) == 1:
        if fields[0] not in users:
            return b'005', 'Home'
        return b'UFOR~' + base64.b64encode(unfollow(username, fields[0])), 'Home'
    elif request_code == 'STRM' and len(fields) == 2:
        return b'STMR~' + start_stream(username, fields[0], fields[1]), 'streaming'
    elif request_code == 'WSTM' and len(fields) == 2:
        if fields[0] not in streams:
            return b'WTSR~' + base64.b64decode(b'Not streaming')
        audio_port, title = watch_stream(username, fields[0], fields[1])
        return b'WTSR~' + base64.b64encode(audio_port) + b'~' + base64.b64encode(title), 'watching'
    else:
        if request_code not in ['GTUD', 'GTUL', 'CHPI', 'CHDS', 'FOLL', 'UNFL', 'STRM', 'STOP', 'WSTM', 'STWS']:
            return b'002', 'Home'
        return b'004', 'Home'


def handle_stream_request(request_code, fields, username):
    if request_code == 'STOP' and len(fields) == 0:
        return b'STOR~' + base64.b64encode(stop_stream(username)), 'Home'
    elif request_code == 'GETV' and len(fields) == 0:
        with users_lock:
            return b'GTVR~' + base64.b64encode(str(len(users[username].viewers)).encode()), 'streaming'
    else:
        if request_code not in ['STOP', 'GETV']:
            return b'002', 'streaming'
        return b'004', 'streaming'


def handle_watch_request(request_code, fields, username):
    if request_code == 'STWS' and len(fields) == 0:
        answer = stop_watch(username)
        if answer == b'005':
            return answer, 'Home'
        return b'STWR~' + answer, 'Home'
    elif request_code == 'GETV' and len(fields) == 0:
        with users_lock:
            return b'GTVR~' + base64.b64encode(str(len(users[users[username].watching].viewers)).encode()), 'watching'
    else:
        if request_code not in ['STWS', 'GETV']:
            return b'002', 'watching'
        return b'004', 'watching'


def protocol_build_reply(request, state, username):
    fields = [base64.b64decode(a) for a in request.split(b'~')[1:]]
    request_code = request[:4].decode()
    try:
        if request_code == 'CNCL':
            if state == 'streaming':
                stop_stream(username)
            elif state == 'watching':
                stop_watch(username)
            return b'CNCR', 'anonymous'
        if state == 'anonymous':
            reply, state = handle_anonymous_request(request_code, fields)
        elif state == 'LOGI':
            reply, state = handle_login_request(request_code, fields, username)
        elif state == "ForgotPassword":
            reply, state = handle_forgot_password_request(request_code, fields, username)
        elif state == 'change password':
            reply, state = handle_change_password_request(request_code, fields, username)
        elif state == 'Home':
            reply, state = handle_home_request(request_code, fields, username)
        elif state == 'streaming':
            reply, state = handle_stream_request(request_code, fields, username)
        elif state == 'watching':
            reply, state = handle_watch_request(request_code, fields, username)
        else:
            reply, state = b'003', 'anonymous'
        if len(reply) == 3:
            return error_message(reply), state
        return reply, state
    except Exception as e:
        print(e)
        return error_message(b'001'), state


def error_message(error_code):
    error = b'ERRR~' + base64.b64encode(error_code) + b'~'
    if error_code == b'001':
        error += base64.b64encode(b'General error')
    elif error_code == b'002':
        error += base64.b64encode(b'code not supported')
    elif error_code == b'003':
        error += base64.b64encode(b'unknown state')
    elif error_code == b'004':
        error += base64.b64encode(b'wrong amount of fields')
    elif error_code == b'005':
        error += base64.b64encode(b'Invalid username')
    return error


def handle_request(request, state, username):
    request_code = request[:4]
    to_send, state = protocol_build_reply(request, state, username)
    if request_code == b'EXIT':
        return to_send, state, True
    return to_send, state, False


def handle_client(sock, tid, addr):
    global all_to_die
    aes_key = networks.AES_key_exchange(sock, tid, sys.argv[1])
    state = "anonymous"
    finish = False
    username = None
    print(f'New Client number {tid} from {addr}')
    while not finish:
        if all_to_die:
            print('will close due to main server issue')
            break
        try:
            byte_data = networks.recv_by_size(sock, aes_key, tid + ' S')
            if byte_data == b'':
                print('Seems client disconnected')
                break
            byte_data = byte_data[5:]  # remove length field
            to_send, state, finish = handle_request(byte_data, state, username)
            if byte_data[:4] == b'LOGI' and state == 'LOGI' or byte_data[:4] == b'FGPS' and state == 'ForgotPassword':
                username = base64.b64decode(byte_data.split(b'~')[1])
                with users_lock:
                    users[username].online = True
            elif byte_data[:4] == b'CNCL' and state != 'anonymous':
                with users_lock:
                    users[username].online = False
                    users[username].streaming = False
                    users[username].code = None
                    username = None
            print(f'Client {tid} state: {state}')
            if to_send != b'':
                networks.send_data(sock, to_send, aes_key, tid + ' S')
        except socket.error as err:
            print(f'Socket Error exit client loop: err:  {err}')
            break
        except Exception as err:
            print(f'General Error %s exit client loop: {err}')
            print(traceback.format_exc())
            break
    if username:
        with users_lock:
            users[username].streaming = False
            users[username].online = False
            users[username].code = None
    print(f'Client {tid} Exit')
    sock.close()


def main():
    global all_to_die
    global users
    global pepper
    with open('pepper.txt', 'r') as p:
        pepper = p.read()

    if os.path.exists('users.pickle'):
        with open('users.pickle', 'rb') as p:
            users = pickle.load(p)
        for user in users.values():
            user.code = None
            user.online = False
            user.streaming = False
            user.watching = ""
            user.viewers = []
    else:
        with open('users.pickle', 'wb') as p:
            pickle.dump(users, p)

    threads = []
    srv_sock = socket.socket()

    srv_sock.bind(('0.0.0.0', PORT))

    srv_sock.listen(20)

    # next line release the port
    srv_sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    i = 1
    try:
        while True:
            print('\nMain thread: before accepting ...')
            cli_sock, addr = srv_sock.accept()
            t = threading.Thread(target=handle_client, args=(cli_sock, str(i), addr))
            t.start()
            i += 1
            threads.append(t)
    except KeyboardInterrupt:
        all_to_die = True
        print('Main thread: waiting to all clients to die')
        for t in threads:
            t.join()
        srv_sock.close()
        print('Bye ..')


if __name__ == '__main__':
    main()
