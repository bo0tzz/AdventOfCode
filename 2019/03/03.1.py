# Jesus christ what an absolute fucking mess
import re

pattern = re.compile(r'(\w)(\d+),?')


def parse_wire(wire):
    parts = pattern.findall(wire)
    return [(direction, int(amount)) for direction, amount in parts]


def visit_point(visited, x, y, current_wire_index):
    # print_grid(visited)
    loc = visited.get((x, y), set())
    loc.add(current_wire_index)
    visited[x, y] = loc


def print_grid(visited, closest):
    grid = [['.' for _ in range(-40, 250)] for _ in range(-40, 250)]
    for loc, visitors in visited.items():
        x, y = loc
        char = '.'
        if (x, y) == closest:
            char = '!'
        elif (x, y) == (0, 0):
            char = 'X'
        else:
            char = sum(visitors)
        grid[y+40][x+40] = char
    for line in reversed(grid):
        for point in line:
            print(point, end='')
        print('')


with open('in', 'r') as infile:
    lines = infile.readlines()
    wires = map(parse_wire, lines)
    visited = {}
    current_wire_index = 1
    for wire in wires:
        x, y = 0, 0
        for direction, amount in wire:
            if direction == 'U':  # Up
                for new_y in range(y, y+amount+1):
                    visit_point(visited, x, new_y, current_wire_index)
                y += amount
            if direction == 'R':  # Right
                for new_x in range(x, x+amount+1):
                    visit_point(visited, new_x, y, current_wire_index)
                x += amount
            if direction == 'D':  # Down
                for new_y in range(y, y-amount, -1):
                    visit_point(visited, x, new_y, current_wire_index)
                y -= amount
            if direction == 'L':  # Left
                for new_x in range(x, x-amount, -1):
                    visit_point(visited, new_x, y, current_wire_index)
                x -= amount
        current_wire_index += 1
    closest = None
    for loc, visitors in visited.items():
        if loc == (0, 0):
            continue
        loc = tuple(map(abs, loc))
        if len(visitors) > 1:
            if not closest or sum(closest) > sum(loc):
                closest = loc
    # print_grid(visited, closest)
    print(closest, sum(closest))
