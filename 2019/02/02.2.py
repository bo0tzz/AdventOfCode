import operator


def run_intcode(memory):
    address = 0
    while True:
        instruction = memory[address]
        if instruction == 99:
            return memory
        elif instruction == 1:
            op = operator.add
        elif instruction == 2:
            op = operator.mul
        parameters = memory[address + 1], memory[address + 2], memory[address + 3]
        memory[parameters[2]] = op(memory[parameters[0]], memory[parameters[1]])
        address += 4  # len(instruction + parameters)


def part2_solve(initial_memory):
    for param1 in range(0, 100):
        for param2 in range(0, 100):
            memory = initial_memory.copy()
            memory[1] = param1
            memory[2] = param2
            result_tape = run_intcode(memory)
            if result_tape[0] == 19690720:
                print(100 * param1 + param2)
                return


with open('in', 'r') as infile:
    line = infile.readline()
    initial_memory = list(map(int, line.split(',')))
    part2_solve(initial_memory)
