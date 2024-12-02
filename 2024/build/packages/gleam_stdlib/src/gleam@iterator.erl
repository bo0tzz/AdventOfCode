-module(gleam@iterator).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([unfold/2, repeatedly/1, repeat/1, from_list/1, transform/3, fold/3, run/1, to_list/1, step/1, take/2, drop/2, map/2, map2/3, append/2, flatten/1, concat/1, flat_map/2, filter/2, filter_map/2, cycle/1, find/2, find_map/2, index/1, iterate/2, take_while/2, drop_while/2, scan/3, zip/2, chunk/2, sized_chunk/2, intersperse/2, any/2, all/2, group/2, reduce/2, last/1, empty/0, once/1, range/2, single/1, interleave/2, fold_until/3, try_fold/3, first/1, at/2, length/1, each/2, yield/2]).
-export_type([action/1, iterator/1, step/2, chunk/2, sized_chunk/1]).

-type action(DRA) :: stop | {continue, DRA, fun(() -> action(DRA))}.

-opaque iterator(DRB) :: {iterator, fun(() -> action(DRB))}.

-type step(DRC, DRD) :: {next, DRC, DRD} | done.

-type chunk(DRE, DRF) :: {another_by,
        list(DRE),
        DRF,
        DRE,
        fun(() -> action(DRE))} |
    {last_by, list(DRE)}.

-type sized_chunk(DRG) :: {another, list(DRG), fun(() -> action(DRG))} |
    {last, list(DRG)} |
    no_more.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 39).
-spec stop() -> action(any()).
stop() ->
    stop.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 75).
-spec unfold_loop(DRO, fun((DRO) -> step(DRP, DRO))) -> fun(() -> action(DRP)).
unfold_loop(Initial, F) ->
    fun() -> case F(Initial) of
            {next, X, Acc} ->
                {continue, X, unfold_loop(Acc, F)};

            done ->
                stop
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 65).
-spec unfold(DRJ, fun((DRJ) -> step(DRK, DRJ))) -> iterator(DRK).
unfold(Initial, F) ->
    _pipe = Initial,
    _pipe@1 = unfold_loop(_pipe, F),
    {iterator, _pipe@1}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 98).
-spec repeatedly(fun(() -> DRT)) -> iterator(DRT).
repeatedly(F) ->
    unfold(nil, fun(_) -> {next, F(), nil} end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 114).
-spec repeat(DRV) -> iterator(DRV).
repeat(X) ->
    repeatedly(fun() -> X end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 129).
-spec from_list(list(DRX)) -> iterator(DRX).
from_list(List) ->
    Yield = fun(Acc) -> case Acc of
            [] ->
                done;

            [Head | Tail] ->
                {next, Head, Tail}
        end end,
    unfold(List, Yield).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 140).
-spec transform_loop(
    fun(() -> action(DSA)),
    DSC,
    fun((DSC, DSA) -> step(DSD, DSC))
) -> fun(() -> action(DSD)).
transform_loop(Continuation, State, F) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, El, Next} ->
                case F(State, El) of
                    done ->
                        stop;

                    {next, Yield, Next_state} ->
                        {continue, Yield, transform_loop(Next, Next_state, F)}
                end
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 176).
-spec transform(iterator(DSH), DSJ, fun((DSJ, DSH) -> step(DSK, DSJ))) -> iterator(DSK).
transform(Iterator, Initial, F) ->
    _pipe = transform_loop(erlang:element(2, Iterator), Initial, F),
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 212).
-spec fold_loop(fun(() -> action(DSR)), fun((DST, DSR) -> DST), DST) -> DST.
fold_loop(Continuation, F, Accumulator) ->
    case Continuation() of
        {continue, Elem, Next} ->
            fold_loop(Next, F, F(Accumulator, Elem));

        stop ->
            Accumulator
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 203).
-spec fold(iterator(DSO), DSQ, fun((DSQ, DSO) -> DSQ)) -> DSQ.
fold(Iterator, Initial, F) ->
    _pipe = erlang:element(2, Iterator),
    fold_loop(_pipe, F, Initial).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 229).
-spec run(iterator(any())) -> nil.
run(Iterator) ->
    fold(Iterator, nil, fun(_, _) -> nil end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 248).
-spec to_list(iterator(DSW)) -> list(DSW).
to_list(Iterator) ->
    _pipe = Iterator,
    _pipe@1 = fold(_pipe, [], fun(Acc, E) -> [E | Acc] end),
    lists:reverse(_pipe@1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 277).
-spec step(iterator(DSZ)) -> step(DSZ, iterator(DSZ)).
step(Iterator) ->
    case (erlang:element(2, Iterator))() of
        stop ->
            done;

        {continue, E, A} ->
            {next, E, {iterator, A}}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 311).
-spec take_loop(fun(() -> action(DTH)), integer()) -> fun(() -> action(DTH)).
take_loop(Continuation, Desired) ->
    fun() -> case Desired > 0 of
            false ->
                stop;

            true ->
                case Continuation() of
                    stop ->
                        stop;

                    {continue, E, Next} ->
                        {continue, E, take_loop(Next, Desired - 1)}
                end
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 305).
-spec take(iterator(DTE), integer()) -> iterator(DTE).
take(Iterator, Desired) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = take_loop(_pipe, Desired),
    {iterator, _pipe@1}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 355).
-spec drop_loop(fun(() -> action(DTN)), integer()) -> action(DTN).
drop_loop(Continuation, Desired) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            case Desired > 0 of
                true ->
                    drop_loop(Next, Desired - 1);

                false ->
                    {continue, E, Next}
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 350).
-spec drop(iterator(DTK), integer()) -> iterator(DTK).
drop(Iterator, Desired) ->
    _pipe = fun() -> drop_loop(erlang:element(2, Iterator), Desired) end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 390).
-spec map_loop(fun(() -> action(DTU)), fun((DTU) -> DTW)) -> fun(() -> action(DTW)).
map_loop(Continuation, F) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, E, Continuation@1} ->
                {continue, F(E), map_loop(Continuation@1, F)}
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 384).
-spec map(iterator(DTQ), fun((DTQ) -> DTS)) -> iterator(DTS).
map(Iterator, F) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = map_loop(_pipe, F),
    {iterator, _pipe@1}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 432).
-spec map2_loop(
    fun(() -> action(DUE)),
    fun(() -> action(DUG)),
    fun((DUE, DUG) -> DUI)
) -> fun(() -> action(DUI)).
map2_loop(Continuation1, Continuation2, Fun) ->
    fun() -> case Continuation1() of
            stop ->
                stop;

            {continue, A, Next_a} ->
                case Continuation2() of
                    stop ->
                        stop;

                    {continue, B, Next_b} ->
                        {continue, Fun(A, B), map2_loop(Next_a, Next_b, Fun)}
                end
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 423).
-spec map2(iterator(DTY), iterator(DUA), fun((DTY, DUA) -> DUC)) -> iterator(DUC).
map2(Iterator1, Iterator2, Fun) ->
    _pipe = map2_loop(
        erlang:element(2, Iterator1),
        erlang:element(2, Iterator2),
        Fun
    ),
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 470).
-spec append_loop(fun(() -> action(DUO)), fun(() -> action(DUO))) -> action(DUO).
append_loop(First, Second) ->
    case First() of
        {continue, E, First@1} ->
            {continue, E, fun() -> append_loop(First@1, Second) end};

        stop ->
            Second()
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 465).
-spec append(iterator(DUK), iterator(DUK)) -> iterator(DUK).
append(First, Second) ->
    _pipe = fun() ->
        append_loop(erlang:element(2, First), erlang:element(2, Second))
    end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 498).
-spec flatten_loop(fun(() -> action(iterator(DUW)))) -> action(DUW).
flatten_loop(Flattened) ->
    case Flattened() of
        stop ->
            stop;

        {continue, It, Next_iterator} ->
            append_loop(
                erlang:element(2, It),
                fun() -> flatten_loop(Next_iterator) end
            )
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 493).
-spec flatten(iterator(iterator(DUS))) -> iterator(DUS).
flatten(Iterator) ->
    _pipe = fun() -> flatten_loop(erlang:element(2, Iterator)) end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 522).
-spec concat(list(iterator(DVA))) -> iterator(DVA).
concat(Iterators) ->
    flatten(from_list(Iterators)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 545).
-spec flat_map(iterator(DVE), fun((DVE) -> iterator(DVG))) -> iterator(DVG).
flat_map(Iterator, F) ->
    _pipe = Iterator,
    _pipe@1 = map(_pipe, F),
    flatten(_pipe@1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 582).
-spec filter_loop(fun(() -> action(DVM)), fun((DVM) -> boolean())) -> action(DVM).
filter_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Iterator} ->
            case Predicate(E) of
                true ->
                    {continue, E, fun() -> filter_loop(Iterator, Predicate) end};

                false ->
                    filter_loop(Iterator, Predicate)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 574).
-spec filter(iterator(DVJ), fun((DVJ) -> boolean())) -> iterator(DVJ).
filter(Iterator, Predicate) ->
    _pipe = fun() -> filter_loop(erlang:element(2, Iterator), Predicate) end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 626).
-spec filter_map_loop(
    fun(() -> action(DVW)),
    fun((DVW) -> {ok, DVY} | {error, any()})
) -> action(DVY).
filter_map_loop(Continuation, F) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            case F(E) of
                {ok, E@1} ->
                    {continue, E@1, fun() -> filter_map_loop(Next, F) end};

                {error, _} ->
                    filter_map_loop(Next, F)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 618).
-spec filter_map(iterator(DVP), fun((DVP) -> {ok, DVR} | {error, any()})) -> iterator(DVR).
filter_map(Iterator, F) ->
    _pipe = fun() -> filter_map_loop(erlang:element(2, Iterator), F) end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 653).
-spec cycle(iterator(DWD)) -> iterator(DWD).
cycle(Iterator) ->
    _pipe = repeat(Iterator),
    flatten(_pipe).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 732).
-spec find_loop(fun(() -> action(DWL)), fun((DWL) -> boolean())) -> {ok, DWL} |
    {error, nil}.
find_loop(Continuation, F) ->
    case Continuation() of
        stop ->
            {error, nil};

        {continue, E, Next} ->
            case F(E) of
                true ->
                    {ok, E};

                false ->
                    find_loop(Next, F)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 724).
-spec find(iterator(DWH), fun((DWH) -> boolean())) -> {ok, DWH} | {error, nil}.
find(Haystack, Is_desired) ->
    _pipe = erlang:element(2, Haystack),
    find_loop(_pipe, Is_desired).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 778).
-spec find_map_loop(
    fun(() -> action(DWX)),
    fun((DWX) -> {ok, DWZ} | {error, any()})
) -> {ok, DWZ} | {error, nil}.
find_map_loop(Continuation, F) ->
    case Continuation() of
        stop ->
            {error, nil};

        {continue, E, Next} ->
            case F(E) of
                {ok, E@1} ->
                    {ok, E@1};

                {error, _} ->
                    find_map_loop(Next, F)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 770).
-spec find_map(iterator(DWP), fun((DWP) -> {ok, DWR} | {error, any()})) -> {ok,
        DWR} |
    {error, nil}.
find_map(Haystack, Is_desired) ->
    _pipe = erlang:element(2, Haystack),
    find_map_loop(_pipe, Is_desired).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 808).
-spec index_loop(fun(() -> action(DXI)), integer()) -> fun(() -> action({DXI,
    integer()})).
index_loop(Continuation, Next) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, E, Continuation@1} ->
                {continue, {E, Next}, index_loop(Continuation@1, Next + 1)}
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 802).
-spec index(iterator(DXF)) -> iterator({DXF, integer()}).
index(Iterator) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = index_loop(_pipe, 0),
    {iterator, _pipe@1}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 831).
-spec iterate(DXL, fun((DXL) -> DXL)) -> iterator(DXL).
iterate(Initial, F) ->
    unfold(Initial, fun(Element) -> {next, Element, F(Element)} end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 859).
-spec take_while_loop(fun(() -> action(DXQ)), fun((DXQ) -> boolean())) -> fun(() -> action(DXQ)).
take_while_loop(Continuation, Predicate) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, E, Next} ->
                case Predicate(E) of
                    false ->
                        stop;

                    true ->
                        {continue, E, take_while_loop(Next, Predicate)}
                end
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 850).
-spec take_while(iterator(DXN), fun((DXN) -> boolean())) -> iterator(DXN).
take_while(Iterator, Predicate) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = take_while_loop(_pipe, Predicate),
    {iterator, _pipe@1}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 896).
-spec drop_while_loop(fun(() -> action(DXW)), fun((DXW) -> boolean())) -> action(DXW).
drop_while_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            case Predicate(E) of
                false ->
                    {continue, E, Next};

                true ->
                    drop_while_loop(Next, Predicate)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 888).
-spec drop_while(iterator(DXT), fun((DXT) -> boolean())) -> iterator(DXT).
drop_while(Iterator, Predicate) ->
    _pipe = fun() -> drop_while_loop(erlang:element(2, Iterator), Predicate) end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 935).
-spec scan_loop(fun(() -> action(DYD)), fun((DYF, DYD) -> DYF), DYF) -> fun(() -> action(DYF)).
scan_loop(Continuation, F, Accumulator) ->
    fun() -> case Continuation() of
            stop ->
                stop;

            {continue, El, Next} ->
                Accumulated = F(Accumulator, El),
                {continue, Accumulated, scan_loop(Next, F, Accumulated)}
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 925).
-spec scan(iterator(DXZ), DYB, fun((DYB, DXZ) -> DYB)) -> iterator(DYB).
scan(Iterator, Initial, F) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = scan_loop(_pipe, F, Initial),
    {iterator, _pipe@1}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 969).
-spec zip_loop(fun(() -> action(DYM)), fun(() -> action(DYO))) -> fun(() -> action({DYM,
    DYO})).
zip_loop(Left, Right) ->
    fun() -> case Left() of
            stop ->
                stop;

            {continue, El_left, Next_left} ->
                case Right() of
                    stop ->
                        stop;

                    {continue, El_right, Next_right} ->
                        {continue,
                            {El_left, El_right},
                            zip_loop(Next_left, Next_right)}
                end
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 964).
-spec zip(iterator(DYH), iterator(DYJ)) -> iterator({DYH, DYJ}).
zip(Left, Right) ->
    _pipe = zip_loop(erlang:element(2, Left), erlang:element(2, Right)),
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1031).
-spec next_chunk(fun(() -> action(DZB)), fun((DZB) -> DZD), DZD, list(DZB)) -> chunk(DZB, DZD).
next_chunk(Continuation, F, Previous_key, Current_chunk) ->
    case Continuation() of
        stop ->
            {last_by, lists:reverse(Current_chunk)};

        {continue, E, Next} ->
            Key = F(E),
            case Key =:= Previous_key of
                true ->
                    next_chunk(Next, F, Key, [E | Current_chunk]);

                false ->
                    {another_by, lists:reverse(Current_chunk), Key, E, Next}
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1018).
-spec chunk_loop(fun(() -> action(DYW)), fun((DYW) -> DYY), DYY, DYW) -> action(list(DYW)).
chunk_loop(Continuation, F, Previous_key, Previous_element) ->
    case next_chunk(Continuation, F, Previous_key, [Previous_element]) of
        {last_by, Chunk} ->
            {continue, Chunk, fun stop/0};

        {another_by, Chunk@1, Key, El, Next} ->
            {continue, Chunk@1, fun() -> chunk_loop(Next, F, Key, El) end}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1005).
-spec chunk(iterator(DYR), fun((DYR) -> any())) -> iterator(list(DYR)).
chunk(Iterator, F) ->
    _pipe = fun() -> case (erlang:element(2, Iterator))() of
            stop ->
                stop;

            {continue, E, Next} ->
                chunk_loop(Next, F, F(E), E)
        end end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1103).
-spec next_sized_chunk(fun(() -> action(DZP)), integer(), list(DZP)) -> sized_chunk(DZP).
next_sized_chunk(Continuation, Left, Current_chunk) ->
    case Continuation() of
        stop ->
            case Current_chunk of
                [] ->
                    no_more;

                Remaining ->
                    {last, lists:reverse(Remaining)}
            end;

        {continue, E, Next} ->
            Chunk = [E | Current_chunk],
            case Left > 1 of
                false ->
                    {another, lists:reverse(Chunk), Next};

                true ->
                    next_sized_chunk(Next, Left - 1, Chunk)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1082).
-spec sized_chunk_loop(fun(() -> action(DZL)), integer()) -> fun(() -> action(list(DZL))).
sized_chunk_loop(Continuation, Count) ->
    fun() -> case next_sized_chunk(Continuation, Count, []) of
            no_more ->
                stop;

            {last, Chunk} ->
                {continue, Chunk, fun stop/0};

            {another, Chunk@1, Next_element} ->
                {continue, Chunk@1, sized_chunk_loop(Next_element, Count)}
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1073).
-spec sized_chunk(iterator(DZH), integer()) -> iterator(list(DZH)).
sized_chunk(Iterator, Count) ->
    _pipe = erlang:element(2, Iterator),
    _pipe@1 = sized_chunk_loop(_pipe, Count),
    {iterator, _pipe@1}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1164).
-spec intersperse_loop(fun(() -> action(DZW)), DZW) -> action(DZW).
intersperse_loop(Continuation, Separator) ->
    case Continuation() of
        stop ->
            stop;

        {continue, E, Next} ->
            Next_interspersed = fun() -> intersperse_loop(Next, Separator) end,
            {continue, Separator, fun() -> {continue, E, Next_interspersed} end}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1151).
-spec intersperse(iterator(DZT), DZT) -> iterator(DZT).
intersperse(Iterator, Elem) ->
    _pipe = fun() -> case (erlang:element(2, Iterator))() of
            stop ->
                stop;

            {continue, E, Next} ->
                {continue, E, fun() -> intersperse_loop(Next, Elem) end}
        end end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1213).
-spec any_loop(fun(() -> action(EAB)), fun((EAB) -> boolean())) -> boolean().
any_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            false;

        {continue, E, Next} ->
            case Predicate(E) of
                true ->
                    true;

                false ->
                    any_loop(Next, Predicate)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1205).
-spec any(iterator(DZZ), fun((DZZ) -> boolean())) -> boolean().
any(Iterator, Predicate) ->
    _pipe = erlang:element(2, Iterator),
    any_loop(_pipe, Predicate).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1263).
-spec all_loop(fun(() -> action(EAF)), fun((EAF) -> boolean())) -> boolean().
all_loop(Continuation, Predicate) ->
    case Continuation() of
        stop ->
            true;

        {continue, E, Next} ->
            case Predicate(E) of
                true ->
                    all_loop(Next, Predicate);

                false ->
                    false
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1255).
-spec all(iterator(EAD), fun((EAD) -> boolean())) -> boolean().
all(Iterator, Predicate) ->
    _pipe = erlang:element(2, Iterator),
    all_loop(_pipe, Predicate).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1309).
-spec update_group_with(EAV) -> fun((gleam@option:option(list(EAV))) -> list(EAV)).
update_group_with(El) ->
    fun(Maybe_group) -> case Maybe_group of
            {some, Group} ->
                [El | Group];

            none ->
                [El]
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1300).
-spec group_updater(fun((EAN) -> EAO)) -> fun((gleam@dict:dict(EAO, list(EAN)), EAN) -> gleam@dict:dict(EAO, list(EAN))).
group_updater(F) ->
    fun(Groups, Elem) -> _pipe = Groups,
        gleam@dict:upsert(_pipe, F(Elem), update_group_with(Elem)) end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1291).
-spec group(iterator(EAH), fun((EAH) -> EAJ)) -> gleam@dict:dict(EAJ, list(EAH)).
group(Iterator, Key) ->
    _pipe = Iterator,
    _pipe@1 = fold(_pipe, maps:new(), group_updater(Key)),
    gleam@dict:map_values(_pipe@1, fun(_, Group) -> lists:reverse(Group) end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1340).
-spec reduce(iterator(EAZ), fun((EAZ, EAZ) -> EAZ)) -> {ok, EAZ} | {error, nil}.
reduce(Iterator, F) ->
    case (erlang:element(2, Iterator))() of
        stop ->
            {error, nil};

        {continue, E, Next} ->
            _pipe = fold_loop(Next, F, E),
            {ok, _pipe}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1371).
-spec last(iterator(EBD)) -> {ok, EBD} | {error, nil}.
last(Iterator) ->
    _pipe = Iterator,
    reduce(_pipe, fun(_, Elem) -> Elem end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1386).
-spec empty() -> iterator(any()).
empty() ->
    {iterator, fun stop/0}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1400).
-spec once(fun(() -> EBJ)) -> iterator(EBJ).
once(F) ->
    _pipe = fun() -> {continue, F(), fun stop/0} end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 679).
-spec range(integer(), integer()) -> iterator(integer()).
range(Start, Stop) ->
    case gleam@int:compare(Start, Stop) of
        eq ->
            once(fun() -> Start end);

        gt ->
            unfold(Start, fun(Current) -> case Current < Stop of
                        false ->
                            {next, Current, Current - 1};

                        true ->
                            done
                    end end);

        lt ->
            unfold(Start, fun(Current@1) -> case Current@1 > Stop of
                        false ->
                            {next, Current@1, Current@1 + 1};

                        true ->
                            done
                    end end)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1415).
-spec single(EBL) -> iterator(EBL).
single(Elem) ->
    once(fun() -> Elem end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1447).
-spec interleave_loop(fun(() -> action(EBR)), fun(() -> action(EBR))) -> action(EBR).
interleave_loop(Current, Next) ->
    case Current() of
        stop ->
            Next();

        {continue, E, Next_other} ->
            {continue, E, fun() -> interleave_loop(Next, Next_other) end}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1439).
-spec interleave(iterator(EBN), iterator(EBN)) -> iterator(EBN).
interleave(Left, Right) ->
    _pipe = fun() ->
        interleave_loop(erlang:element(2, Left), erlang:element(2, Right))
    end,
    {iterator, _pipe}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1492).
-spec fold_until_loop(
    fun(() -> action(EBZ)),
    fun((ECB, EBZ) -> gleam@list:continue_or_stop(ECB)),
    ECB
) -> ECB.
fold_until_loop(Continuation, F, Accumulator) ->
    case Continuation() of
        stop ->
            Accumulator;

        {continue, Elem, Next} ->
            case F(Accumulator, Elem) of
                {continue, Accumulator@1} ->
                    fold_until_loop(Next, F, Accumulator@1);

                {stop, Accumulator@2} ->
                    Accumulator@2
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1483).
-spec fold_until(
    iterator(EBV),
    EBX,
    fun((EBX, EBV) -> gleam@list:continue_or_stop(EBX))
) -> EBX.
fold_until(Iterator, Initial, F) ->
    _pipe = erlang:element(2, Iterator),
    fold_until_loop(_pipe, F, Initial).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1536).
-spec try_fold_loop(
    fun(() -> action(ECL)),
    fun((ECN, ECL) -> {ok, ECN} | {error, ECO}),
    ECN
) -> {ok, ECN} | {error, ECO}.
try_fold_loop(Continuation, F, Accumulator) ->
    case Continuation() of
        stop ->
            {ok, Accumulator};

        {continue, Elem, Next} ->
            case F(Accumulator, Elem) of
                {ok, Result} ->
                    try_fold_loop(Next, F, Result);

                {error, _} = Error ->
                    Error
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1527).
-spec try_fold(iterator(ECD), ECF, fun((ECF, ECD) -> {ok, ECF} | {error, ECG})) -> {ok,
        ECF} |
    {error, ECG}.
try_fold(Iterator, Initial, F) ->
    _pipe = erlang:element(2, Iterator),
    try_fold_loop(_pipe, F, Initial).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1567).
-spec first(iterator(ECT)) -> {ok, ECT} | {error, nil}.
first(Iterator) ->
    case (erlang:element(2, Iterator))() of
        stop ->
            {error, nil};

        {continue, E, _} ->
            {ok, E}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1598).
-spec at(iterator(ECX), integer()) -> {ok, ECX} | {error, nil}.
at(Iterator, Index) ->
    _pipe = Iterator,
    _pipe@1 = drop(_pipe, Index),
    first(_pipe@1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1627).
-spec length_loop(fun(() -> action(any())), integer()) -> integer().
length_loop(Continuation, Length) ->
    case Continuation() of
        stop ->
            Length;

        {continue, _, Next} ->
            length_loop(Next, Length + 1)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1622).
-spec length(iterator(any())) -> integer().
length(Iterator) ->
    _pipe = erlang:element(2, Iterator),
    length_loop(_pipe, 0).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1652).
-spec each(iterator(EDF), fun((EDF) -> any())) -> nil.
each(Iterator, F) ->
    _pipe = Iterator,
    _pipe@1 = map(_pipe, F),
    run(_pipe@1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/iterator.gleam", 1678).
-spec yield(EDI, fun(() -> iterator(EDI))) -> iterator(EDI).
yield(Element, Next) ->
    {iterator,
        fun() ->
            {continue, Element, fun() -> (erlang:element(2, Next()))() end}
        end}.
