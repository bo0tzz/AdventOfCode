import re
from math import gcd

regex = re.compile(r"<x=(?P<x>-?\d+), y=(?P<y>-?\d+), z=(?P<z>-?\d+)>")


class Moon:
    def __init__(self, x=0, y=0, z=0):
        self.x = x
        self.y = y
        self.z = z
        self.dx, self.dy, self.dz = 0, 0, 0

    def apply_grav(self, to):
        if self.x > to.x:
            self.dx -= 1
        elif self.x < to.x:
            self.dx += 1
        if self.y > to.y:
            self.dy -= 1
        elif self.y < to.y:
            self.dy += 1
        if self.z > to.z:
            self.dz -= 1
        elif self.z < to.z:
            self.dz += 1

    def step(self):
        self.x += self.dx
        self.y += self.dy
        self.z += self.dz

    def __str__(self):
        return f"<x={self.x}, y={self.y}, z={self.z}>"

    def __repr__(self):
        return str(self)


def compare(i, j):
    if i > j:
        return -1
    elif i < j:
        return 1
    else:
        return 0


with open('in', 'r') as infile:
    parsed = [regex.match(l) for l in infile.readlines()]
    moons = [(int(match.group('x')), int(match.group('y')), int(match.group('z'))) for match in parsed]

    steps = []
    for d in range(3):
        values = [t[d] for t in moons]
        velos = [0 for _ in values]
        step = 0
        seen = []
        initial_state = (values.copy(), velos.copy())
        while True:
            for i, v in enumerate(values):
                for j, w in enumerate(values):
                    if i != j:
                        velos[i] += compare(v, w)
            for i, v in enumerate(velos):
                values[i] += v
            step += 1
            if initial_state == (values, velos):
                break
        steps.append(step)
    lcm = steps[0]
    for i in steps[1:]:
        lcm = lcm * i // gcd(lcm, i)
    print(lcm)
