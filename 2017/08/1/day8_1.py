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


def test(register, comparator, value):
    return tests[comparator](register, value)


def processline(line):
    capture = regex.match(line)
    for group in capture.groups():
        print(group)
    if (test(
            registers.get(capture.group(4), 0),
            capture.group(5),
            int(capture.group(6)))):
        registers[capture.group(1)] = registers.get(capture.group(1), 0) + diffs[capture.group(2)](int(capture.group(3)))


f = open("in.txt")
for line in f:
    processline(line)

largestval = 0
print(registers)
for k, v in registers.items():
    if v > largestval:
        largestval = v

print(largestval)

