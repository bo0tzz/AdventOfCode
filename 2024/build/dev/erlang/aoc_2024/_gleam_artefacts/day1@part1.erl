-module(day1@part1).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([run/0]).

-file("/home/boet/git/AdventOfCode/2024/src/day1/part1.gleam", 8).
-spec difference({integer(), integer()}) -> integer().
difference(Tup) ->
    case Tup of
        {L, R} when L > R ->
            L - R;

        {L@1, R@1} when R@1 > L@1 ->
            R@1 - L@1;

        {_, _} ->
            0
    end.

-file("/home/boet/git/AdventOfCode/2024/src/day1/part1.gleam", 16).
-spec run() -> {ok, integer()} | {error, nil}.
run() ->
    {Left, Right} = day1@input:input(),
    Left@1 = gleam@list:sort(Left, fun gleam@int:compare/2),
    Right@1 = gleam@list:sort(Right, fun gleam@int:compare/2),
    _pipe = gleam@list:zip(Left@1, Right@1),
    _pipe@1 = gleam@list:map(_pipe, fun difference/1),
    _pipe@2 = gleam@list:reduce(_pipe@1, fun gleam@int:add/2),
    gleam@io:debug(_pipe@2).
