size = 1000
sheet = [[0 for _ in range(size)] for _ in range(size)]  # Create a 1000x1000 list


def claim(s: list, x: int, y: int, width: int, height: int):
    for h in range(y, y + height):
        r = s[h]  # The row we operate on
        for w in range(x, x + width):
            r[w] += 1
    return s


def overlaps(s: list, x: int, y: int, width: int, height: int):
    has_overlap = False
    for h in range(y, y + height):
        r = s[h]  # The row we operate on
        for w in range(x, x + width):
            if r[w] > 1:
                has_overlap = True
    return has_overlap


def parse(instruction: str):
    count, inst = instruction.split('@')
    coords, s = inst.split(':')
    x, y = coords.split(',')
    w, h = s.split('x')
    return int(count[1:]), (int(x), int(y), int(w), int(h))


with open('in.txt') as puzzle_input:
    instructions = [parse(line) for line in puzzle_input.readlines()]
    for i in instructions:
        claim(sheet, *i[1])
    for i in instructions:
        if not overlaps(sheet, *i[1]):
            print(i[0])
