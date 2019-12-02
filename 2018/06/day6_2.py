from collections import namedtuple

bounds_tpl = namedtuple('boundaries', 'lower_x lower_y upper_x upper_y')


class Coordinate:

    def __init__(self, identifier: int, x: int, y: int):
        self.identifier = identifier
        self.x = x
        self.y = y

    def distance(self, x: int, y: int):
        x_distance = abs(self.x - x)
        y_distance = abs(self.y - y)
        return x_distance + y_distance

    def __repr__(self) -> str:
        return f"Coordinate(identifier={self.identifier}, x={self.x}, y={self.y})"


def parse_coordinates(unparsed: list) -> list:
    return [Coordinate(index, int(line.split(', ')[0]), int(line.split(', ')[1]))
            for index, line in enumerate(unparsed)]


def find_boundaries(coordinates: list) -> (int, int, int, int):
    first_entry = coordinates[0]
    lower_x, lower_y, upper_x, upper_y = first_entry.x, first_entry.y, first_entry.x, first_entry.y
    for entry in coordinates[1:]:
        lower_x = entry.x if entry.x < lower_x else lower_x
        lower_y = entry.y if entry.y < lower_y else lower_y
        upper_x = entry.x if entry.x > upper_x else upper_x
        upper_y = entry.y if entry.y > upper_y else upper_y
    return bounds_tpl(lower_x, lower_y, upper_x + 2, upper_y + 2)


def create_grid(bounds: bounds_tpl):
    return [
        [None for _ in range(bounds.lower_x, bounds.upper_x)]
        for _ in range(bounds.lower_y, bounds.upper_y)
    ]


def find_closest_origins(grid: list, coordinates: list, boundaries: bounds_tpl):
    output = list(grid)
    for y, row in enumerate(grid):
        for x, point in enumerate(row):
            distances = {coordinate: coordinate.distance(x + boundaries.lower_x, y + boundaries.lower_y)
                         for coordinate in coordinates}
            # If first two entries are the same distance from an input, the value is -1 as a placeholder
            output[y][x] = sum(distances.values())
    return output


def run(puzzle_input):
    coordinates = parse_coordinates([line.strip() for line in puzzle_input])
    boundaries = find_boundaries(coordinates)
    grid = create_grid(boundaries)
    processed = find_closest_origins(grid, coordinates, boundaries)
    region_containing_dist_less_10000_size = 0
    for row in processed:
        for point in row:
            if point < 10000:
                region_containing_dist_less_10000_size += 1
    print(region_containing_dist_less_10000_size)


with open('in.txt') as infile:
    run(infile.readlines())
