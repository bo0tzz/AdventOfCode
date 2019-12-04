def two_adjacent_same(n):
    num = str(n)
    prev = ''
    adj_same_count = 0
    adj = False
    for digit in num:
        if digit == prev:
            adj_same_count += 1
        else:
            if adj_same_count == 1:
                adj = True
            adj_same_count = 0
        prev = digit
    return adj or adj_same_count == 1


def no_decrease(n):
    num = str(n)
    prev = 0
    no_dec = True
    for digit in num:
        if int(digit) < prev:
            no_dec = False
        prev = int(digit)
    return no_dec


with open('in', 'r') as infile:
    line = infile.readline()
    frm, to = line.split('-')
    rng = range(int(frm), int(to))
    rng = filter(two_adjacent_same, rng)
    rng = filter(no_decrease, rng)
    lst = list(rng)
    print(lst)
    print(len(lst))
