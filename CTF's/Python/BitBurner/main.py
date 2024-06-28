import collections
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

def maxScoreWords(words: list[str], letters: list[str], score: list[int]) -> int:
    def dfs(i, cnt):
        if i == len(words):
            return cnt
        # skip the word
        ans = dfs(i + 1, cnt)
        # use the word
        cnt += score[i]
        for c in words[i]:
            if c not in counter or counter[c] == 0:
                return ans
            counter[c] -= 1
        ans = max(ans, dfs(i + 1, cnt))
        for c in words[i]:
            counter[c] += 1
        return ans
    counter = collections.Counter(letters)
    return dfs(0, 0)
def main():
    print(maxScoreWords(["dog","cat","dad","good"], ["a","a","c","d","d","d","g","o","o"], [1,0,9,5,0,0,3,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0]))


if __name__ == '__main__':
    main()
