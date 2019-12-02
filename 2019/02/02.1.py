import operator


def process_tape(tape):
    pos = 0
    while True:
        value = tape[pos]
        if value == 99:
            return tape
        elif value == 1:
            op = operator.add
        elif value == 2:
            op = operator.mul
        r1, r2 = tape[pos+1], tape[pos+2]
        target = tape[pos+3]
        tape[target] = op(tape[r1], tape[r2])
        pos += 4


with open('in', 'r') as infile:
    line = infile.readline()
    tape = list(map(int, line.split(',')))
    tape[1] = 12
    tape[2] = 2
    result_tape = process_tape(tape)
    print(result_tape[0])
