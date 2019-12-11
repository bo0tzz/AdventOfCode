from fractions import Fraction


def sign(num):
    if num < 0:
        return -1
    elif num > 0:
        return 1
    return 0


def whole_intermediate_points_between(start, end):
    start_x, start_y = start
    end_x, end_y = end
    x_change = end_x - start_x
    y_change = end_y - start_y
    if x_change == 0:
        # Special case? x stays the same
        for y in range(0, y_change, sign(y_change)):
            point = (start_x, start_y + y)
            if not point == start or point == end:
                yield point
    else:
        ror = y_change / x_change
        for x in range(0, x_change, sign(x_change)):
            y = x * ror
            if y.is_integer():
                point = (start_x + x, start_y + int(y))
                if not point == start or point == end:
                    yield point


def parse_line(l):
    return list(map(lambda c: c == '#', l.strip()))


def all_asteroids(g):
    for y, line in enumerate(g):
        for x, point in enumerate(line):
            if point:
                yield x, y


def keyfunc(base):
    def mhd(asteroid):
        bx, by = base
        ax, ay = asteroid
        return abs(bx - ax) + abs(by - ay)
    return mhd


with open('in', 'r') as infile:
    lines = infile.readlines()
    grid = list(map(parse_line, lines))
    sightlines = {}
    for asteroid in all_asteroids(grid):
        can_see = []
        for other in all_asteroids(grid):
            if not other == asteroid:
                points_between = whole_intermediate_points_between(asteroid, other)
                can_see_other = not any([grid[y][x] for x, y in points_between])
                if can_see_other:
                    can_see.append(other)
        sightlines[asteroid] = can_see
    best, seen = None, 0
    for asteroid, can_see in sightlines.items():
        if len(can_see) > seen:
            best = asteroid
            seen = len(can_see)
    slopes_left, slopes_right = {}, {}
    above, below = [], []
    bx, by = best
    for asteroid in all_asteroids(grid):
        ax, ay = asteroid
        dx = bx - ax
        dy = by - ay
        if dx == 0:
            if dy > 0:
                above.append(asteroid)
            elif dy < 0:
                below.append(asteroid)
        elif dx > 0:
            slope = Fraction(dy, dx)
            l = slopes_left.get(slope, [])
            l.append(asteroid)
            slopes_left[slope] = l
        elif dx < 0:
            slope = Fraction(dy, dx)
            l = slopes_right.get(slope, [])
            l.append(asteroid)
            slopes_right[slope] = l
    above = sorted(above, key=keyfunc(best))
    below = sorted(below, key=keyfunc(best))



