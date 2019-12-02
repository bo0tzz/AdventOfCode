def power_level(x: int, y: int, grid_serial: int) -> int:
    return ((((((x + 10) * y) + grid_serial) * (x + 10)) // 100) % 10) - 5


def power_for_3x3_grid(x: int, y: int, grid_serial: int) -> int:
    total_power = 0
    for i in range(x, x+3):
        for j in range(y, y+3):
            total_power += power_level(i, j, grid_serial)
    return total_power


def run(grid_serial: int):
    largest_x, largest_y, largest_power = -1, -1, -1
    for x in range(1, 299):
        for y in range(1, 299):
            power_for_grid = power_for_3x3_grid(x, y, grid_serial)
            if power_for_grid > largest_power:
                largest_x, largest_y, largest_power = x, y, power_for_grid
    print(f"({largest_x},{largest_y})")


with open('in.txt') as file:
    run(int(file.readline()))
