module Dict : Map.S with type key = string

type value

type 'a decoder

val decode_string : 'a decoder -> string -> ('a, string) BsOakBase.Result.t

val decode_value : 'a decoder -> value -> ('a, string) BsOakBase.Result.t

(* Primitive Decoders *)

val value : value decoder

val string : string decoder

val bool : bool decoder

val int : int decoder

val float : float decoder

val null : 'a -> 'a decoder

(* Data Structure Decoders *)

val nullable : 'a decoder -> 'a option decoder

val list : 'a decoder -> 'a list decoder

val array : 'a decoder -> 'a array decoder

val dict : 'a decoder -> 'a Dict.t decoder

val key_value_pairs : 'a decoder -> (string * 'a) list decoder

(* Object Primitives *)

val field : string -> 'a decoder -> 'a decoder

val at : string list -> 'a decoder -> 'a decoder

val index : int -> 'a decoder -> 'a decoder

(* Inconsistent Structure *)

val optional : 'a decoder -> 'a option decoder

val one_of :  'a decoder list -> 'a decoder

(* Mapping *)

val map : ('a -> 'b) -> 'a decoder -> 'b decoder

val map2 :
  ('a -> 'b -> 'c) ->
  'a decoder ->
  'b decoder -> 
  'c decoder

val map3 :
  ('a -> 'b -> 'c -> 'd) ->
  'a decoder ->
  'b decoder ->
  'c decoder -> 
  'd decoder

val map4 :
  ('a -> 'b -> 'c -> 'd -> 'e) ->
  'a decoder ->
  'b decoder ->
  'c decoder ->
  'd decoder -> 
  'e decoder

val map5 :
  ('a -> 'b -> 'c -> 'd -> 'e -> 'f) ->
  'a decoder ->
  'b decoder ->
  'c decoder ->
  'd decoder ->
  'e decoder -> 
  'f decoder

val map6 :
  ('a -> 'b -> 'c -> 'd -> 'e -> 'f -> 'g) ->
  'a decoder ->
  'b decoder ->
  'c decoder ->
  'd decoder ->
  'e decoder ->
  'f decoder -> 
  'g decoder

val map7 :
  ('a -> 'b -> 'c -> 'd -> 'e -> 'f -> 'g -> 'h) ->
  'a decoder ->
  'b decoder ->
  'c decoder ->
  'd decoder ->
  'e decoder ->
  'f decoder -> 
  'g decoder ->
  'h decoder

val map8 :
  ('a -> 'b -> 'c -> 'd -> 'e -> 'f -> 'g -> 'h -> 'i) ->
  'a decoder ->
  'b decoder ->
  'c decoder ->
  'd decoder ->
  'e decoder ->
  'f decoder -> 
  'g decoder ->
  'h decoder ->
  'i decoder

(* Fancy Decoding *)

val succeed : 'a -> 'a decoder

val fail : string -> 'a decoder

val and_then : ('a -> 'b decoder) -> 'a decoder -> 'b decoder

val and_map : 'a decoder -> ('a -> 'b) decoder -> 'b decoder

val (|:) : 'a decoder -> ('a -> 'b) decoder -> 'b decoder