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
    steppings = {}
    for i, wire in enumerate(defs):
        pos = (0, 0)
        step = 0
        visited = {pos}
        stepped = {pos: step}
        for part in wire:
            direction, distance = part
            m, n = offsets[direction]
            for d in range(distance):
                step += 1
                x, y = pos
                pos = (x + m, y + n)
                visited.add(pos)
                step_point = stepped.get(pos, -1)
                if step_point == -1:
                    stepped[pos] = step
        wires[i] = visited
        steppings[i] = stepped
    intersections = wires[0] & wires[1]
    intersections.remove((0, 0))
    pivot = {}
    for wire, steps in steppings.items():
        for coord, step in steps.items():
            c = pivot.get(coord, {})
            c[wire] = step
            pivot[coord] = c
    pivot.pop((0, 0))
    pivot = {c: l for c, l in pivot.items() if len(l) > 1}

    step_totals = []
    for l in pivot.values():
        step_totals.append(sum(l.values()))
    print(min(step_totals))
