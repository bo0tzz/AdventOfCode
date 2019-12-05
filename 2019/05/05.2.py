import operator


def as_int(fn):
    def wrapper(*args, **kwargs):
        return int(fn(*args, **kwargs))
    return wrapper


instructions = {
    1: {
        'name': 'add',
        'params': 2,
        'op': operator.add,
        'write': True,
        'jump': False,
    },
    2: {
        'name': 'mul',
        'params': 2,
        'op': operator.mul,
        'write': True,
        'jump': False,
    },
    3: {
        'name': 'input',
        'params': 0,
        'op': as_int(input),
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
        'op': as_int(operator.lt),
        'write': True,
        'jump': False,
    },
    8: {
        'name': 'eq',
        'params': 2,
        'op': as_int(operator.eq),
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


with open('in', 'r') as infile:
    line = infile.readline().split(',')
    pointer = 0
    while True:
        pointer_offset = 1
        instruction = str(line[pointer])

        opcode = int(instruction[-2:])
        operator = instructions[opcode]

        pointer_offset += operator['params']

        param_modes = list(map(int, reversed(instruction[:-2])))
        params = []
        for i in range(operator['params']):
            p = line[pointer + i + 1]
            try:
                mode = param_modes[i]
            except IndexError:
                mode = 0
            param = int(line[int(p)] if mode == 0 else p)
            params.append(param)

        res = operator['op'](*params)

        if operator['write']:
            write_to = int(line[pointer + operator['params'] + 1])
            line[write_to] = res
            pointer_offset += 1

        if operator['jump'] and res != -1:
            pointer = res
        else:
            pointer = pointer + pointer_offset


