import requests
import threading
url = 'http://osmlist.pythonanywhere.com/secret/'
result = '0'
first = "H3rZ06CY83r1"
last = "aaaa"
letter = ord('5') - 3
timeout = 0.1

# for i in range(26):
#     r = requests.get(url + first + str(chr(letter)) + last)
#     print(r, chr(letter), r.elapsed.total_seconds())
#     letter += 1
#     result = r.text

def to_leet(s):
    leet_dict = {'a': '4', 'e': '3', 'i': '1', 'o': '0', 'b': '8', 's': '5', 't': '7'}
    return ''.join(leet_dict.get(c, c) for c in s.lower())

print(to_leet("Hrzogcyberisgreat"))