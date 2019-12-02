def levenshtein(one: str, two: str):
    distance = 0
    for i, ltr in enumerate(one):
        distance += 0 if ltr == two[i] else 1
    return distance


def find_similar_words(words: list, distance: int):
    for word in words:
        for other_word in words:
            dist = levenshtein(word, other_word)
            if dist == distance:
                return word, other_word


with open('in.txt') as puzzle_input:
    lines = [line.strip('\n') for line in puzzle_input.readlines()]
    first, second = find_similar_words(lines, 1)
    joined = ''
    for index, letter in enumerate(first):
        joined += letter if letter == second[index] else ''
    print(joined)
