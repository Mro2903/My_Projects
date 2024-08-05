import base64

def main():
    with open('base64.txt', 'r') as f:
        data = ''.join(f.read().split('\n'))
        with open('img4.png', 'wb') as f2:
            f2.write(base64.b64decode(data))

if __name__ == '__main__':
    main()