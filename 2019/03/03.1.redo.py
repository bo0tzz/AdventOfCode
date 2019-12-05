import re

pattern = re.compile(r'(\w)(\d+),?')
offsets = {
    'U': (0, 1), 'R': (1, 0), 'D': (0, -1), 'L': (-1, 0)
}


def parse_wire(wire):
    parts = pattern.findall(wire)
    return [(direction, int(amount)) for direction, amount in parts]


with open('in', 'r') as infile:
    defs = map(parse_wire, infile.readlines())
    wires = {}
    for i, wire in enumerate(defs):
        pos = (0, 0)
        visited = {pos}
        for part in wire:
            direction, distance = part
            m, n = offsets[direction]
            for d in range(distance):
                x, y = pos
                pos = (x + m, y + n)
                visited.add(pos)
        wires[i] = visited
    intersections = wires[0] & wires[1]
    intersections.remove((0, 0))
    distances = map(lambda pos: sum(map(abs, pos)), intersections)
    print(min(distances))
