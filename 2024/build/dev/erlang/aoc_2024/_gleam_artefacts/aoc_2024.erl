-module(aoc_2024).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([main/0]).

-file("/home/boet/git/AdventOfCode/2024/src/aoc_2024.gleam", 4).
-spec main() -> {ok, integer()} | {error, nil}.
main() ->
    day1@part1:run().
