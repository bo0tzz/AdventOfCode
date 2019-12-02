def contains_count(word: str, expected_count: int):
    letters = {}
    for letter in word:
        letters[letter] = letters.setdefault(letter, 0) + 1
    return {letter: count for letter, count in letters.items() if count is expected_count}


with open('in.txt') as puzzle_input:
    two_uniques, three_uniques = 0, 0

    for line in puzzle_input.readlines():
        two_uniques += 1 if contains_count(line, 2) else 0
        three_uniques += 1 if contains_count(line, 3) else 0

    result = two_uniques * three_uniques
    print(result)
