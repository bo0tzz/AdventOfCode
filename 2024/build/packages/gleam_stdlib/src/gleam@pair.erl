-module(gleam@pair).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([first/1, second/1, swap/1, map_first/2, map_second/2, new/2]).

-file("/Users/louis/src/gleam/stdlib/src/gleam/pair.gleam", 10).
-spec first({XH, any()}) -> XH.
first(Pair) ->
    {A, _} = Pair,
    A.

-file("/Users/louis/src/gleam/stdlib/src/gleam/pair.gleam", 24).
-spec second({any(), XK}) -> XK.
second(Pair) ->
    {_, A} = Pair,
    A.

-file("/Users/louis/src/gleam/stdlib/src/gleam/pair.gleam", 38).
-spec swap({XL, XM}) -> {XM, XL}.
swap(Pair) ->
    {A, B} = Pair,
    {B, A}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/pair.gleam", 53).
-spec map_first({XN, XO}, fun((XN) -> XP)) -> {XP, XO}.
map_first(Pair, Fun) ->
    {A, B} = Pair,
    {Fun(A), B}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/pair.gleam", 68).
-spec map_second({XQ, XR}, fun((XR) -> XS)) -> {XQ, XS}.
map_second(Pair, Fun) ->
    {A, B} = Pair,
    {A, Fun(B)}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/pair.gleam", 83).
-spec new(XT, XU) -> {XT, XU}.
new(First, Second) ->
    {First, Second}.
