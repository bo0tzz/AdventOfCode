# Jesus christ what an absolute fucking mess
# This is a failed attempt - disregard
import re

pattern = re.compile(r'(\w)(\d+),?')


def parse_wire(wire):
    parts = pattern.findall(wire)
    return [(direction, int(amount)) for direction, amount in parts]


def visit_point(visited, x, y, current_wire_index, current_step):
    # print_grid(visited)
    loc = visited.get((x, y), {})
    if loc.get(current_wire_index, None):
        return 0
    loc[current_wire_index] = current_step
    visited[x, y] = loc
    return 1


def print_grid(visited):
    grid = [['.' for _ in range(-40, 250)] for _ in range(-40, 250)]
    for loc, visitors in visited.items():
        x, y = loc
        char = '.'
        if (x, y) == (0, 0):
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
        current_step = 0
        for direction, amount in wire:
            if direction == 'U':  # Up
                for new_y in range(y, y+amount+1):
                    step_incr = visit_point(visited, x, new_y, current_wire_index, current_step)
                    current_step += step_incr
                y += amount
            if direction == 'R':  # Right
                for new_x in range(x, x+amount+1):
                    step_incr = visit_point(visited, new_x, y, current_wire_index, current_step)
                    current_step += step_incr
                x += amount
            if direction == 'D':  # Down
                for new_y in range(y, y-amount, -1):
                    step_incr = visit_point(visited, x, new_y, current_wire_index, current_step)
                    current_step += step_incr
                y -= amount
            if direction == 'L':  # Left
                for new_x in range(x, x-amount, -1):
                    step_incr = visit_point(visited, new_x, y, current_wire_index, current_step)
                    current_step += step_incr
                x -= amount
        current_wire_index += 1
    best = 1000000000
    for loc, visitors in visited.items():
        if loc == (0, 0):
            continue
        if len(visitors) > 1:
            print(f'Considering {loc} with steps total {sum(visitors.values())}')
            best = min(best, sum(visitors.values()))
    # print_grid(visited)
    print(best)
