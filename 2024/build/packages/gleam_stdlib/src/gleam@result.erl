-module(gleam@result).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([is_ok/1, is_error/1, map/2, map_error/2, flatten/1, 'try'/2, then/2, unwrap/2, lazy_unwrap/2, unwrap_error/2, unwrap_both/1, 'or'/2, lazy_or/2, all/1, partition/1, replace/2, replace_error/2, nil_error/1, values/1, try_recover/2]).

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 20).
-spec is_ok({ok, any()} | {error, any()}) -> boolean().
is_ok(Result) ->
    case Result of
        {error, _} ->
            false;

        {ok, _} ->
            true
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 41).
-spec is_error({ok, any()} | {error, any()}) -> boolean().
is_error(Result) ->
    case Result of
        {ok, _} ->
            false;

        {error, _} ->
            true
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 66).
-spec map({ok, BVH} | {error, BVI}, fun((BVH) -> BVL)) -> {ok, BVL} |
    {error, BVI}.
map(Result, Fun) ->
    case Result of
        {ok, X} ->
            {ok, Fun(X)};

        {error, E} ->
            {error, E}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 91).
-spec map_error({ok, BVO} | {error, BVP}, fun((BVP) -> BVS)) -> {ok, BVO} |
    {error, BVS}.
map_error(Result, Fun) ->
    case Result of
        {ok, X} ->
            {ok, X};

        {error, Error} ->
            {error, Fun(Error)}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 120).
-spec flatten({ok, {ok, BVV} | {error, BVW}} | {error, BVW}) -> {ok, BVV} |
    {error, BVW}.
flatten(Result) ->
    case Result of
        {ok, X} ->
            X;

        {error, Error} ->
            {error, Error}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 158).
-spec 'try'({ok, BWD} | {error, BWE}, fun((BWD) -> {ok, BWH} | {error, BWE})) -> {ok,
        BWH} |
    {error, BWE}.
'try'(Result, Fun) ->
    case Result of
        {ok, X} ->
            Fun(X);

        {error, E} ->
            {error, E}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 170).
-spec then({ok, BWM} | {error, BWN}, fun((BWM) -> {ok, BWQ} | {error, BWN})) -> {ok,
        BWQ} |
    {error, BWN}.
then(Result, Fun) ->
    'try'(Result, Fun).

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 192).
-spec unwrap({ok, BWV} | {error, any()}, BWV) -> BWV.
unwrap(Result, Default) ->
    case Result of
        {ok, V} ->
            V;

        {error, _} ->
            Default
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 214).
-spec lazy_unwrap({ok, BWZ} | {error, any()}, fun(() -> BWZ)) -> BWZ.
lazy_unwrap(Result, Default) ->
    case Result of
        {ok, V} ->
            V;

        {error, _} ->
            Default()
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 236).
-spec unwrap_error({ok, any()} | {error, BXE}, BXE) -> BXE.
unwrap_error(Result, Default) ->
    case Result of
        {ok, _} ->
            Default;

        {error, E} ->
            E
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 258).
-spec unwrap_both({ok, BXH} | {error, BXH}) -> BXH.
unwrap_both(Result) ->
    case Result of
        {ok, A} ->
            A;

        {error, A@1} ->
            A@1
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 308).
-spec 'or'({ok, BXQ} | {error, BXR}, {ok, BXQ} | {error, BXR}) -> {ok, BXQ} |
    {error, BXR}.
'or'(First, Second) ->
    case First of
        {ok, _} ->
            First;

        {error, _} ->
            Second
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 341).
-spec lazy_or({ok, BXY} | {error, BXZ}, fun(() -> {ok, BXY} | {error, BXZ})) -> {ok,
        BXY} |
    {error, BXZ}.
lazy_or(First, Second) ->
    case First of
        {ok, _} ->
            First;

        {error, _} ->
            Second()
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 367).
-spec all(list({ok, BYG} | {error, BYH})) -> {ok, list(BYG)} | {error, BYH}.
all(Results) ->
    gleam@list:try_map(Results, fun(X) -> X end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 387).
-spec partition_loop(list({ok, BYV} | {error, BYW}), list(BYV), list(BYW)) -> {list(BYV),
    list(BYW)}.
partition_loop(Results, Oks, Errors) ->
    case Results of
        [] ->
            {Oks, Errors};

        [{ok, A} | Rest] ->
            partition_loop(Rest, [A | Oks], Errors);

        [{error, E} | Rest@1] ->
            partition_loop(Rest@1, Oks, [E | Errors])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 383).
-spec partition(list({ok, BYO} | {error, BYP})) -> {list(BYO), list(BYP)}.
partition(Results) ->
    partition_loop(Results, [], []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 409).
-spec replace({ok, any()} | {error, BZE}, BZH) -> {ok, BZH} | {error, BZE}.
replace(Result, Value) ->
    case Result of
        {ok, _} ->
            {ok, Value};

        {error, Error} ->
            {error, Error}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 430).
-spec replace_error({ok, BZK} | {error, any()}, BZO) -> {ok, BZK} | {error, BZO}.
replace_error(Result, Error) ->
    case Result of
        {ok, X} ->
            {ok, X};

        {error, _} ->
            {error, Error}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 280).
-spec nil_error({ok, BXK} | {error, any()}) -> {ok, BXK} | {error, nil}.
nil_error(Result) ->
    replace_error(Result, nil).

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 446).
-spec values(list({ok, BZR} | {error, any()})) -> list(BZR).
values(Results) ->
    gleam@list:filter_map(Results, fun(R) -> R end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/result.gleam", 479).
-spec try_recover(
    {ok, BZX} | {error, BZY},
    fun((BZY) -> {ok, BZX} | {error, CAB})
) -> {ok, BZX} | {error, CAB}.
try_recover(Result, Fun) ->
    case Result of
        {ok, Value} ->
            {ok, Value};

        {error, Error} ->
            Fun(Error)
    end.
