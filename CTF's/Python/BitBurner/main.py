def contract_10460(l, num):
    if len(l) == 0:
        return 0
    if num == 115:
        print(1)
        return 1
    if num + l[-1] > 115:
        return contract_10460(l[:-1], num)
    else:
        return contract_10460(l[:-1], num) + contract_10460(l, num + l[-1])


def main():
    print(contract_10460([1, 2, 3, 4, 5, 6, 9, 10, 12], 0))


if __name__ == '__main__':
    main()
