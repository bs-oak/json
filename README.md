Bucklescript OCaml JSON Decoder & Encoder ported from Elm.

bs-jsonx is intended to be used with the Bucklescript OCaml syntax. Although this package is fully compatible with the ReasonML by nature, the additional parentheses and other syntax required by ReasonML *may* make the functions in this package awkward to use.

# Getting Started
### Install

    npm i bs-jsonx

### Example Usage

    open BsJsonx.Decode
    
    let json = {| 
        { "first_name": "john", 
          "last_name": "doe", 
          "age": 29,
          "is_tall" : true,
        } 
    |} in
    
    let new_person first last age is_tall =
        (first, last, age, is_tall)
    in    

    decode_string (
        succeed new_person
            |: (field "first" string)
            |: (field "last" string)
            |: (optional (field "age" int))
            |: (field "is_tall" bool)            
    ) json
    

# Decode

### Primitives

#### string
Decode a JSON string into a string.

    decode_string string {| true |}        == Error ...
    decode_string string {| 42 |}          == Error ...
    decode_string string {| 3.14 |}        == Error ...
    decode_string string {| "hello" |}     == Ok "hello"
    decode_string string {| "hello": 42 |} == Error ...

#### bool
Decode a JSON boolean into a boolean.

    decode_string bool {| true |}        == Ok true
    decode_string bool {| 42 |}          == Error ...
    decode_string bool {| 3.14 |}        == Error ...
    decode_string bool {| "hello" |}     == Error ...
    decode_string bool {| "hello": 42 |} == Error ...

#### int
Decode a JSON number into an int.

    decode_string int {| true |}        == Error ...
    decode_string int {| 42 |}          == Ok 42
    decode_string int {| 3.14 |}        == Error ...
    decode_string int {| "hello" |}     == Error ...
    decode_string int {| "hello": 42 |} == Error ...

#### float
Decode a JSON number into a float.

    decode_string float {| true |}        == Error ...
    decode_string float {| 42 |}          == Ok 42.0
    decode_string float {| 3.14 |}        == Ok 3.14
    decode_string float {| "hello" |}     == Error ...
    decode_string float {| "hello": 42 |} == Error ...

#### value
Do not do anything with a JSON value, just bring in as a Value. This can be useful if 
you have particularly crazy data that you would like to deal with later. Or if you are 
going to send it out a port and do not care about its structure.

    decode_string value {| true |}        == Ok value



### Data Structures

#### nullable
Decode a nullable JSON value into an option.

    decodeString (nullable int) {| 13 |}    == Ok (Some 13)
    decodeString (nullable int) {| 42 |}    == Ok (Some 42)
    decodeString (nullable int) {| null |}  == Ok None
    decodeString (nullable int) {| true |}  == Err ..

#### list
Decode a JSON array into a list.

    decode_string (list int) {| [1,2,3] |}       == Ok [1; 2; 3]
    decode_string (list bool) {| [true,false] |} == Ok [true; false]

#### array
Decode a JSON array into an array.

    decode_string (array int) {| [1,2,3] |}       == Ok [| 1; 2; 3 |]
    decode_string (array bool) {| [true,false] |} == Ok [| true; false |]

#### dict
Decode a JSON object into a *Dict*.

    decode_string (dict int) {| { "alice": 42, "bob": 99 } |} 
        == Ok Dict
  
#### key_value_pairs
Decode a JSON object into a list of pairs.

    decode_string (key_value_pairs int) {| { "alice": 42, "bob": 99 } |}  
        == Ok [("alice", 42); ("bob", 99)]
  
### Object Primitives

#### field
Decode a JSON object, requiring a particular field.

    decode_string (field "x" int) {| { "x": 3 } |}             == Ok 3
    decode_string (field "x" int) {| { "x": 3, "y": 4 } |}     == Ok 3
    decode_string (field "x" int) {| { "x": true } |}          == Error ...
    decode_string (field "x" int) {| { "y": 4 } |}             == Error ...

The object  _can_  have other fields. Lots of them! The only thing this decoder cares about is if  `x`  is present and that the value there is an `int`.

Check out `map2` & `|:`  to see how to decode multiple fields!

#### at
Decode a nested JSON object, requiring certain fields.

    let json = {| { "person": { "name": "tom", "age": 42 } } |} in
    
    decode_string (at ["person"; "name"] string) json  == Ok "tom"
    decode_string (at ["person"; "age"] int) json  == Ok 42

    
This is really just a shorthand for saying things like:

    field "person" (field "name" string) == at ["person","name"] string

#### index
Decode a JSON array, requiring a particular index.

    let json = {| [ "alice", "bob", "chuck" ] |} in
    
    decode_string (index 0 string) json  == Ok "alice"
    decode_string (index 1 string) json  == Ok "bob"
    decode_string (index 2 string) json  == Ok "chuck"
    decode_string (index 3 string) json  == Error ...

### Inconsistent Structure

#### optional
Helpful for dealing with optional fields. Here are a few slightly different examples:

    let json = {| { "person": { "name": "tom", "age": 41 } } |} in
    
    decode_string (optional (field "age" int)) json == Ok (Some 41)
    decode_string (optional (field "name" int)) json == Ok None
    decode_string (optional (field "height" float)) json == Ok None
    
    decode_string (field "age" (optional int)) json == Ok (Some 41)
    decode_string (field "name" (optional int)) json == Ok None
    decode_string (field "height"(optional float)) json == Error...
    
Notice the last example! It is saying we  *must*  have a field named  `height`  and the content  *may*  be a float. There is no  `height`  field, so the decoder fails.

Point is,  `optional`  will make exactly what it contains conditional. For optional fields, this means you probably want it  *outside*  a use of  `field`  or  `at`.

    
#### one_of
Try a bunch of different decoders. This can be useful if the JSON may come in a couple different formats. For example, say you want to read an array of numbers, but some of them are `null`.

    let bad_int = one_of [ int, null 0 ] in

    decode_string (list bad_int) {| [1,2,null,4] |} == Ok [1,2,0,4]

    
    
### Run Decoders

#### decode_string
Parse the given string into a JSON value and then run the `decoder` on it. This will fail if the string is not well-formed JSON or if the `decoder` fails for some reason.

    decode_string int {| 4 |}       == Ok 4
    decode_string int {| "hello" |} == Error ...


#### decode_value
Run a `decoder` on some JSON Value. 


### Mapping

#### map
Transform a decoder. Maybe you want to transform a value into an OCaml option:

    let to_some x = Some x in
    
    decode_string (map to_some int) {| 4 |} == Ok (Some 4)

#### map2
Try two decoders and then combine the result. We can use this to decode objects with many fields:

    let json = {| { "x": 2, "y": 5 } |} in
    let point x y = (x, y) in
    let decoder =
        map2 point
            |> field "x" float
            |> field "y" float
    in
    decode_string decoder json == Ok (2, 5)

It tries each individual decoder and puts the result together with the `point`constructor.

**map3** to **map8** functional in the same manner as `map2`,  with each function accepting an incremental number of decoders as arguments. For example, the `map5` function can accept 5 decoder arguments:

    let address num str city state contry = 
        (num, str, city, state, country) 
    in

    let decoder =
            map5 address
                |> field "street_number" int
                |> field "street" string
                |> field "city" string
                |> field "state" string
                |> field "country" string                                
    in


#### and_map
In addition to use a `mapN` function, `and_map` provides a clean way to map multiple decoders to a function:

    let json = {| { "x": 2, "y": 5, "z": 9 } |} in
        let vector x y z = (x, y, z) in
        let decoder =
            succeed vector
                |> and_map (field "x" float)
                |> and_map (field "y" float)
                |> and_map (field "z" float)                
        in
        decode_string decoder json == Ok (2, 5, 9)

**\|:** is an infix shorthand for `and_map`

    let decoder =
        succeed vector
            |: (field "x" float)
            |: (field "y" float)
            |: (field "z" float)                
        
### Fancy Decoding

#### null
Decode a `null` value into a value.

    decode_string (null false) {| null |}        == Ok false
    decode_string (null 42) {| null |}           == Ok 42
    decode_string (null 42) {| 42 |}             == Error ...
    decode_string (null 42) {| false |}          == Error ...    
  
#### succeed
Ignore the JSON and produce a certain value.

    decode_string (succeed 42) {| true |}    == Ok 42
    decode_string (succeed 42) {| [1,2,3] |} == Ok 42
    decode_string (succeed 42) {| hello |}   == Error ... -- this is not a valid JSON string

#### fail
Ignore the JSON and make the decoder fail. This is handy when used with `one_of`or `and_then` where you want to give a custom error message in some case.

    decode_string (fail "my message") {| true |} == Error "my message"

#### and_then
Create decoders that depend on previous results. If you are creating versioned data, you might do something like this:

    let info_help version =
      match version with
        | 4 -> info_decoder4
        | 3 -> info_decoder3
        | _ -> fail "Trying to decode info, but version not supported"
    in
   
    field "version" int
       |> and_then info_help

# Encode

#### encode
Encode values into a JSON string.

    open BsJsonx.Encode

    encode 0
        (object'
            [  ("name", string "John Doe")
            ;  ("age", int 41)    
            ;  ("height", float 183.4)    
            ;  ("has_hair", bool true)
            ;  ("parent_id", null)
            ;  ("pets", array  
                    [| string "fluffy"
                    ;  string "zoomer"
                    ;  string "oscar" 
                    |]
                )
            ;  ("fav_colors", list  
                    [ string "red"
                    ; string "white" 
                    ]
                )
            ]
        )
    # => {"name":"John Doe","age":41,"height":183.4,"has_hair":true,"parent_id":null,"pets":["fluffy","zoomer","oscar"],"fav_colors":["red","white"]}


Signature

    type  value    
    val  encode : int -> value -> string
    val  string : string -> value
    val  int : int -> value
    val  float : float -> value
    val  bool : bool -> value
    val  null : value
    val  array : value array  -> value
    val  list : value list  -> value
    val  object' : (string * value)  list  -> value


## Credits

Jsonx is a port of the [Json.Decode](http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode) & [Json.Encode](http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Encode) packages from the Elm Core package. Thanks to Evan Czaplicki for all of his hard work.

## License

Copyright (c) 2018-present  [Erik Lott](https://github.com/eriklott)

Licensed under [MIT License](https://github.com/eriklott/bs-jsonx/blob/master/LICENSE)

