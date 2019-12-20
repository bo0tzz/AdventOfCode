import itertools

BASE_PATTERN = [0, 1, 0, -1]


def pattern_for(idx):
    pat = []
    for p in BASE_PATTERN:
        for _ in range(idx):
            pat.append(p)
    return itertools.cycle(pat)


def map_op(tup):
    i, j = tup
    return i * j


def zippy(sig, pat):
    sigi = iter(sig)
    pati = iter(pat)
    next(pati)  # We wanna skip the first elem
    try:
        while True:
            yield next(sigi), next(pati)
    except StopIteration:
        pass


with open('in', 'r') as infile:
    ln = infile.readline()
    signal = list(map(int, list(ln)))
    for _ in range(100):
        target = []
        for i, elem in enumerate(signal):
            pattern = pattern_for(i + 1)
            zipped = list(zippy(signal, pattern))
            mapped = list(map(map_op, zipped))
            summed = sum(mapped)
            final = int(str(summed)[-1:])
            target.append(final)
        signal = target
    print(signal[:8])
