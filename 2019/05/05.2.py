import operator as builtin_op


def as_int(fn):
    def wrapper(*args, **kwargs):
        return int(fn(*args, **kwargs))
    return wrapper


@as_int
def ask_input():
    return input('Enter an int: ')


instructions = {
    1: {
        'name': 'add',
        'params': 2,
        'op': builtin_op.add,
        'write': True,
        'jump': False,
    },
    2: {
        'name': 'mul',
        'params': 2,
        'op': builtin_op.mul,
        'write': True,
        'jump': False,
    },
    3: {
        'name': 'input',
        'params': 0,
        'op': ask_input,
        'write': True,
        'jump': False,
    },
    4: {
        'name': 'print',
        'params': 1,
        'op': print,
        'write': False,
        'jump': False,
    },
    5: {
        'name': 'jump-true',
        'params': 2,
        'op': lambda p1, p2: p2 if p1 != 0 else -1,
        'write': False,
        'jump': True,
    },
    6: {
        'name': 'jump-false',
        'params': 2,
        'op': lambda p1, p2: p2 if p1 == 0 else -1,
        'write': False,
        'jump': True,
    },
    7: {
        'name': 'lt',
        'params': 2,
        'op': as_int(builtin_op.lt),
        'write': True,
        'jump': False,
    },
    8: {
        'name': 'eq',
        'params': 2,
        'op': as_int(builtin_op.eq),
        'write': True,
        'jump': False,
    },
    99: {
        'name': 'exit',
        'params': 0,
        'op': exit,
        'write': False,
        'jump': False,
    },
}


def get_params(memory, count, modes, pointer):
    params = []
    for i in range(count):
        p = memory[pointer + i + 1]
        try:
            mode = modes[i]
        except IndexError:
            mode = 0
        param = int(memory[int(p)] if mode == 0 else p)
        params.append(param)
    return params


def parse_instruction(instr):
    instr = str(instr)
    op = instructions[int(instr[-2:])]
    modes = list(map(int, reversed(instr[:-2])))
    return op, modes


def main_loop(memory):
    pointer = 0
    while True:
        pointer_offset = 1
        operator, param_modes = parse_instruction(memory[pointer])

        pointer_offset += operator['params']
        params = get_params(memory, operator['params'], param_modes, pointer)

        res = operator['op'](*params)

        if operator['write']:
            write_to = int(memory[pointer + operator['params'] + 1])
            memory[write_to] = res
            pointer_offset += 1

        if operator['jump'] and res != -1:
            pointer = res
        else:
            pointer = pointer + pointer_offset


with open('in', 'r') as infile:
    line = infile.readline().split(',')
    main_loop(line)
