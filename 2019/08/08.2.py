width = 25
height = 6

with open('in', 'r') as infile:
    line = infile.readline()
    size = width * height
    layers = [line[i:i + size] for i in range(0, len(line), size)]

    pixels = {}
    for i, layer in enumerate(layers):
        rows = [layer[i: i + width] for i in range(0, len(layer), width)]
        for y in range(height):
            for x in range(width):
                px = pixels.get((x, y), {})
                px[i] = rows[y][x]
                pixels[(x, y)] = px

    final_image = {}
    for coord, l in pixels.items():
        for n in range(len(l)):
            val = l[n]
            if val != '2':
                final_image[coord] = val
                break

    for x in range(width+1):
        print('#', end='')
    print('')
    for y in range(height):
        print('#', end='')
        for x in range(width):
            color = final_image[(x, y)]
            if color == '0':
                print('#', end='')
            elif color == '1':
                print(' ', end='')
        print('')
    for x in range(width+1):
        print('#', end='')
