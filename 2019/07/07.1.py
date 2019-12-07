import itertools
import operator as builtin_op


def as_int(fn):
    def wrapper(*args, **kwargs):
        return int(fn(*args, **kwargs))

    return wrapper


@as_int
def ask_input():
    return input('Enter an int: ')


class Computer:
    instructions = {
        1: {
            'code': 1,
            'name': 'add',
            'params': 2,
            'op': builtin_op.add,
            'write': True,
            'jump': False,
        },
        2: {
            'code': 2,
            'name': 'mul',
            'params': 2,
            'op': builtin_op.mul,
            'write': True,
            'jump': False,
        },
        3: {
            'code': 3,
            'name': 'input',
            'params': 0,
            'op': ask_input,
            'write': True,
            'jump': False,
        },
        4: {
            'code': 4,
            'name': 'print',
            'params': 1,
            'op': print,
            'write': False,
            'jump': False,
        },
        5: {
            'code': 5,
            'name': 'jump-true',
            'params': 2,
            'op': lambda p1, p2: p2 if p1 != 0 else -1,
            'write': False,
            'jump': True,
        },
        6: {
            'code': 6,
            'name': 'jump-false',
            'params': 2,
            'op': lambda p1, p2: p2 if p1 == 0 else -1,
            'write': False,
            'jump': True,
        },
        7: {
            'code': 7,
            'name': 'lt',
            'params': 2,
            'op': as_int(builtin_op.lt),
            'write': True,
            'jump': False,
        },
        8: {
            'code': 8,
            'name': 'eq',
            'params': 2,
            'op': as_int(builtin_op.eq),
            'write': True,
            'jump': False,
        },
        99: {
            'code': 99,
            'name': 'exit',
            'params': 0,
            'op': exit,
            'write': False,
            'jump': False,
        },
    }

    def opt(self, o):
        self.output.append(o)

    def __init__(self, memory, inpipe=None):
        self.memory = memory.copy()
        self.initial_memory = memory.copy()
        self.pointer = 0
        self.output = []
        if inpipe:
            input_op = lambda: inpipe.pop(0)
            output_op = self.opt
        else:
            input_op = ask_input
            output_op = print
        self.instructions[3]['op'] = input_op
        self.instructions[4]['op'] = output_op

    def get_params(self, count, modes):
        params = []
        for i in range(count):
            p = self.memory[self.pointer + i + 1]
            try:
                mode = modes[i]
            except IndexError:
                mode = 0
            param = int(self.memory[int(p)] if mode == 0 else p)
            params.append(param)
        return params

    def parse_instruction(self, instr):
        instr = str(instr)
        op = self.instructions[int(instr[-2:])]
        modes = list(map(int, reversed(instr[:-2])))
        return op, modes

    def run(self):
        while True:
            pointer_offset = 1
            operator, param_modes = self.parse_instruction(self.memory[self.pointer])

            pointer_offset += operator['params']
            params = self.get_params(operator['params'], param_modes)

            if operator['code'] == 99:
                return self.output
            res = operator['op'](*params)

            if operator['write']:
                write_to = int(self.memory[self.pointer + operator['params'] + 1])
                self.memory[write_to] = res
                pointer_offset += 1

            if operator['jump'] and res != -1:
                self.pointer = res
            else:
                self.pointer = self.pointer + pointer_offset


with open('in', 'r') as infile:
    program = infile.readline().split(',')
    permutations = itertools.permutations((0, 1, 2, 3, 4))
    max_signal = 0
    for permutation in permutations:
        outputs = []
        for phase in permutation:
            inpt = outputs.pop() if outputs else [0]
            computer = Computer(program, [phase, *inpt])
            output = computer.run()
            outputs.append(output)
        max_signal = max(max_signal, outputs.pop()[0])
    print(max_signal)
