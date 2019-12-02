def find_first_reached_twice(lines):
    counter = 0
    reached_frequencies = {0}
    while True:
        for line in lines:
            counter += int(line)
            if counter in reached_frequencies:
                return counter
            reached_frequencies.add(counter)


with open('in.txt') as puzzle_input:
    res = find_first_reached_twice(puzzle_input.readlines())
    print(res)
