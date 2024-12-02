-module(gleam@dict).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([size/1, to_list/1, new/0, is_empty/1, get/2, has_key/2, insert/3, from_list/1, keys/1, values/1, take/2, merge/2, delete/2, drop/2, upsert/3, fold/3, map_values/2, filter/2, each/2, combine/3]).
-export_type([dict/2]).

-type dict(KH, KI) :: any() | {gleam_phantom, KH, KI}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 36).
-spec size(dict(any(), any())) -> integer().
size(Dict) ->
    maps:size(Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 80).
-spec to_list(dict(KR, KS)) -> list({KR, KS}).
to_list(Dict) ->
    maps:to_list(Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 129).
-spec new() -> dict(any(), any()).
new() ->
    maps:new().

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 52).
-spec is_empty(dict(any(), any())) -> boolean().
is_empty(Dict) ->
    Dict =:= maps:new().

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 150).
-spec get(dict(LU, LV), LU) -> {ok, LV} | {error, nil}.
get(From, Get) ->
    gleam_stdlib:map_get(From, Get).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 116).
-spec has_key(dict(LI, any()), LI) -> boolean().
has_key(Dict, Key) ->
    maps:is_key(Key, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 169).
-spec insert(dict(MA, MB), MA, MB) -> dict(MA, MB).
insert(Dict, Key, Value) ->
    maps:put(Key, Value, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 92).
-spec from_list_loop(list({LB, LC}), dict(LB, LC)) -> dict(LB, LC).
from_list_loop(List, Initial) ->
    case List of
        [] ->
            Initial;

        [X | Rest] ->
            from_list_loop(
                Rest,
                insert(Initial, erlang:element(1, X), erlang:element(2, X))
            )
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 88).
-spec from_list(list({KW, KX})) -> dict(KW, KX).
from_list(List) ->
    maps:from_list(List).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 217).
-spec reverse_and_concat(list(NF), list(NF)) -> list(NF).
reverse_and_concat(Remaining, Accumulator) ->
    case Remaining of
        [] ->
            Accumulator;

        [Item | Rest] ->
            reverse_and_concat(Rest, [Item | Accumulator])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 224).
-spec do_keys_loop(list({NJ, any()}), list(NJ)) -> list(NJ).
do_keys_loop(List, Acc) ->
    case List of
        [] ->
            reverse_and_concat(Acc, []);

        [First | Rest] ->
            do_keys_loop(Rest, [erlang:element(1, First) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 212).
-spec keys(dict(NA, any())) -> list(NA).
keys(Dict) ->
    maps:keys(Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 250).
-spec do_values_loop(list({any(), NU}), list(NU)) -> list(NU).
do_values_loop(List, Acc) ->
    case List of
        [] ->
            reverse_and_concat(Acc, []);

        [First | Rest] ->
            do_values_loop(Rest, [erlang:element(2, First) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 245).
-spec values(dict(any(), NP)) -> list(NP).
values(Dict) ->
    maps:values(Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 319).
-spec do_take_loop(dict(OY, OZ), list(OY), dict(OY, OZ)) -> dict(OY, OZ).
do_take_loop(Dict, Desired_keys, Acc) ->
    Insert = fun(Taken, Key) -> case gleam_stdlib:map_get(Dict, Key) of
            {ok, Value} ->
                insert(Taken, Key, Value);

            _ ->
                Taken
        end end,
    case Desired_keys of
        [] ->
            Acc;

        [First | Rest] ->
            do_take_loop(Dict, Rest, Insert(Acc, First))
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 310).
-spec take(dict(OK, OL), list(OK)) -> dict(OK, OL).
take(Dict, Desired_keys) ->
    maps:with(Desired_keys, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 357).
-spec insert_pair(dict(PP, PQ), {PP, PQ}) -> dict(PP, PQ).
insert_pair(Dict, Pair) ->
    insert(Dict, erlang:element(1, Pair), erlang:element(2, Pair)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 361).
-spec fold_inserts(list({PV, PW}), dict(PV, PW)) -> dict(PV, PW).
fold_inserts(New_entries, Dict) ->
    case New_entries of
        [] ->
            Dict;

        [First | Rest] ->
            fold_inserts(Rest, insert_pair(Dict, First))
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 351).
-spec merge(dict(PH, PI), dict(PH, PI)) -> dict(PH, PI).
merge(Dict, New_entries) ->
    maps:merge(Dict, New_entries).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 383).
-spec delete(dict(QC, QD), QC) -> dict(QC, QD).
delete(Dict, Key) ->
    maps:remove(Key, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 411).
-spec drop(dict(QO, QP), list(QO)) -> dict(QO, QP).
drop(Dict, Disallowed_keys) ->
    case Disallowed_keys of
        [] ->
            Dict;

        [First | Rest] ->
            drop(delete(Dict, First), Rest)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 441).
-spec upsert(dict(QV, QW), QV, fun((gleam@option:option(QW)) -> QW)) -> dict(QV, QW).
upsert(Dict, Key, Fun) ->
    _pipe = Dict,
    _pipe@1 = gleam_stdlib:map_get(_pipe, Key),
    _pipe@2 = gleam@option:from_result(_pipe@1),
    _pipe@3 = Fun(_pipe@2),
    insert(Dict, Key, _pipe@3).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 486).
-spec fold_loop(list({RH, RI}), RK, fun((RK, RH, RI) -> RK)) -> RK.
fold_loop(List, Initial, Fun) ->
    case List of
        [] ->
            Initial;

        [{K, V} | Rest] ->
            fold_loop(Rest, Fun(Initial, K, V), Fun)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 478).
-spec fold(dict(RC, RD), RG, fun((RG, RC, RD) -> RG)) -> RG.
fold(Dict, Initial, Fun) ->
    fold_loop(maps:to_list(Dict), Initial, Fun).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 188).
-spec map_values(dict(MM, MN), fun((MM, MN) -> MQ)) -> dict(MM, MQ).
map_values(Dict, Fun) ->
    maps:map(Fun, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 274).
-spec filter(dict(NY, NZ), fun((NY, NZ) -> boolean())) -> dict(NY, NZ).
filter(Dict, Predicate) ->
    maps:filter(Predicate, Dict).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 519).
-spec each(dict(RL, RM), fun((RL, RM) -> any())) -> nil.
each(Dict, Fun) ->
    fold(
        Dict,
        nil,
        fun(Nil, K, V) ->
            Fun(K, V),
            Nil
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/dict.gleam", 540).
-spec combine(dict(RQ, RR), dict(RQ, RR), fun((RR, RR) -> RR)) -> dict(RQ, RR).
combine(Dict, Other, Fun) ->
    fold(
        Dict,
        Other,
        fun(Acc, Key, Value) -> case gleam_stdlib:map_get(Acc, Key) of
                {ok, Other_value} ->
                    insert(Acc, Key, Fun(Value, Other_value));

                {error, _} ->
                    insert(Acc, Key, Value)
            end end
    ).
