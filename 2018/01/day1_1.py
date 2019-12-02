with open('in.txt') as puzzle_input:
    final_sum = 0
    for line in puzzle_input.readlines():
        final_sum += int(line)
    print(final_sum)
