-module(gleam@erlang@os).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([get_all_env/0, get_env/1, set_env/2, unset_env/1, family/0]).
-export_type([os_family/0]).

-type os_family() :: windows_nt | linux | darwin | free_bsd | {other, binary()}.

-file("/home/boet/git/AdventOfCode/2024/build/packages/gleam_erlang/src/gleam/erlang/os.gleam", 21).
-spec get_all_env() -> gleam@dict:dict(binary(), binary()).
get_all_env() ->
    gleam_erlang_ffi:get_all_env().

-file("/home/boet/git/AdventOfCode/2024/build/packages/gleam_erlang/src/gleam/erlang/os.gleam", 38).
-spec get_env(binary()) -> {ok, binary()} | {error, nil}.
get_env(Name) ->
    gleam_erlang_ffi:get_env(Name).

-file("/home/boet/git/AdventOfCode/2024/build/packages/gleam_erlang/src/gleam/erlang/os.gleam", 60).
-spec set_env(binary(), binary()) -> nil.
set_env(Name, Value) ->
    gleam_erlang_ffi:set_env(Name, Value).

-file("/home/boet/git/AdventOfCode/2024/build/packages/gleam_erlang/src/gleam/erlang/os.gleam", 85).
-spec unset_env(binary()) -> nil.
unset_env(Name) ->
    gleam_erlang_ffi:unset_env(Name).

-file("/home/boet/git/AdventOfCode/2024/build/packages/gleam_erlang/src/gleam/erlang/os.gleam", 122).
-spec family() -> os_family().
family() ->
    gleam_erlang_ffi:os_family().
