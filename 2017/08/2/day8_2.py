import re
regex = re.compile("^(\S+)\s(inc|dec)\s(-?[0-9]+)\sif\s(\S+)\s(==|<=|>=|!=|>|<)\s(-?[0-9]+)$")

tests = {
    '>': lambda register, value: register > value,
    '<': lambda register, value: register < value,
    '>=': lambda register, value: register >= value,
    '<=': lambda register, value: register <= value,
    '==': lambda register, value: register == value,
    '!=': lambda register, value: register != value
}

diffs = {
    'inc': lambda value: value,
    'dec': lambda value: -value
}

registers = {}

largestval = 0


def test(register, comparator, value):
    return tests[comparator](register, value)


def processline(line):
    global largestval
    capture = regex.match(line)
    if (test(
            registers.get(capture.group(4), 0),
            capture.group(5),
            int(capture.group(6)))):
        registers[capture.group(1)] = registers.get(capture.group(1), 0) + diffs[capture.group(2)](int(capture.group(3)))
        if registers[capture.group(1)] > largestval:
            largestval = registers[capture.group(1)]


f = open("in.txt")
for l in f:
    processline(l)

print(largestval)

