-module(gleam@list).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([length/1, reverse/1, is_empty/1, contains/2, first/1, rest/1, filter/2, filter_map/2, map/2, map2/3, index_map/2, try_map/2, drop/2, take/2, new/0, wrap/1, append/2, prepend/2, concat/1, flatten/1, flat_map/2, fold/3, count/2, group/2, map_fold/3, fold_right/3, index_fold/3, try_fold/3, fold_until/3, find/2, find_map/2, all/2, any/2, zip/2, strict_zip/2, unzip/1, intersperse/2, unique/1, sort/2, range/2, repeat/2, split/2, split_while/2, key_find/2, key_filter/2, pop/2, pop_map/2, key_pop/2, key_set/3, each/2, try_each/2, partition/2, permutations/1, window/2, window_by_2/1, drop_while/2, take_while/2, chunk/2, sized_chunk/2, reduce/2, scan/3, last/1, combinations/2, combination_pairs/1, transpose/1, interleave/1, shuffle/1]).
-export_type([continue_or_stop/1, sorting/0]).

-type continue_or_stop(XW) :: {continue, XW} | {stop, XW}.

-type sorting() :: ascending | descending.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 61).
-spec length_loop(list(any()), integer()) -> integer().
length_loop(List, Count) ->
    case List of
        [_ | List@1] ->
            length_loop(List@1, Count + 1);

        _ ->
            Count
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 57).
-spec length(list(any())) -> integer().
length(List) ->
    erlang:length(List).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 130).
-spec reverse_loop(list(YG), list(YG)) -> list(YG).
reverse_loop(Remaining, Accumulator) ->
    case Remaining of
        [] ->
            Accumulator;

        [Item | Rest] ->
            reverse_loop(Rest, [Item | Accumulator])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 126).
-spec reverse(list(YD)) -> list(YD).
reverse(List) ->
    lists:reverse(List).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 158).
-spec is_empty(list(any())) -> boolean().
is_empty(List) ->
    List =:= [].

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 194).
-spec contains(list(YM), YM) -> boolean().
contains(List, Elem) ->
    case List of
        [] ->
            false;

        [First | _] when First =:= Elem ->
            true;

        [_ | Rest] ->
            contains(Rest, Elem)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 221).
-spec first(list(YO)) -> {ok, YO} | {error, nil}.
first(List) ->
    case List of
        [] ->
            {error, nil};

        [X | _] ->
            {ok, X}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 250).
-spec rest(list(YS)) -> {ok, list(YS)} | {error, nil}.
rest(List) ->
    case List of
        [] ->
            {error, nil};

        [_ | Rest] ->
            {ok, Rest}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 292).
-spec update_group(fun((AAD) -> AAE)) -> fun((gleam@dict:dict(AAE, list(AAD)), AAD) -> gleam@dict:dict(AAE, list(AAD))).
update_group(F) ->
    fun(Groups, Elem) -> case gleam_stdlib:map_get(Groups, F(Elem)) of
            {ok, Existing} ->
                gleam@dict:insert(Groups, F(Elem), [Elem | Existing]);

            {error, _} ->
                gleam@dict:insert(Groups, F(Elem), [Elem])
        end end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 320).
-spec filter_loop(list(AAO), fun((AAO) -> boolean()), list(AAO)) -> list(AAO).
filter_loop(List, Fun, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            New_acc = case Fun(First) of
                true ->
                    [First | Acc];

                false ->
                    Acc
            end,
            filter_loop(Rest, Fun, New_acc)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 316).
-spec filter(list(AAL), fun((AAL) -> boolean())) -> list(AAL).
filter(List, Predicate) ->
    filter_loop(List, Predicate, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 352).
-spec filter_map_loop(
    list(AAZ),
    fun((AAZ) -> {ok, ABB} | {error, any()}),
    list(ABB)
) -> list(ABB).
filter_map_loop(List, Fun, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            New_acc = case Fun(First) of
                {ok, First@1} ->
                    [First@1 | Acc];

                {error, _} ->
                    Acc
            end,
            filter_map_loop(Rest, Fun, New_acc)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 348).
-spec filter_map(list(AAS), fun((AAS) -> {ok, AAU} | {error, any()})) -> list(AAU).
filter_map(List, Fun) ->
    filter_map_loop(List, Fun, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 383).
-spec map_loop(list(ABL), fun((ABL) -> ABN), list(ABN)) -> list(ABN).
map_loop(List, Fun, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            map_loop(Rest, Fun, [Fun(First) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 379).
-spec map(list(ABH), fun((ABH) -> ABJ)) -> list(ABJ).
map(List, Fun) ->
    map_loop(List, Fun, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 410).
-spec map2_loop(list(ABW), list(ABY), fun((ABW, ABY) -> ACA), list(ACA)) -> list(ACA).
map2_loop(List1, List2, Fun, Acc) ->
    case {List1, List2} of
        {[], _} ->
            lists:reverse(Acc);

        {_, []} ->
            lists:reverse(Acc);

        {[A | As_], [B | Bs]} ->
            map2_loop(As_, Bs, Fun, [Fun(A, B) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 406).
-spec map2(list(ABQ), list(ABS), fun((ABQ, ABS) -> ABU)) -> list(ABU).
map2(List1, List2, Fun) ->
    map2_loop(List1, List2, Fun, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 465).
-spec index_map_loop(
    list(ACM),
    fun((ACM, integer()) -> ACO),
    integer(),
    list(ACO)
) -> list(ACO).
index_map_loop(List, Fun, Index, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            Acc@1 = [Fun(First, Index) | Acc],
            index_map_loop(Rest, Fun, Index + 1, Acc@1)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 461).
-spec index_map(list(ACI), fun((ACI, integer()) -> ACK)) -> list(ACK).
index_map(List, Fun) ->
    index_map_loop(List, Fun, 0, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 519).
-spec try_map_loop(list(ADA), fun((ADA) -> {ok, ADC} | {error, ADD}), list(ADC)) -> {ok,
        list(ADC)} |
    {error, ADD}.
try_map_loop(List, Fun, Acc) ->
    case List of
        [] ->
            {ok, lists:reverse(Acc)};

        [First | Rest] ->
            case Fun(First) of
                {ok, First@1} ->
                    try_map_loop(Rest, Fun, [First@1 | Acc]);

                {error, Error} ->
                    {error, Error}
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 512).
-spec try_map(list(ACR), fun((ACR) -> {ok, ACT} | {error, ACU})) -> {ok,
        list(ACT)} |
    {error, ACU}.
try_map(List, Fun) ->
    try_map_loop(List, Fun, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 554).
-spec drop(list(ADK), integer()) -> list(ADK).
drop(List, N) ->
    case N =< 0 of
        true ->
            List;

        false ->
            case List of
                [] ->
                    [];

                [_ | Rest] ->
                    drop(Rest, N - 1)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 589).
-spec take_loop(list(ADQ), integer(), list(ADQ)) -> list(ADQ).
take_loop(List, N, Acc) ->
    case N =< 0 of
        true ->
            lists:reverse(Acc);

        false ->
            case List of
                [] ->
                    lists:reverse(Acc);

                [First | Rest] ->
                    take_loop(Rest, N - 1, [First | Acc])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 585).
-spec take(list(ADN), integer()) -> list(ADN).
take(List, N) ->
    take_loop(List, N, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 609).
-spec new() -> list(any()).
new() ->
    [].

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 629).
-spec wrap(ADW) -> list(ADW).
wrap(Item) ->
    [Item].

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 650).
-spec append_loop(list(AEC), list(AEC)) -> list(AEC).
append_loop(First, Second) ->
    case First of
        [] ->
            Second;

        [Item | Rest] ->
            append_loop(Rest, [Item | Second])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 646).
-spec append(list(ADY), list(ADY)) -> list(ADY).
append(First, Second) ->
    lists:append(First, Second).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 670).
-spec prepend(list(AEG), AEG) -> list(AEG).
prepend(List, Item) ->
    [Item | List].

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 675).
-spec reverse_and_prepend(list(AEJ), list(AEJ)) -> list(AEJ).
reverse_and_prepend(Prefix, Suffix) ->
    case Prefix of
        [] ->
            Suffix;

        [First | Rest] ->
            reverse_and_prepend(Rest, [First | Suffix])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 698).
-spec concat_loop(list(list(AER)), list(AER)) -> list(AER).
concat_loop(Lists, Acc) ->
    case Lists of
        [] ->
            lists:reverse(Acc);

        [List | Further_lists] ->
            concat_loop(Further_lists, reverse_and_prepend(List, Acc))
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 694).
-spec concat(list(list(AEN))) -> list(AEN).
concat(Lists) ->
    concat_loop(Lists, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 718).
-spec flatten(list(list(AEW))) -> list(AEW).
flatten(Lists) ->
    concat_loop(Lists, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 731).
-spec flat_map(list(AFA), fun((AFA) -> list(AFC))) -> list(AFC).
flat_map(List, Fun) ->
    _pipe = map(List, Fun),
    flatten(_pipe).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 744).
-spec fold(list(AFF), AFH, fun((AFH, AFF) -> AFH)) -> AFH.
fold(List, Initial, Fun) ->
    case List of
        [] ->
            Initial;

        [X | Rest] ->
            fold(Rest, Fun(Initial, X), Fun)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 90).
-spec count(list(YB), fun((YB) -> boolean())) -> integer().
count(List, Predicate) ->
    fold(List, 0, fun(Acc, Value) -> case Predicate(Value) of
                true ->
                    Acc + 1;

                false ->
                    Acc
            end end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 288).
-spec group(list(YX), fun((YX) -> YZ)) -> gleam@dict:dict(YZ, list(YX)).
group(List, Key) ->
    fold(List, maps:new(), update_group(Key)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 435).
-spec map_fold(list(ACD), ACF, fun((ACF, ACD) -> {ACF, ACG})) -> {ACF,
    list(ACG)}.
map_fold(List, Initial, Fun) ->
    _pipe = fold(
        List,
        {Initial, []},
        fun(Acc, Item) ->
            {Current_acc, Items} = Acc,
            {Next_acc, Next_item} = Fun(Current_acc, Item),
            {Next_acc, [Next_item | Items]}
        end
    ),
    gleam@pair:map_second(_pipe, fun lists:reverse/1).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 766).
-spec fold_right(list(AFI), AFK, fun((AFK, AFI) -> AFK)) -> AFK.
fold_right(List, Initial, Fun) ->
    case List of
        [] ->
            Initial;

        [X | Rest] ->
            Fun(fold_right(Rest, Initial, Fun), X)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 794).
-spec index_fold_loop(
    list(AFO),
    AFQ,
    fun((AFQ, AFO, integer()) -> AFQ),
    integer()
) -> AFQ.
index_fold_loop(Over, Acc, With, Index) ->
    case Over of
        [] ->
            Acc;

        [First | Rest] ->
            index_fold_loop(Rest, With(Acc, First, Index), With, Index + 1)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 786).
-spec index_fold(list(AFL), AFN, fun((AFN, AFL, integer()) -> AFN)) -> AFN.
index_fold(List, Initial, Fun) ->
    index_fold_loop(List, Initial, Fun, 0).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 826).
-spec try_fold(list(AFR), AFT, fun((AFT, AFR) -> {ok, AFT} | {error, AFU})) -> {ok,
        AFT} |
    {error, AFU}.
try_fold(List, Initial, Fun) ->
    case List of
        [] ->
            {ok, Initial};

        [First | Rest] ->
            case Fun(Initial, First) of
                {ok, Result} ->
                    try_fold(Rest, Result, Fun);

                {error, _} = Error ->
                    Error
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 865).
-spec fold_until(list(AFZ), AGB, fun((AGB, AFZ) -> continue_or_stop(AGB))) -> AGB.
fold_until(List, Initial, Fun) ->
    case List of
        [] ->
            Initial;

        [First | Rest] ->
            case Fun(Initial, First) of
                {continue, Next_accumulator} ->
                    fold_until(Rest, Next_accumulator, Fun);

                {stop, B} ->
                    B
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 902).
-spec find(list(AGD), fun((AGD) -> boolean())) -> {ok, AGD} | {error, nil}.
find(List, Is_desired) ->
    case List of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Is_desired(X) of
                true ->
                    {ok, X};

                _ ->
                    find(Rest, Is_desired)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 938).
-spec find_map(list(AGH), fun((AGH) -> {ok, AGJ} | {error, any()})) -> {ok, AGJ} |
    {error, nil}.
find_map(List, Fun) ->
    case List of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Fun(X) of
                {ok, X@1} ->
                    {ok, X@1};

                _ ->
                    find_map(Rest, Fun)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 973).
-spec all(list(AGP), fun((AGP) -> boolean())) -> boolean().
all(List, Predicate) ->
    case List of
        [] ->
            true;

        [First | Rest] ->
            case Predicate(First) of
                true ->
                    all(Rest, Predicate);

                false ->
                    false
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1010).
-spec any(list(AGR), fun((AGR) -> boolean())) -> boolean().
any(List, Predicate) ->
    case List of
        [] ->
            false;

        [First | Rest] ->
            case Predicate(First) of
                true ->
                    true;

                false ->
                    any(Rest, Predicate)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1052).
-spec zip_loop(list(AGY), list(AHA), list({AGY, AHA})) -> list({AGY, AHA}).
zip_loop(One, Other, Acc) ->
    case {One, Other} of
        {[First_one | Rest_one], [First_other | Rest_other]} ->
            zip_loop(Rest_one, Rest_other, [{First_one, First_other} | Acc]);

        {_, _} ->
            lists:reverse(Acc)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1048).
-spec zip(list(AGT), list(AGV)) -> list({AGT, AGV}).
zip(List, Other) ->
    zip_loop(List, Other, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1086).
-spec strict_zip(list(AHE), list(AHG)) -> {ok, list({AHE, AHG})} | {error, nil}.
strict_zip(List, Other) ->
    case erlang:length(List) =:= erlang:length(Other) of
        true ->
            {ok, zip(List, Other)};

        false ->
            {error, nil}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1114).
-spec unzip_loop(list({AHQ, AHR}), list(AHQ), list(AHR)) -> {list(AHQ),
    list(AHR)}.
unzip_loop(Input, One, Other) ->
    case Input of
        [] ->
            {lists:reverse(One), lists:reverse(Other)};

        [{First_one, First_other} | Rest] ->
            unzip_loop(Rest, [First_one | One], [First_other | Other])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1110).
-spec unzip(list({AHL, AHM})) -> {list(AHL), list(AHM)}.
unzip(Input) ->
    unzip_loop(Input, [], []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1149).
-spec intersperse_loop(list(AIA), AIA, list(AIA)) -> list(AIA).
intersperse_loop(List, Separator, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [X | Rest] ->
            intersperse_loop(Rest, Separator, [X, Separator | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1142).
-spec intersperse(list(AHX), AHX) -> list(AHX).
intersperse(List, Elem) ->
    case List of
        [] ->
            List;

        [_] ->
            List;

        [X | Rest] ->
            intersperse_loop(Rest, Elem, [X])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1167).
-spec unique(list(AIE)) -> list(AIE).
unique(List) ->
    case List of
        [] ->
            [];

        [X | Rest] ->
            [X | unique(filter(Rest, fun(Y) -> Y /= X end))]
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1248).
-spec sequences(
    list(AIK),
    fun((AIK, AIK) -> gleam@order:order()),
    list(AIK),
    sorting(),
    AIK,
    list(list(AIK))
) -> list(list(AIK)).
sequences(List, Compare, Growing, Direction, Prev, Acc) ->
    Growing@1 = [Prev | Growing],
    case List of
        [] ->
            case Direction of
                ascending ->
                    [reverse_loop(Growing@1, []) | Acc];

                descending ->
                    [Growing@1 | Acc]
            end;

        [New | Rest] ->
            case {Compare(Prev, New), Direction} of
                {gt, descending} ->
                    sequences(Rest, Compare, Growing@1, Direction, New, Acc);

                {lt, ascending} ->
                    sequences(Rest, Compare, Growing@1, Direction, New, Acc);

                {eq, ascending} ->
                    sequences(Rest, Compare, Growing@1, Direction, New, Acc);

                {gt, ascending} ->
                    Acc@1 = case Direction of
                        ascending ->
                            [reverse_loop(Growing@1, []) | Acc];

                        descending ->
                            [Growing@1 | Acc]
                    end,
                    case Rest of
                        [] ->
                            [[New] | Acc@1];

                        [Next | Rest@1] ->
                            Direction@1 = case Compare(New, Next) of
                                lt ->
                                    ascending;

                                eq ->
                                    ascending;

                                gt ->
                                    descending
                            end,
                            sequences(
                                Rest@1,
                                Compare,
                                [New],
                                Direction@1,
                                Next,
                                Acc@1
                            )
                    end;

                {lt, descending} ->
                    Acc@1 = case Direction of
                        ascending ->
                            [reverse_loop(Growing@1, []) | Acc];

                        descending ->
                            [Growing@1 | Acc]
                    end,
                    case Rest of
                        [] ->
                            [[New] | Acc@1];

                        [Next | Rest@1] ->
                            Direction@1 = case Compare(New, Next) of
                                lt ->
                                    ascending;

                                eq ->
                                    ascending;

                                gt ->
                                    descending
                            end,
                            sequences(
                                Rest@1,
                                Compare,
                                [New],
                                Direction@1,
                                Next,
                                Acc@1
                            )
                    end;

                {eq, descending} ->
                    Acc@1 = case Direction of
                        ascending ->
                            [reverse_loop(Growing@1, []) | Acc];

                        descending ->
                            [Growing@1 | Acc]
                    end,
                    case Rest of
                        [] ->
                            [[New] | Acc@1];

                        [Next | Rest@1] ->
                            Direction@1 = case Compare(New, Next) of
                                lt ->
                                    ascending;

                                eq ->
                                    ascending;

                                gt ->
                                    descending
                            end,
                            sequences(
                                Rest@1,
                                Compare,
                                [New],
                                Direction@1,
                                Next,
                                Acc@1
                            )
                    end
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1396).
-spec merge_ascendings(
    list(AJH),
    list(AJH),
    fun((AJH, AJH) -> gleam@order:order()),
    list(AJH)
) -> list(AJH).
merge_ascendings(List1, List2, Compare, Acc) ->
    case {List1, List2} of
        {[], List} ->
            reverse_loop(List, Acc);

        {List, []} ->
            reverse_loop(List, Acc);

        {[First1 | Rest1], [First2 | Rest2]} ->
            case Compare(First1, First2) of
                lt ->
                    merge_ascendings(Rest1, List2, Compare, [First1 | Acc]);

                gt ->
                    merge_ascendings(List1, Rest2, Compare, [First2 | Acc]);

                eq ->
                    merge_ascendings(List1, Rest2, Compare, [First2 | Acc])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1349).
-spec merge_ascending_pairs(
    list(list(AIV)),
    fun((AIV, AIV) -> gleam@order:order()),
    list(list(AIV))
) -> list(list(AIV)).
merge_ascending_pairs(Sequences, Compare, Acc) ->
    case Sequences of
        [] ->
            reverse_loop(Acc, []);

        [Sequence] ->
            reverse_loop([reverse_loop(Sequence, []) | Acc], []);

        [Ascending1, Ascending2 | Rest] ->
            Descending = merge_ascendings(Ascending1, Ascending2, Compare, []),
            merge_ascending_pairs(Rest, Compare, [Descending | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1423).
-spec merge_descendings(
    list(AJM),
    list(AJM),
    fun((AJM, AJM) -> gleam@order:order()),
    list(AJM)
) -> list(AJM).
merge_descendings(List1, List2, Compare, Acc) ->
    case {List1, List2} of
        {[], List} ->
            reverse_loop(List, Acc);

        {List, []} ->
            reverse_loop(List, Acc);

        {[First1 | Rest1], [First2 | Rest2]} ->
            case Compare(First1, First2) of
                lt ->
                    merge_descendings(List1, Rest2, Compare, [First2 | Acc]);

                gt ->
                    merge_descendings(Rest1, List2, Compare, [First1 | Acc]);

                eq ->
                    merge_descendings(Rest1, List2, Compare, [First1 | Acc])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1371).
-spec merge_descending_pairs(
    list(list(AJB)),
    fun((AJB, AJB) -> gleam@order:order()),
    list(list(AJB))
) -> list(list(AJB)).
merge_descending_pairs(Sequences, Compare, Acc) ->
    case Sequences of
        [] ->
            reverse_loop(Acc, []);

        [Sequence] ->
            reverse_loop([reverse_loop(Sequence, []) | Acc], []);

        [Descending1, Descending2 | Rest] ->
            Ascending = merge_descendings(Descending1, Descending2, Compare, []),
            merge_descending_pairs(Rest, Compare, [Ascending | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1315).
-spec merge_all(
    list(list(AIR)),
    sorting(),
    fun((AIR, AIR) -> gleam@order:order())
) -> list(AIR).
merge_all(Sequences, Direction, Compare) ->
    case {Sequences, Direction} of
        {[], _} ->
            [];

        {[Sequence], ascending} ->
            Sequence;

        {[Sequence@1], descending} ->
            reverse_loop(Sequence@1, []);

        {_, ascending} ->
            Sequences@1 = merge_ascending_pairs(Sequences, Compare, []),
            merge_all(Sequences@1, descending, Compare);

        {_, descending} ->
            Sequences@2 = merge_descending_pairs(Sequences, Compare, []),
            merge_all(Sequences@2, ascending, Compare)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1186).
-spec sort(list(AIH), fun((AIH, AIH) -> gleam@order:order())) -> list(AIH).
sort(List, Compare) ->
    case List of
        [] ->
            [];

        [X] ->
            [X];

        [X@1, Y | Rest] ->
            Direction = case Compare(X@1, Y) of
                lt ->
                    ascending;

                eq ->
                    ascending;

                gt ->
                    descending
            end,
            Sequences = sequences(Rest, Compare, [X@1], Direction, Y, []),
            merge_all(Sequences, ascending, Compare)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1463).
-spec range_loop(integer(), integer(), list(integer())) -> list(integer()).
range_loop(Start, Stop, Acc) ->
    case gleam@int:compare(Start, Stop) of
        eq ->
            [Stop | Acc];

        gt ->
            range_loop(Start, Stop + 1, [Stop | Acc]);

        lt ->
            range_loop(Start, Stop - 1, [Stop | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1459).
-spec range(integer(), integer()) -> list(integer()).
range(Start, Stop) ->
    range_loop(Start, Stop, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1489).
-spec repeat_loop(AJW, integer(), list(AJW)) -> list(AJW).
repeat_loop(Item, Times, Acc) ->
    case Times =< 0 of
        true ->
            Acc;

        false ->
            repeat_loop(Item, Times - 1, [Item | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1485).
-spec repeat(AJU, integer()) -> list(AJU).
repeat(A, Times) ->
    repeat_loop(A, Times, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1522).
-spec split_loop(list(AKD), integer(), list(AKD)) -> {list(AKD), list(AKD)}.
split_loop(List, N, Taken) ->
    case N =< 0 of
        true ->
            {lists:reverse(Taken), List};

        false ->
            case List of
                [] ->
                    {lists:reverse(Taken), []};

                [First | Rest] ->
                    split_loop(Rest, N - 1, [First | Taken])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1518).
-spec split(list(AJZ), integer()) -> {list(AJZ), list(AJZ)}.
split(List, Index) ->
    split_loop(List, Index, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1558).
-spec split_while_loop(list(AKM), fun((AKM) -> boolean()), list(AKM)) -> {list(AKM),
    list(AKM)}.
split_while_loop(List, F, Acc) ->
    case List of
        [] ->
            {lists:reverse(Acc), []};

        [First | Rest] ->
            case F(First) of
                false ->
                    {lists:reverse(Acc), List};

                _ ->
                    split_while_loop(Rest, F, [First | Acc])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1551).
-spec split_while(list(AKI), fun((AKI) -> boolean())) -> {list(AKI), list(AKI)}.
split_while(List, Predicate) ->
    split_while_loop(List, Predicate, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1598).
-spec key_find(list({AKR, AKS}), AKR) -> {ok, AKS} | {error, nil}.
key_find(Keyword_list, Desired_key) ->
    find_map(
        Keyword_list,
        fun(Keyword) ->
            {Key, Value} = Keyword,
            case Key =:= Desired_key of
                true ->
                    {ok, Value};

                false ->
                    {error, nil}
            end
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1629).
-spec key_filter(list({AKW, AKX}), AKW) -> list(AKX).
key_filter(Keyword_list, Desired_key) ->
    filter_map(
        Keyword_list,
        fun(Keyword) ->
            {Key, Value} = Keyword,
            case Key =:= Desired_key of
                true ->
                    {ok, Value};

                false ->
                    {error, nil}
            end
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1670).
-spec pop_loop(list(BDF), fun((BDF) -> boolean()), list(BDF)) -> {ok,
        {BDF, list(BDF)}} |
    {error, nil}.
pop_loop(Haystack, Predicate, Checked) ->
    case Haystack of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Predicate(X) of
                true ->
                    {ok, {X, lists:append(lists:reverse(Checked), Rest)}};

                false ->
                    pop_loop(Rest, Predicate, [X | Checked])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1663).
-spec pop(list(ALA), fun((ALA) -> boolean())) -> {ok, {ALA, list(ALA)}} |
    {error, nil}.
pop(List, Is_desired) ->
    pop_loop(List, Is_desired, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1710).
-spec pop_map_loop(
    list(ALS),
    fun((ALS) -> {ok, ALU} | {error, any()}),
    list(ALS)
) -> {ok, {ALU, list(ALS)}} | {error, nil}.
pop_map_loop(List, Mapper, Checked) ->
    case List of
        [] ->
            {error, nil};

        [X | Rest] ->
            case Mapper(X) of
                {ok, Y} ->
                    {ok, {Y, lists:append(lists:reverse(Checked), Rest)}};

                {error, _} ->
                    pop_map_loop(Rest, Mapper, [X | Checked])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1703).
-spec pop_map(list(ALJ), fun((ALJ) -> {ok, ALL} | {error, any()})) -> {ok,
        {ALL, list(ALJ)}} |
    {error, nil}.
pop_map(Haystack, Is_desired) ->
    pop_map_loop(Haystack, Is_desired, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1748).
-spec key_pop(list({AMC, AMD}), AMC) -> {ok, {AMD, list({AMC, AMD})}} |
    {error, nil}.
key_pop(List, Key) ->
    pop_map(
        List,
        fun(Entry) ->
            {K, V} = Entry,
            case K of
                K@1 when K@1 =:= Key ->
                    {ok, V};

                _ ->
                    {error, nil}
            end
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1775).
-spec key_set(list({AMI, AMJ}), AMI, AMJ) -> list({AMI, AMJ}).
key_set(List, Key, Value) ->
    case List of
        [] ->
            [{Key, Value}];

        [{K, _} | Rest] when K =:= Key ->
            [{Key, Value} | Rest];

        [First | Rest@1] ->
            [First | key_set(Rest@1, Key, Value)]
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1797).
-spec each(list(AMM), fun((AMM) -> any())) -> nil.
each(List, F) ->
    case List of
        [] ->
            nil;

        [First | Rest] ->
            F(First),
            each(Rest, F)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1823).
-spec try_each(list(AMP), fun((AMP) -> {ok, any()} | {error, AMS})) -> {ok, nil} |
    {error, AMS}.
try_each(List, Fun) ->
    case List of
        [] ->
            {ok, nil};

        [First | Rest] ->
            case Fun(First) of
                {ok, _} ->
                    try_each(Rest, Fun);

                {error, E} ->
                    {error, E}
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1856).
-spec partition_loop(list(BFK), fun((BFK) -> boolean()), list(BFK), list(BFK)) -> {list(BFK),
    list(BFK)}.
partition_loop(List, Categorise, Trues, Falses) ->
    case List of
        [] ->
            {lists:reverse(Trues), lists:reverse(Falses)};

        [First | Rest] ->
            case Categorise(First) of
                true ->
                    partition_loop(Rest, Categorise, [First | Trues], Falses);

                false ->
                    partition_loop(Rest, Categorise, Trues, [First | Falses])
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1849).
-spec partition(list(AMX), fun((AMX) -> boolean())) -> {list(AMX), list(AMX)}.
partition(List, Categorise) ->
    partition_loop(List, Categorise, [], []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1876).
-spec permutations(list(ANG)) -> list(list(ANG)).
permutations(List) ->
    case List of
        [] ->
            [[]];

        _ ->
            _pipe@3 = index_map(
                List,
                fun(I, I_idx) ->
                    _pipe = index_fold(
                        List,
                        [],
                        fun(Acc, J, J_idx) -> case I_idx =:= J_idx of
                                true ->
                                    Acc;

                                false ->
                                    [J | Acc]
                            end end
                    ),
                    _pipe@1 = lists:reverse(_pipe),
                    _pipe@2 = permutations(_pipe@1),
                    map(_pipe@2, fun(Permutation) -> [I | Permutation] end)
                end
            ),
            flatten(_pipe@3)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1916).
-spec window_loop(list(list(ANO)), list(ANO), integer()) -> list(list(ANO)).
window_loop(Acc, List, N) ->
    Window = take(List, N),
    case erlang:length(Window) =:= N of
        true ->
            window_loop([Window | Acc], drop(List, 1), N);

        false ->
            lists:reverse(Acc)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1909).
-spec window(list(ANK), integer()) -> list(list(ANK)).
window(List, N) ->
    case N =< 0 of
        true ->
            [];

        false ->
            window_loop([], List, N)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1939).
-spec window_by_2(list(ANU)) -> list({ANU, ANU}).
window_by_2(List) ->
    zip(List, drop(List, 1)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1952).
-spec drop_while(list(ANX), fun((ANX) -> boolean())) -> list(ANX).
drop_while(List, Predicate) ->
    case List of
        [] ->
            [];

        [First | Rest] ->
            case Predicate(First) of
                true ->
                    drop_while(Rest, Predicate);

                false ->
                    [First | Rest]
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1982).
-spec take_while_loop(list(AOD), fun((AOD) -> boolean()), list(AOD)) -> list(AOD).
take_while_loop(List, Predicate, Acc) ->
    case List of
        [] ->
            lists:reverse(Acc);

        [First | Rest] ->
            case Predicate(First) of
                true ->
                    take_while_loop(Rest, Predicate, [First | Acc]);

                false ->
                    lists:reverse(Acc)
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 1975).
-spec take_while(list(AOA), fun((AOA) -> boolean())) -> list(AOA).
take_while(List, Predicate) ->
    take_while_loop(List, Predicate, []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2014).
-spec chunk_loop(list(AOM), fun((AOM) -> AOO), AOO, list(AOM), list(list(AOM))) -> list(list(AOM)).
chunk_loop(List, F, Previous_key, Current_chunk, Acc) ->
    case List of
        [First | Rest] ->
            Key = F(First),
            case Key =:= Previous_key of
                false ->
                    New_acc = [lists:reverse(Current_chunk) | Acc],
                    chunk_loop(Rest, F, Key, [First], New_acc);

                _ ->
                    chunk_loop(Rest, F, Key, [First | Current_chunk], Acc)
            end;

        _ ->
            lists:reverse([lists:reverse(Current_chunk) | Acc])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2007).
-spec chunk(list(AOH), fun((AOH) -> any())) -> list(list(AOH)).
chunk(List, F) ->
    case List of
        [] ->
            [];

        [First | Rest] ->
            chunk_loop(Rest, F, F(First), [First], [])
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2059).
-spec sized_chunk_loop(
    list(AOY),
    integer(),
    integer(),
    list(AOY),
    list(list(AOY))
) -> list(list(AOY)).
sized_chunk_loop(List, Count, Left, Current_chunk, Acc) ->
    case List of
        [] ->
            case Current_chunk of
                [] ->
                    lists:reverse(Acc);

                Remaining ->
                    lists:reverse([lists:reverse(Remaining) | Acc])
            end;

        [First | Rest] ->
            Chunk = [First | Current_chunk],
            case Left > 1 of
                true ->
                    sized_chunk_loop(Rest, Count, Left - 1, Chunk, Acc);

                false ->
                    sized_chunk_loop(
                        Rest,
                        Count,
                        Count,
                        [],
                        [lists:reverse(Chunk) | Acc]
                    )
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2055).
-spec sized_chunk(list(AOU), integer()) -> list(list(AOU)).
sized_chunk(List, Count) ->
    sized_chunk_loop(List, Count, Count, [], []).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2103).
-spec reduce(list(APF), fun((APF, APF) -> APF)) -> {ok, APF} | {error, nil}.
reduce(List, Fun) ->
    case List of
        [] ->
            {error, nil};

        [First | Rest] ->
            {ok, fold(Rest, First, Fun)}
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2127).
-spec scan_loop(list(APN), APP, list(APP), fun((APP, APN) -> APP)) -> list(APP).
scan_loop(List, Accumulator, Accumulated, Fun) ->
    case List of
        [] ->
            lists:reverse(Accumulated);

        [First | Rest] ->
            Next = Fun(Accumulator, First),
            scan_loop(Rest, Next, [Next | Accumulated], Fun)
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2119).
-spec scan(list(APJ), APL, fun((APL, APJ) -> APL)) -> list(APL).
scan(List, Initial, Fun) ->
    scan_loop(List, Initial, [], Fun).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2160).
-spec last(list(APS)) -> {ok, APS} | {error, nil}.
last(List) ->
    _pipe = List,
    reduce(_pipe, fun(_, Elem) -> Elem end).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2179).
-spec combinations(list(APW), integer()) -> list(list(APW)).
combinations(Items, N) ->
    case N of
        0 ->
            [[]];

        _ ->
            case Items of
                [] ->
                    [];

                [First | Rest] ->
                    First_combinations = begin
                        _pipe = map(
                            combinations(Rest, N - 1),
                            fun(Com) -> [First | Com] end
                        ),
                        lists:reverse(_pipe)
                    end,
                    fold(
                        First_combinations,
                        combinations(Rest, N),
                        fun(Acc, C) -> [C | Acc] end
                    )
            end
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2211).
-spec combination_pairs_loop(list(AQD)) -> list(list({AQD, AQD})).
combination_pairs_loop(Items) ->
    case Items of
        [] ->
            [];

        [First | Rest] ->
            First_combinations = map(Rest, fun(Other) -> {First, Other} end),
            [First_combinations | combination_pairs_loop(Rest)]
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2206).
-spec combination_pairs(list(AQA)) -> list({AQA, AQA}).
combination_pairs(Items) ->
    _pipe = combination_pairs_loop(Items),
    flatten(_pipe).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2248).
-spec transpose(list(list(AQL))) -> list(list(AQL)).
transpose(List_of_list) ->
    Take_first = fun(List) -> case List of
            [] ->
                [];

            [F] ->
                [F];

            [F@1 | _] ->
                [F@1]
        end end,
    case List_of_list of
        [] ->
            [];

        [[] | Rest] ->
            transpose(Rest);

        Rows ->
            Firsts = begin
                _pipe = Rows,
                _pipe@1 = map(_pipe, Take_first),
                flatten(_pipe@1)
            end,
            Rest@1 = transpose(
                map(Rows, fun(_capture) -> drop(_capture, 1) end)
            ),
            [Firsts | Rest@1]
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2230).
-spec interleave(list(list(AQH))) -> list(AQH).
interleave(List) ->
    _pipe = transpose(List),
    flatten(_pipe).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2289).
-spec shuffle_pair_unwrap_loop(list({float(), AQT}), list(AQT)) -> list(AQT).
shuffle_pair_unwrap_loop(List, Acc) ->
    case List of
        [] ->
            Acc;

        [Elem_pair | Enumerable] ->
            shuffle_pair_unwrap_loop(
                Enumerable,
                [erlang:element(2, Elem_pair) | Acc]
            )
    end.

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2297).
-spec do_shuffle_by_pair_indexes(list({float(), AQX})) -> list({float(), AQX}).
do_shuffle_by_pair_indexes(List_of_pairs) ->
    sort(
        List_of_pairs,
        fun(A_pair, B_pair) ->
            gleam@float:compare(
                erlang:element(1, A_pair),
                erlang:element(1, B_pair)
            )
        end
    ).

-file("/Users/louis/src/gleam/stdlib/src/gleam/list.gleam", 2282).
-spec shuffle(list(AQQ)) -> list(AQQ).
shuffle(List) ->
    _pipe = List,
    _pipe@1 = fold(_pipe, [], fun(Acc, A) -> [{rand:uniform(), A} | Acc] end),
    _pipe@2 = do_shuffle_by_pair_indexes(_pipe@1),
    shuffle_pair_unwrap_loop(_pipe@2, []).
