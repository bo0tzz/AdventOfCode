import re
import itertools


input_re = re.compile('(\\d*) players; last marble is worth (\\d*) points')


def parse_input(ipt: str) -> (int, int):
    groups = input_re.match(ipt).groups()
    return int(groups[0]), int(groups[1])


def insert_next_clockwise(marbles: list, current_index: int, to_insert: int):
    return marbles.insert(current_index % len(marbles), to_insert)


def remove_seven_ccw(marbles: list, current_index: int) -> int:
    return marbles.pop(current_index % len(marbles))


def find_highest_score(players: dict) -> (int, int):
    highest_scoring = (-1, 0)
    for player in players.items():
        if player[1] > highest_scoring[1]:
            highest_scoring = player
    return highest_scoring


def process(player_count: int, max_points: int) -> (int, int):  # Returns the winning player and their score
    players = {player: 0 for player in range(1, player_count + 1)}
    player_cycle = itertools.cycle(players)
    marbles = [0]
    current_index = 0
    for to_place in range(1, max_points):
        current_player = next(player_cycle)
        if to_place == 1:
            marbles.append(to_place)
            current_index = 1
        elif to_place % 23 == 0:
            current_index = (current_index - 7) % len(marbles)
            players[current_player] += to_place + marbles.pop(current_index)
        else:
            current_index = (current_index + 2
                             if current_index + 2 == len(marbles)
                             else (current_index + 2) % (len(marbles)))
            marbles.insert(current_index, to_place)
    return find_highest_score(players)


def run(puzzle_input: str):
    players, max_points = parse_input(puzzle_input)
    player, score = process(players, max_points)
    print(f"Player {player} got the highest score at {score} points.")


with open('in.txt') as infile:
    run(infile.readline())
