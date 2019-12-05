import operator

instructions = {
    1: {
        'name': 'add',
        'params': 2,
        'op': operator.add,
        'write': True,
    },
    2: {
        'name': 'mul',
        'params': 2,
        'op': operator.mul,
        'write': True,
    },
    3: {
        'name': 'input',
        'params': 0,
        'op': lambda: int(input('Input an int: ')),
        'write': True,
    },
    4: {
        'name': 'print',
        'params': 1,
        'op': print,
        'write': False,
    },
    99: {
        'name': 'exit',
        'params': 0,
        'op': exit,
        'write': False,
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

        pointer = pointer + pointer_offset

