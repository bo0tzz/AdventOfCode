-module(gleam@bytes_builder).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([new/0, prepend/2, append/2, prepend_builder/2, append_builder/2, prepend_string/2, append_string/2, concat/1, concat_bit_arrays/1, from_string/1, from_string_builder/1, from_bit_array/1, to_bit_array/1, byte_size/1]).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 34).
-spec new() -> gleam@bytes_tree:bytes_tree().
new() ->
    gleam_stdlib:identity([]).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 43).
-spec prepend(gleam@bytes_tree:bytes_tree(), bitstring()) -> gleam@bytes_tree:bytes_tree().
prepend(Second, First) ->
    gleam_stdlib:iodata_append(gleam@bytes_tree:from_bit_array(First), Second).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 52).
-spec append(gleam@bytes_tree:bytes_tree(), bitstring()) -> gleam@bytes_tree:bytes_tree().
append(First, Second) ->
    gleam_stdlib:iodata_append(First, gleam@bytes_tree:from_bit_array(Second)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 61).
-spec prepend_builder(
    gleam@bytes_tree:bytes_tree(),
    gleam@bytes_tree:bytes_tree()
) -> gleam@bytes_tree:bytes_tree().
prepend_builder(Second, First) ->
    gleam_stdlib:iodata_append(First, Second).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 74).
-spec append_builder(
    gleam@bytes_tree:bytes_tree(),
    gleam@bytes_tree:bytes_tree()
) -> gleam@bytes_tree:bytes_tree().
append_builder(First, Second) ->
    gleam_stdlib:iodata_append(First, Second).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 87).
-spec prepend_string(gleam@bytes_tree:bytes_tree(), binary()) -> gleam@bytes_tree:bytes_tree().
prepend_string(Second, First) ->
    gleam_stdlib:iodata_append(gleam_stdlib:wrap_list(First), Second).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 97).
-spec append_string(gleam@bytes_tree:bytes_tree(), binary()) -> gleam@bytes_tree:bytes_tree().
append_string(First, Second) ->
    gleam_stdlib:iodata_append(First, gleam_stdlib:wrap_list(Second)).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 107).
-spec concat(list(gleam@bytes_tree:bytes_tree())) -> gleam@bytes_tree:bytes_tree().
concat(Builders) ->
    gleam_stdlib:identity(Builders).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 117).
-spec concat_bit_arrays(list(bitstring())) -> gleam@bytes_tree:bytes_tree().
concat_bit_arrays(Bits) ->
    gleam_stdlib:identity(Bits).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 128).
-spec from_string(binary()) -> gleam@bytes_tree:bytes_tree().
from_string(String) ->
    gleam_stdlib:wrap_list(String).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 139).
-spec from_string_builder(gleam@string_tree:string_tree()) -> gleam@bytes_tree:bytes_tree().
from_string_builder(Builder) ->
    gleam_stdlib:wrap_list(Builder).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 149).
-spec from_bit_array(bitstring()) -> gleam@bytes_tree:bytes_tree().
from_bit_array(Bits) ->
    gleam_stdlib:wrap_list(Bits).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 162).
-spec to_bit_array(gleam@bytes_tree:bytes_tree()) -> bitstring().
to_bit_array(Builder) ->
    erlang:list_to_bitstring(Builder).

-file("/Users/louis/src/gleam/stdlib/src/gleam/bytes_builder.gleam", 172).
-spec byte_size(gleam@bytes_tree:bytes_tree()) -> integer().
byte_size(Builder) ->
    erlang:iolist_size(Builder).
