import re

regex = re.compile(r"<x=(?P<x>-?\d+), y=(?P<y>-?\d+), z=(?P<z>-?\d+)>")


class Moon:
    def __init__(self, string):
        match = regex.match(string)
        self.x = int(match.group('x'))
        self.y = int(match.group('y'))
        self.z = int(match.group('z'))
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

    def potential_energy(self):
        return abs(self.x) + abs(self.y) + abs(self.z)

    def kinetic_energy(self):
        return abs(self.dx) + abs(self.dy) + abs(self.dz)

    def total_energy(self):
        return self.potential_energy() * self.kinetic_energy()

    def __str__(self):
        return f"<x={self.x}, y={self.y}, z={self.z}>"

    def __repr__(self):
        return str(self)


with open('in', 'r') as infile:
    moons = [Moon(s) for s in infile.readlines()]
    for _ in range(1000):
        for moon in moons:
            for other in moons:
                if other is not moon:
                    moon.apply_grav(other)
        for moon in moons:
            moon.step()
    total = sum([m.total_energy() for m in moons])
    print(total)
