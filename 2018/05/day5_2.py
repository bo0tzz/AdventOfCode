import string


def equals_different_case(one: str, two: str):
    return one.swapcase() == two


def process_reactions(l: str):
    out = ''
    skip = False
    start_len = len(l)
    for index in range(0, start_len - 1):
        if skip:
            skip = False
            continue
        if not equals_different_case(l[index], l[index + 1]):
            out += l[index]
            continue
        skip = True
    if not skip:
        out += l[-1:]
    return out


def fully_react(poly: str):
    result = process_reactions(poly)
    while len(poly) != len(result):
        poly, result = result, process_reactions(result)
    return result


with open('in.txt') as puzzle_input:
    polymer = fully_react(puzzle_input.readline())
    shortest = polymer
    for char in string.ascii_lowercase:
        print(char)
        current = polymer.replace(char, '').replace(char.swapcase(), '')
        reacted = fully_react(current)
        if len(reacted) < len(shortest):
            shortest = reacted
    print(len(shortest))
