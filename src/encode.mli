type value

val encode : int -> value -> string

val string : string -> value

val int : int -> value

val float : float -> value

val bool : bool -> value

val null : value

val array : value array -> value

val list : value list -> value

val object' : (string * value) list -> value