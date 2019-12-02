size = 1000
sheet = [[0 for _ in range(size)] for _ in range(size)]  # Create a 1000x1000 list


def claim(s: list, x: int, y: int, width: int, height: int):
    for h in range(y, y + height):
        r = s[h]  # The row we operate on
        for w in range(x, x + width):
            r[w] += 1
    return s


def parse(instruction: str):
    count, inst = instruction.split('@')
    coords, s = inst.split(':')
    x, y = coords.split(',')
    w, h = s.split('x')
    return int(x), int(y), int(w), int(h)


with open('in.txt') as puzzle_input:
    for line in puzzle_input.readlines():
        claim(sheet, *parse(line))
    final_sum = 0
    for row in sheet:
        for spot in row:
            final_sum += 1 if spot > 1 else 0
    print(final_sum)
