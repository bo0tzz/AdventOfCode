def two_adjacent_same(n):
    num = str(n)
    prev = ''
    adj = False
    for digit in num:
        adj = adj or (digit == prev)
        prev = digit
    return adj


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
    print(len(lst))
