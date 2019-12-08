import operator

width = 25
height = 6

with open('in', 'r') as infile:
    line = infile.readline()
    size = width * height
    layers = [line[i:i + size] for i in range(0, len(line), size)]

    layer_zeroes = {}
    for layer in layers:
        zeroes_count = len(list(filter(lambda c: c == '0', layer)))
        d = layer_zeroes.get(zeroes_count, [])
        d.append(layer)
        layer_zeroes[zeroes_count] = d

    slz = sorted(layer_zeroes.items(), key=operator.itemgetter(0))[0]
    one_count, two_count = 0, 0
    for char in slz[1][0]:
        if char == '1':
            one_count += 1
        elif char == '2':
            two_count += 1
    print(one_count * two_count)

