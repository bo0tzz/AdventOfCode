import numpy as np
import matplotlib.pyplot as plt
import re
import time


pos_vel_rx = re.compile('position=<\s*([-\d]*),\s*([-\d]*)>\s*velocity=<\s*([-\d]*),\s*([-\d]*)>')


def parse(input: str) -> ((int, int), (int, int)):
    match = pos_vel_rx.match(input)
    g = match.groups()
    return (int(g[0]), int(g[1])), (int(g[2]), int(g[3]))


def parse_lines(lines: list) -> list:
    return [parse(line) for line in lines]


def move(coords: list, vels: list):
    print(coords)
    print(vels)
    new_coords = np.add(coords, vels)
    return list(new_coords)


def run(puzzle_input: list):
    parsed = parse_lines(puzzle_input)
    coordinates, velocities = zip(*parsed)
    x_coords, y_coords = zip(*coordinates)
    x_coords, y_coords = list(x_coords), list(y_coords)
    x_vels, y_vels = zip(*velocities)
    x_vels, y_vels = list(x_vels), list(y_vels)
    plt.ion()
    fig = plt.figure()
    ax = fig.add_subplot(111)
    line, = ax.plot(x_coords, y_coords, 'bo')
    fig.canvas.draw()
    for _ in range(1, 10):
        x_coords = move(x_coords, x_vels)
        y_coords = move(y_coords, y_vels)
        ax.clear()
        ax.plot(x_coords, y_coords, 'bo')
        fig.canvas.draw()
        fig.canvas.flush_events()
        plt.pause(1)


with open('in.txt') as file:
    run(file.readlines())
