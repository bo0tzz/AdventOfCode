-module(gleam@string_builder).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/0, prepend/2, append/2, prepend_builder/2, append_builder/2, from_strings/1, concat/1, from_string/1, to_string/1, byte_size/1, join/2, lowercase/1, uppercase/1, reverse/1, split/2, replace/3, is_equal/2, is_empty/1]).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 27).
-spec new() -> gleam@string_tree:string_tree().
new() ->
    gleam_stdlib:identity([]).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 36).
-spec prepend(gleam@string_tree:string_tree(), binary()) -> gleam@string_tree:string_tree().
prepend(Builder, Prefix) ->
    gleam_stdlib:iodata_append(gleam_stdlib:identity(Prefix), Builder).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 45).
-spec append(gleam@string_tree:string_tree(), binary()) -> gleam@string_tree:string_tree().
append(Builder, Second) ->
    gleam_stdlib:iodata_append(Builder, gleam_stdlib:identity(Second)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 54).
-spec prepend_builder(
    gleam@string_tree:string_tree(),
    gleam@string_tree:string_tree()
) -> gleam@string_tree:string_tree().
prepend_builder(Builder, Prefix) ->
    gleam@string_tree:prepend_tree(Builder, Prefix).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 66).
-spec append_builder(
    gleam@string_tree:string_tree(),
    gleam@string_tree:string_tree()
) -> gleam@string_tree:string_tree().
append_builder(Builder, Suffix) ->
    gleam_stdlib:iodata_append(Builder, Suffix).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 78).
-spec from_strings(list(binary())) -> gleam@string_tree:string_tree().
from_strings(Strings) ->
    gleam_stdlib:identity(Strings).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 87).
-spec concat(list(gleam@string_tree:string_tree())) -> gleam@string_tree:string_tree().
concat(Builders) ->
    gleam_stdlib:identity(Builders).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 96).
-spec from_string(binary()) -> gleam@string_tree:string_tree().
from_string(String) ->
    gleam_stdlib:identity(String).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 106).
-spec to_string(gleam@string_tree:string_tree()) -> binary().
to_string(Builder) ->
    unicode:characters_to_binary(Builder).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 113).
-spec byte_size(gleam@string_tree:string_tree()) -> integer().
byte_size(Builder) ->
    erlang:iolist_size(Builder).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 120).
-spec join(list(gleam@string_tree:string_tree()), binary()) -> gleam@string_tree:string_tree().
join(Builders, Sep) ->
    gleam@string_tree:join(Builders, Sep).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 128).
-spec lowercase(gleam@string_tree:string_tree()) -> gleam@string_tree:string_tree().
lowercase(Builder) ->
    string:lowercase(Builder).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 136).
-spec uppercase(gleam@string_tree:string_tree()) -> gleam@string_tree:string_tree().
uppercase(Builder) ->
    string:uppercase(Builder).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 143).
-spec reverse(gleam@string_tree:string_tree()) -> gleam@string_tree:string_tree().
reverse(Builder) ->
    string:reverse(Builder).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 150).
-spec split(gleam@string_tree:string_tree(), binary()) -> list(gleam@string_tree:string_tree()).
split(Iodata, Pattern) ->
    gleam@string_tree:split(Iodata, Pattern).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 159).
-spec replace(gleam@string_tree:string_tree(), binary(), binary()) -> gleam@string_tree:string_tree().
replace(Builder, Pattern, Substitute) ->
    gleam_stdlib:string_replace(Builder, Pattern, Substitute).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 185).
-spec is_equal(gleam@string_tree:string_tree(), gleam@string_tree:string_tree()) -> boolean().
is_equal(A, B) ->
    string:equal(A, B).

-file("/Users/louis/src/gleam/stdlib/src/gleam/string_builder.gleam", 210).
-spec is_empty(gleam@string_tree:string_tree()) -> boolean().
is_empty(Builder) ->
    string:is_empty(Builder).
