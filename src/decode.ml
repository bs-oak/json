module Dict = Map.Make(String)

type value = Js.Json.t

type 'a decoder = value -> 'a

(* helpers *)

let is_int v =
  let c = classify_float (fst (modf v)) in
  c == FP_zero

let value_to_string v =
  try 
    Js.Json.stringify v
  with
    _ -> "[value]"

(* Run Decoder *)

let decode_value decode v =
  try
    Belt.Result.Ok (decode v)
  with
    Failure msg -> Belt.Result.Error msg

let decode_string decode json_str =
  try 
    let value = Js.Json.parseExn json_str in
    decode_value decode value
  with
    _ -> Belt.Result.Error ( Printf.sprintf "failed to decode json string: %s" json_str )

(* Primitive Decoders *)

let value v = 
  v

let string v = 
  match Js.Json.classify v with
  | JSONString str -> str
  | _ -> failwith ( Printf.sprintf "failed to decode json as string: %s" ( value_to_string v ) )

let bool v =
  match Js.Json.classify v with
  | JSONTrue -> true
  | JSONFalse -> false
  | _ -> failwith ( Printf.sprintf "failed to decode json as bool: %s" ( value_to_string v ) )

let int v = 
  let fail () = failwith ( Printf.sprintf "failed to decode json as int: %s" ( value_to_string v ) ) in
  match Js.Json.classify v with
  | JSONNumber f -> 
    if is_int f 
    then int_of_float f
    else fail ()
  | _ -> fail ()

let float v = 
  match Js.Json.classify v with
  | JSONNumber f -> f
  | _ -> failwith ( Printf.sprintf "failed to decode json as float: %s" ( value_to_string v ) ) 

let null default v = 
  match Js.Json.classify v with
  | JSONNull -> default
  | _ -> failwith ( Printf.sprintf "failed to decode json as null: %s" ( value_to_string v ) )


(* Inconsistent Structure *)

let optional decoder v =
  try Some (decoder v)
  with _ -> None

let one_of decoders v =
  let rec first ds = 
    match ds with
    | decoder :: xs -> (try decoder v with _ -> first xs)
    | [] -> failwith ( Printf.sprintf "failed to decode json using any one of the provided decoders: %s" ( value_to_string v ) )
  in 
  first decoders

(* Mapping *)

let map mapper decoder v =
  mapper (decoder v)

let map2 mapper d1 d2 v =
  let v1 = d1 v in
  let v2 = d2 v in
  mapper v1 v2

let map3 mapper d1 d2 d3 v =
  let v1 = d1 v in
  let v2 = d2 v in
  let v3 = d3 v in
  mapper v1 v2 v3

let map4 mapper d1 d2 d3 d4 v =
  let v1 = d1 v in
  let v2 = d2 v in
  let v3 = d3 v in
  let v4 = d4 v in
  mapper v1 v2 v3 v4

let map5 mapper d1 d2 d3 d4 d5 v =
  let v1 = d1 v in
  let v2 = d2 v in
  let v3 = d3 v in
  let v4 = d4 v in
  let v5 = d5 v in
  mapper v1 v2 v3 v4 v5

let map6 mapper d1 d2 d3 d4 d5 d6 v =
  let v1 = d1 v in
  let v2 = d2 v in
  let v3 = d3 v in
  let v4 = d4 v in
  let v5 = d5 v in
  let v6 = d6 v in
  mapper v1 v2 v3 v4 v5 v6

let map7 mapper d1 d2 d3 d4 d5 d6 d7 v =
  let v1 = d1 v in
  let v2 = d2 v in
  let v3 = d3 v in
  let v4 = d4 v in
  let v5 = d5 v in
  let v6 = d6 v in
  let v7 = d7 v in
  mapper v1 v2 v3 v4 v5 v6 v7

let map8 mapper d1 d2 d3 d4 d5 d6 d7 d8 v =
  let v1 = d1 v in
  let v2 = d2 v in
  let v3 = d3 v in
  let v4 = d4 v in
  let v5 = d5 v in
  let v6 = d6 v in
  let v7 = d7 v in
  let v8 = d8 v in
  mapper v1 v2 v3 v4 v5 v6 v7 v8

(* Data Structure Decoders *)

let nullable decoder state =
  try null None state
  with _ -> (map (fun x -> Some x) decoder) state

let list decoder v =
  match Js.Json.classify v with
  | JSONArray vs -> 
    vs
    |> Array.to_list
    |> List.map decoder
  | _ -> failwith ( Printf.sprintf "failed to decode json as a list: %s" ( value_to_string v ) )

let array decoder v =
  match Js.Json.classify v with
  | JSONArray vs -> Array.map decoder vs
  | _ -> failwith ( Printf.sprintf "failed to decode json as an array: %s" ( value_to_string v ) )

let dict decoder v =
  match Js.Json.classify v with
  | JSONObject dict -> 
    dict
    |> Js.Dict.entries
    |> Array.fold_left 
      (fun m (k, v') -> Dict.add k (decoder v') m) 
      Dict.empty
  | _ -> failwith ( Printf.sprintf "failed to decode json as a dict: %s" ( value_to_string v ) )

let key_value_pairs decoder v =
  match Js.Json.classify v with
  | JSONObject dict -> 
    dict
    |> Js.Dict.entries
    |> Array.to_list
    |> List.map (fun (k, v') -> (k, decoder v'))
  | _ -> failwith ( Printf.sprintf "failed to decode json as key value pairs: %s" ( value_to_string v ) )

(* Object Primitives *)

let field k decoder v =
  let fail () = failwith ( Printf.sprintf "failed to decode json field '%s': %s" k ( value_to_string v ) ) in
  match Js.Json.classify v with
  | JSONObject dict -> 
    (match Js.Dict.get dict k with
     | Some v' -> decoder v'
     | None -> fail ()
    )
  | _ -> fail ()

let at fields decoder = 
  List.fold_right field fields decoder

let index idx decoder v =
  let fail () = failwith ( Printf.sprintf "failed to decode json at index '%d': %s" idx ( value_to_string v ) ) in
  match Js.Json.classify v with
  | JSONArray vs -> 
    (try decoder(Array.get vs idx)
     with _ -> fail ())
  | _ -> fail ()

(* Fancy Decoding *)

let succeed value _ =
  value

let fail msg _ =
  failwith msg

let and_then to_decoder decoder v =
  (to_decoder (decoder v)) v

let and_map d1 d2 = 
  and_then (fun f -> map f d1) d2

let (|:) = and_map