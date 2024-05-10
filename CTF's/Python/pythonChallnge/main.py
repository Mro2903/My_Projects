import re
import os
import pickle
import zipfile
import bz2
from tkinter import *
from PIL import Image, ImageSequence
import xmlrpc.client
import calendar
import numpy as np

# 0
def c_0():
    print(2 ** 38)

# ocr
def c_1():
    with open("ocr.txt") as chars:
        s = re.sub("[]!@#[$%^&*()_+{}\n]", "", chars.read())
        print(s)

# equality
def c_2():
    with open("equality.txt") as chars:
        s = chars.read().replace("\n", "")
        ans = ""
        for i in range(3, len(s) - 3):
            if s[i].islower():
                if (s[i - 3:i] + s[i + 1: i + 4]).isupper():
                    if (s[i - 4] + s[i + 4]).islower():
                        ans += s[i]
        print(ans)


# linkedlist
def c_3():
    num = "63579"
    while True:
        os.system(
            "cmd /c wget http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing=" + num + ' -O C:\\Users\A\\tmp\pythonChallnge\l.txt')
        with open("l.txt") as file:
            num = file.readline().split()[-1]
            print(num)

# pickle
def c_4():
    l = []
    with open('data.pikcle', 'rb') as file:
        l = pickle.load(file)

    for d in l:
        print("".join([k * v for (k, v) in d]))

# channel
def c_5():
    num = "90052"
    z = zipfile.ZipFile('channel.zip')

    while True:
        print(z.getinfo(num + ".txt").comment.decode("utf-8"), end="")
        num = z.read(num + ".txt").decode("utf-8").split()[3]

# oxygen&hockey
def c_6():
    pixels = {(103, 100, 59, 255), (98, 95, 54, 255), (105, 105, 105, 255), (51, 51, 51, 255), (121, 121, 121, 255),
              (44, 44, 44, 255), (120, 120, 120, 255), (100, 100, 100, 255), (49, 49, 49, 255), (48, 48, 48, 255),
              (50, 50, 50, 255), (101, 92, 51, 255), (97, 83, 46, 255), (107, 100, 58, 255), (110, 108, 67, 255),
              (114, 114, 114, 255), (115, 115, 115, 255), (116, 116, 116, 255), (101, 98, 55, 255), (46, 46, 46, 255),
              (93, 93, 93, 255), (112, 110, 69, 255), (99, 85, 46, 255), (109, 109, 109, 255), (95, 82, 47, 255),
              (95, 83, 45, 255), (101, 101, 101, 255), (32, 32, 32, 255), (52, 52, 52, 255), (94, 82, 44, 255),
              (91, 91, 91, 255), (108, 99, 60, 255), (118, 118, 118, 255), (102, 94, 57, 255), (103, 103, 103, 255),
              (106, 97, 58, 255), (117, 117, 117, 255), (97, 87, 51, 255), (110, 110, 110, 255), (111, 111, 111, 255),
              (97, 84, 49, 255), (98, 86, 48, 255), (53, 53, 53, 255), (54, 54, 54, 255), (109, 105, 60, 255),
              (99, 91, 54, 255), (104, 104, 104, 255), (97, 97, 97, 255), (114, 112, 71, 255), (108, 108, 108, 255)}
    print(pixels)
    pixels = [r for r, g, b, t in pixels if r == b == g]
    print(pixels)
    ans = ['105', '110', '116', '101', '103', '114', '105', '116', '121']
    ans = [chr(int(i)) for i in ans]
    print(ans)

# integrity
def c_7():
    print(bz2.decompress(
        b'BZh91AY&SYA\xaf\x82\r\x00\x00\x01\x01\x80\x02\xc0\x02\x00 \x00!\x9ah3M\x07<]\xc9\x14\xe1BA\x06\xbe\x084'))
    print(bz2.decompress(b'BZh91AY&SY\x94$|\x0e\x00\x00\x00\x81\x00\x03$ \x00!\x9ah3M\x13<]\xc9\x14\xe1BBP\x91\xf08'))

# good
def c_8():
    first = [146, 399, 163, 403, 170, 393, 169, 391, 166, 386, 170, 381, 170, 371, 170, 355, 169, 346, 167, 335, 170,
             329,
             170, 320, 170,
             310, 171, 301, 173, 290, 178, 289, 182, 287, 188, 286, 190, 286, 192, 291, 194, 296, 195, 305, 194, 307,
             191,
             312, 190, 316,
             190, 321, 192, 331, 193, 338, 196, 341, 197, 346, 199, 352, 198, 360, 197, 366, 197, 373, 196, 380, 197,
             383,
             196, 387, 192,
             389, 191, 392, 190, 396, 189, 400, 194, 401, 201, 402, 208, 403, 213, 402, 216, 401, 219, 397, 219, 393,
             216,
             390, 215, 385,
             215, 379, 213, 373, 213, 365, 212, 360, 210, 353, 210, 347, 212, 338, 213, 329, 214, 319, 215, 311, 215,
             306,
             216, 296, 218,
             290, 221, 283, 225, 282, 233, 284, 238, 287, 243, 290, 250, 291, 255, 294, 261, 293, 265, 291, 271, 291,
             273,
             289, 278, 287,
             279, 285, 281, 280, 284, 278, 284, 276, 287, 277, 289, 283, 291, 286, 294, 291, 296, 295, 299, 300, 301,
             304,
             304, 320, 305,
             327, 306, 332, 307, 341, 306, 349, 303, 354, 301, 364, 301, 371, 297, 375, 292, 384, 291, 386, 302, 393,
             324,
             391, 333, 387,
             328, 375, 329, 367, 329, 353, 330, 341, 331, 328, 336, 319, 338, 310, 341, 304, 341, 285, 341, 278, 343,
             269,
             344, 262, 346,
             259, 346, 251, 349, 259, 349, 264, 349, 273, 349, 280, 349, 288, 349, 295, 349, 298, 354, 293, 356, 286,
             354,
             279, 352, 268,
             352, 257, 351, 249, 350, 234, 351, 211, 352, 197, 354, 185, 353, 171, 351, 154, 348, 147, 342, 137, 339,
             132,
             330, 122, 327,
             120, 314, 116, 304, 117, 293, 118, 284, 118, 281, 122, 275, 128, 265, 129, 257, 131, 244, 133, 239, 134,
             228,
             136, 221, 137,
             214, 138, 209, 135, 201, 132, 192, 130, 184, 131, 175, 129, 170, 131, 159, 134, 157, 134, 160, 130, 170,
             125,
             176, 114, 176,
             102, 173, 103, 172, 108, 171, 111, 163, 115, 156, 116, 149, 117, 142, 116, 136, 115, 129, 115, 124, 115,
             120,
             115, 115, 117,
             113, 120, 109, 122, 102, 122, 100, 121, 95, 121, 89, 115, 87, 110, 82, 109, 84, 118, 89, 123, 93, 129, 100,
             130, 108, 132, 110,
             133, 110, 136, 107, 138, 105, 140, 95, 138, 86, 141, 79, 149, 77, 155, 81, 162, 90, 165, 97, 167, 99, 171,
             109,
             171, 107, 161,
             111, 156, 113, 170, 115, 185, 118, 208, 117, 223, 121, 239, 128, 251, 133, 259, 136, 266, 139, 276, 143,
             290,
             148, 310, 151,
             332, 155, 348, 156, 353, 153, 366, 149, 379, 147, 394, 146, 399]
    second = [156, 141, 165, 135, 169, 131, 176, 130, 187, 134, 191, 140, 191, 146, 186, 150, 179, 155, 175, 157, 168,
              157,
              163, 157, 159,
              157, 158, 164, 159, 175, 159, 181, 157, 191, 154, 197, 153, 205, 153, 210, 152, 212, 147, 215, 146, 218,
              143,
              220, 132, 220,
              125, 217, 119, 209, 116, 196, 115, 185, 114, 172, 114, 167, 112, 161, 109, 165, 107, 170, 99, 171, 97,
              167,
              89, 164, 81, 162,
              77, 155, 81, 148, 87, 140, 96, 138, 105, 141, 110, 136, 111, 126, 113, 129, 118, 117, 128, 114, 137, 115,
              146,
              114, 155, 115,
              158, 121, 157, 128, 156, 134, 157, 136, 156, 136]
    print(len(first))
    print(len(second))
    top = Tk()
    C = Canvas(top, bg="blue", height=400, width=400)
    C.pack()
    for i in range(int(len(first) / 2 - 2)):
        C.create_line(first[i * 2], first[i * 2 + 1], first[i * 2 + 2], first[i * 2 + 3], fill='white')

    for i in range(int(len(second) / 2 - 2)):
        C.create_line(second[i * 2], second[i * 2 + 1], second[i * 2 + 2], second[i * 2 + 3], fill='white')

# top.mainloop()

print()
print()
# bull
def c_10():
    num = "1"
    for i in range(30):
        streak_num = num[0]
        cnt = 0
        sub_num = ""
        for n in num:
            if n is streak_num:
                cnt += 1
            else:
                sub_num += str(cnt) + streak_num
                cnt = 1
                streak_num = n
        sub_num += str(cnt) + streak_num
        num = sub_num
    print(len(num))

# 5808
def c_11():
    image = Image.open("cave.jpg")
    width, height = image.size
    odd_pixels = []

    for y in range(height):
        for x in range(width):
            if x % 2 != 0 and y % 2 != 0:
                pixel = image.getpixel((x, y))
                pixel = list(pixel)
                pixel[0] *= 10
                pixel[1] *= 10
                pixel[2] *= 10
                pixel = tuple(pixel)
                odd_pixels.append(pixel)
    new_image = Image.new('RGB', image.size, (255, 255, 255))

    new_width, new_height = new_image.size
    for y in range(new_height):
        for x in range(new_width):
            if x % 2 != 0 and y % 2 != 0:
                pixel = odd_pixels.pop(0) if odd_pixels else (255, 255, 255)
                new_image.putpixel((x, y), pixel)

    new_image.save('cave_new.jpg')

# evil
def c_12():
    with open("evil2.gfx", 'rb') as file:
        data = file.read()
        for i in range(5):
            with open(f"{i}.jpg", 'wb') as f:
                f.write(data[i::5])

# disproportional
def c_13():
    s = xmlrpc.client.ServerProxy(r"http://www.pythonchallenge.com/pc/phonebook.php")

    print(s.phone("Bert"))

# italy
def c_14():
    w = 100
    h = 100

    with Image.open("wire.png") as f:
        new_image = Image.new(mode="RGB", size=(w, h))
        diraction = 0
        t = 1
        num = 100
        x, y = -1, 0
        cnt = 0
        for i in range(200):  # right 100, down 99, left 99, up 98...
            if t == 2:
                t = 0
                num -= 1
            for j in range(num):
                x += (1 - (diraction // 2) * 2) * (1 - diraction % 2)
                y += (1 - (diraction // 2) * 2) * (diraction % 2)
                new_image.putpixel((x, y), f.getpixel((cnt, 0)))
                cnt += 1
            diraction = (diraction + 1) % 4
            t += 1
        new_image.save("wire2.png")

# uzi
def c_15():
    leaps = []
    for i in range(1006,1997):
        if calendar.isleap(i) and calendar.weekday(i,1,1) == 3 and i%10 == 6:
            leaps.append(i)
    year = leaps[-2]
    print(str(year) + "-j-27: Mozart was born!")

# mozart
def c_16():
    with Image.open("mozart.gif", 'r') as im:
        ans = im.copy()
        px = im.load()

        w, h = im.size
        for i in range(h):
            p = 0
            j = -1
            while p != 195:
                j += 1
                p = px[j, i]
            for l in range(w):
                ans.putpixel((l, i), px[((l + j) % w), i])
        ans.save("mozart_ans.gif")



def main():
    c_3()

if __name__ == '__main__':
    main()