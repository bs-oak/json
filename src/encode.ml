type value = Js.Json.t

let encode _space v =
  Js.Json.stringify v 

let string v = 
  Js.Json.string v

let int v =
  Js.Json.number (float_of_int v)

let float v =
  Js.Json.number v

let bool v =
  Js.Json.boolean v

let null =
  Js.Json.null

let array v =
  Js.Json.array v

let list v =
  array (Array.of_list v)

let object' v =
  v
  |> Js.Dict.fromList
  |> Js.Json.object_