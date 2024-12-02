-module(gleam@regex).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([compile/2, from_string/1, check/2, split/2, scan/2, replace/3]).
-export_type([regex/0, match/0, compile_error/0, options/0]).

-type regex() :: any().

-type match() :: {match, binary(), list(gleam@option:option(binary()))}.

-type compile_error() :: {compile_error, binary(), integer()}.

-type options() :: {options, boolean(), boolean()}.

-file("/Users/louis/src/gleam/stdlib/src/gleam/regex.gleam", 62).
-spec compile(binary(), options()) -> {ok, regex()} | {error, compile_error()}.
compile(Pattern, Options) ->
    gleam_stdlib:compile_regex(Pattern, Options).

-file("/Users/louis/src/gleam/stdlib/src/gleam/regex.gleam", 91).
-spec from_string(binary()) -> {ok, regex()} | {error, compile_error()}.
from_string(Pattern) ->
    gleam_stdlib:compile_regex(Pattern, {options, false, false}).

-file("/Users/louis/src/gleam/stdlib/src/gleam/regex.gleam", 113).
-spec check(regex(), binary()) -> boolean().
check(Regex, String) ->
    gleam_stdlib:regex_check(Regex, String).

-file("/Users/louis/src/gleam/stdlib/src/gleam/regex.gleam", 128).
-spec split(regex(), binary()) -> list(binary()).
split(Regex, String) ->
    gleam_stdlib:regex_split(Regex, String).

-file("/Users/louis/src/gleam/stdlib/src/gleam/regex.gleam", 185).
-spec scan(regex(), binary()) -> list(match()).
scan(Regex, String) ->
    gleam_stdlib:regex_scan(Regex, String).

-file("/Users/louis/src/gleam/stdlib/src/gleam/regex.gleam", 206).
-spec replace(regex(), binary(), binary()) -> binary().
replace(Pattern, String, Substitute) ->
    gleam_stdlib:regex_replace(Pattern, String, Substitute).
