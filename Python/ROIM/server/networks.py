from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
import socket
import struct
from Crypto.Cipher import PKCS1_OAEP
from Crypto.PublicKey import RSA
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import dh
from cryptography.hazmat.primitives.kdf.hkdf import HKDF
from cryptography.hazmat.primitives.serialization import Encoding, PublicFormat, load_der_public_key
from cryptography.hazmat.backends import default_backend


def generate_keys():
    key = RSA.generate(2048)
    private_key = key.export_key()
    public_key = key.publickey().export_key()
    return private_key, public_key


def AES_key_exchange(sock, tid, exchange_type='DH'):
    if exchange_type == 'DH':
        sock.send(b'D')
        P = get_p()
        G = 2
        params_numbers = dh.DHParameterNumbers(P, G)
        parameters = params_numbers.parameters(default_backend())
        private_key = parameters.generate_private_key()
        public_key = private_key.public_key().public_bytes(Encoding.DER, PublicFormat.SubjectPublicKeyInfo)
        client_key = load_der_public_key(recv_by_size(sock, start=tid + ' S')[5:], default_backend())
        send_data(sock, public_key, start=tid + ' S')
        shared_key = private_key.exchange(client_key)
        key = HKDF(algorithm=hashes.SHA256(), length=16, salt=None, info=b'handshake data', ).derive(shared_key)
        print("Received key:", key)
        return key
    sock.send(b'R')
    private_key, public_key = generate_keys()
    sock.send(public_key)
    enc_key = __recv_amount(sock, 256)
    AES_key = PKCS1_OAEP.new(RSA.import_key(private_key)).decrypt(enc_key)

    print("Received key:", AES_key)
    return AES_key


def AES_encrypt(key, data):
    cipher = AES.new(key, AES.MODE_CBC)
    iv = cipher.iv
    ciphertext = cipher.encrypt(pad(data, AES.block_size))
    return iv, ciphertext


def AES_decrypt(key, iv, data):
    cipher = AES.new(key, AES.MODE_CBC, iv)
    return unpad(cipher.decrypt(data), AES.block_size)


def send_data(sock, bdata, key=b'1234567890123456', start='C'):
    iv, bytearray_data = AES_encrypt(key, bdata)
    bytearray_data = socket.htonl(len(bytearray_data) + 16).to_bytes(4) + b'~' + iv + bytearray_data
    log_tcp('sent', bdata, start)
    sock.send(bytearray_data)


def __recv_amount(sock, size=4):
    buffer = b''
    while size - len(buffer) > 0:
        new_buffer = sock.recv(size - len(buffer))
        if not new_buffer:
            return b''
        buffer += new_buffer
    return buffer


def recv_by_size(sock, aes_key=b'1234567890123456', start='C'):
    try:
        data = __recv_amount(sock, 4)
        data_len = struct.unpack('L', data)[0]
        # code handle the case of data_len 0
        data += __recv_amount(sock, data_len + 1)
        data = data[:5] + AES_decrypt(aes_key, data[5:21], data[21:])
        log_tcp('received', data, start)
        return data
    except OSError:
        data = b''
    return data


def log_tcp(direction, byte_data, start='C'):
    if len(byte_data) > 200:
        byte_data = byte_data[:180] + b'...' + byte_data[-20:]
    if direction == 'sent':
        print(f'C LOG:Sent     >>> {byte_data}')
    else:
        print(f'{start} LOG:Received <<< {byte_data}')


def get_p():
    with open('p.dh', 'rb') as f:
        return int(f.read().hex(), 16)
