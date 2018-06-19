open Jest
open Expect

let () = describe "Decode" (fun () -> 

    describe "#string" (fun () -> 
        test "ok on string" (fun () -> 
            expect (Decode.decode_string Decode.string {| "hello" |}) |> toEqual( Belt.Result.Ok "hello" )
        );
        test "error on bool" (fun () -> 
            expect (Decode.decode_string Decode.string {| true |}) |> toEqual( Belt.Result.Error "failed to decode json as string: true" )
        );
        test "error on int" (fun () -> 
            expect (Decode.decode_string Decode.string {| 3 |}) |> toEqual( Belt.Result.Error "failed to decode json as string: 3" )
        );          
        test "error on float" (fun () -> 
            expect (Decode.decode_string Decode.string {| 3.14 |}) |> toEqual( Belt.Result.Error "failed to decode json as string: 3.14" )
        );    
        test "error on array" (fun () -> 
            expect (Decode.decode_string Decode.string {| ["a", "b", "c"] |}) |> toEqual( Belt.Result.Error "failed to decode json as string: [\"a\",\"b\",\"c\"]" )
        );     
        test "error on object" (fun () -> 
            expect (Decode.decode_string Decode.string {| {"name":"bob"} |}) |> toEqual( Belt.Result.Error "failed to decode json as string: {\"name\":\"bob\"}" )
        );     
        test "error on null" (fun () -> 
            expect (Decode.decode_string Decode.string {| null |}) |> toEqual( Belt.Result.Error "failed to decode json as string: null" )
        );                      
    );

    describe "#bool" (fun () -> 
        test "error on string" (fun () -> 
            expect (Decode.decode_string Decode.bool {| "hello" |}) |> toEqual( Belt.Result.Error "failed to decode json as bool: \"hello\"" )
        );
        test "ok on bool" (fun () -> 
            expect (Decode.decode_string Decode.bool {| true |}) |> toEqual( Belt.Result.Ok true )
        );
        test "error on int" (fun () -> 
            expect (Decode.decode_string Decode.bool {| 3 |}) |> toEqual( Belt.Result.Error "failed to decode json as bool: 3" )
        );          
        test "error on float" (fun () -> 
            expect (Decode.decode_string Decode.bool {| 3.14 |}) |> toEqual( Belt.Result.Error "failed to decode json as bool: 3.14" )
        );    
        test "error on array" (fun () -> 
            expect (Decode.decode_string Decode.bool {| ["a", "b", "c"] |}) |> toEqual( Belt.Result.Error "failed to decode json as bool: [\"a\",\"b\",\"c\"]" )
        );     
        test "error on object" (fun () -> 
            expect (Decode.decode_string Decode.bool {| {"name":"bob"} |}) |> toEqual( Belt.Result.Error "failed to decode json as bool: {\"name\":\"bob\"}" )
        );     
        test "error on null" (fun () -> 
            expect (Decode.decode_string Decode.bool {| null |}) |> toEqual( Belt.Result.Error "failed to decode json as bool: null" )
        );                      
    );

    describe "#int" (fun () -> 
        test "error on string" (fun () -> 
            expect (Decode.decode_string Decode.int {| "hello" |}) |> toEqual( Belt.Result.Error "failed to decode json as int: \"hello\"" )
        );
        test "error on bool" (fun () -> 
            expect (Decode.decode_string Decode.int {| true |}) |> toEqual( Belt.Result.Error "failed to decode json as int: true" )
        );
        test "ok on int" (fun () -> 
            expect (Decode.decode_string Decode.int {| 3 |}) |> toEqual( Belt.Result.Ok 3 )
        );  
        test "error on float" (fun () -> 
            expect (Decode.decode_string Decode.int {| 3.14 |}) |> toEqual( Belt.Result.Error "failed to decode json as int: 3.14" )
        );    
        test "error on array" (fun () -> 
            expect (Decode.decode_string Decode.int {| ["a", "b", "c"] |}) |> toEqual( Belt.Result.Error "failed to decode json as int: [\"a\",\"b\",\"c\"]" )
        );     
        test "error on object" (fun () -> 
            expect (Decode.decode_string Decode.int {| {"name":"bob"} |}) |> toEqual( Belt.Result.Error "failed to decode json as int: {\"name\":\"bob\"}" )
        );     
        test "error on null" (fun () -> 
            expect (Decode.decode_string Decode.int {| null |}) |> toEqual( Belt.Result.Error "failed to decode json as int: null" )
        );                      
    );

    describe "#float" (fun () -> 
        test "error on string" (fun () -> 
            expect (Decode.decode_string Decode.float {| "hello" |}) |> toEqual( Belt.Result.Error "failed to decode json as float: \"hello\"" )
        );
        test "error on bool" (fun () -> 
            expect (Decode.decode_string Decode.float {| true |}) |> toEqual( Belt.Result.Error "failed to decode json as float: true" )
        );
        test "ok on int" (fun () -> 
            expect (Decode.decode_string Decode.float {| 3 |}) |> toEqual( Belt.Result.Ok 3.0 )
        );  
        test "ok on float" (fun () -> 
            expect (Decode.decode_string Decode.float {| 3.14 |}) |> toEqual( Belt.Result.Ok 3.14 )
        );    
        test "error on array" (fun () -> 
            expect (Decode.decode_string Decode.float {| ["a", "b", "c"] |}) |> toEqual( Belt.Result.Error "failed to decode json as float: [\"a\",\"b\",\"c\"]" )
        );     
        test "error on object" (fun () -> 
            expect (Decode.decode_string Decode.float {| {"name":"bob"} |}) |> toEqual( Belt.Result.Error "failed to decode json as float: {\"name\":\"bob\"}" )
        );     
        test "error on null" (fun () -> 
            expect (Decode.decode_string Decode.float {| null |}) |> toEqual( Belt.Result.Error "failed to decode json as float: null" )
        );                      
    );

    describe "#null" (fun () -> 
        test "ok on null" (fun () -> 
            expect (Decode.decode_string (Decode.null 25) {| null |}) |> toEqual( Belt.Result.Ok 25 )
        );
        test "error on non-null" (fun () -> 
            expect (Decode.decode_string (Decode.null 25) {| "hello" |}) |> toEqual( Belt.Result.Error "failed to decode json as null: \"hello\"" )
        );                    
    );    

    describe "#map" (fun () -> 
        test "map to option" (fun () -> 
            expect (Decode.decode_string (Decode.map (fun x -> Some x) Decode.int) {| 25 |}) |> toEqual( Belt.Result.Ok (Some 25) )
        );                  
    );    

    describe "#map2" (fun () -> 
        test "map 2 values" (fun () -> 
            expect (Decode.decode_string (Decode.map2 (fun a b -> (a, b)) (Decode.field "name" Decode.string) (Decode.field "age" Decode.int)   ) {| { "name": "tom", "age": 42 } |}) |> toEqual( Belt.Result.Ok ("tom", 42) )
        );                  
    );     

    describe "#nullable" (fun () -> 
        test "decode with value" (fun () -> 
            expect (Decode.decode_string (Decode.nullable Decode.int) {| 76 |}) |> toEqual( Belt.Result.Ok (Some 76) )
        );
        test "decode with null" (fun () -> 
            expect (Decode.decode_string (Decode.nullable Decode.int) {| null |}) |> toEqual( Belt.Result.Ok None )
        );
        test "decode with incorrect value type" (fun () -> 
            expect (Decode.decode_string (Decode.nullable Decode.int) {| "hello" |}) |> toEqual( Belt.Result.Error "failed to decode json as int: \"hello\"" )
        );        
    );       

    describe "#list" (fun () -> 
        test "decodes to list" (fun () -> 
            expect (Decode.decode_string (Decode.list Decode.int) {| [1,2,3] |}) |> toEqual( Belt.Result.Ok [1;2;3] )
        );       
    );   

    describe "#array" (fun () -> 
        test "decodes to array" (fun () -> 
            expect (Decode.decode_string (Decode.array Decode.int) {| [1,2,3] |}) |> toEqual( Belt.Result.Ok [|1;2;3|] )
        );       
    );        

    describe "#dict" (fun () -> 
        test "decodes to array" (fun () -> 
            let want = 
                Decode.Dict.empty
                    |> Decode.Dict.add "alice" 42
                    |> Decode.Dict.add "bob" 99
            in
            expect (Decode.decode_string (Decode.dict Decode.int) {| { "alice": 42, "bob": 99 } |}) |> toEqual( Belt.Result.Ok want )
        );       
    );   

    describe "#dict" (fun () -> 
        test "decodes to key value list" (fun () -> 
            expect (Decode.decode_string (Decode.key_value_pairs Decode.int) {| { "alice": 42, "bob": 99 } |}) |> toEqual( Belt.Result.Ok [("alice", 42);("bob", 99)] )
        );       
    );      

    describe "#field" (fun () -> 
        test "ok when field exists" (fun () -> 
            expect (Decode.decode_string (Decode.field "bob" Decode.int) {| { "alice": 42, "bob": 99 } |}) |> toEqual( Belt.Result.Ok 99 )
        );       
        test "error when field does not exist" (fun () -> 
            expect (Decode.decode_string (Decode.field "frank" Decode.int) {| { "alice": 42, "bob": 99 } |}) |> toEqual( Belt.Result.Error "failed to decode json field 'frank': {\"alice\":42,\"bob\":99}" )
        );
    );   

    describe "#at" (fun () -> 
        test "ok when field exists" (fun () -> 
            expect (Decode.decode_string (Decode.at ["person"; "name"] Decode.string) {| { "person": { "name": "tom", "age": 42 } } |}) |> toEqual( Belt.Result.Ok "tom" )
        );
    );   

    describe "#index" (fun () -> 
        test "ok when element at index exists" (fun () -> 
            expect (Decode.decode_string (Decode.index 0 Decode.string) {| ["alice", "bob", "chuck"] |}) |> toEqual( Belt.Result.Ok "alice" )
        );
        test "error when index is invalid" (fun () -> 
            expect (Decode.decode_string (Decode.index 99 Decode.string) {| ["alice", "bob", "chuck"] |}) |> toEqual( Belt.Result.Error "failed to decode json at index '99': [\"alice\",\"bob\",\"chuck\"]" )
        );        
    );   

    describe "#optional" (fun () -> 
        test "ok when sub-decoder succeeds" (fun () -> 
            expect (Decode.decode_string (Decode.optional (Decode.field "age" Decode.int)) {| { "name": "tom", "age": 42 } |}) |> toEqual( Belt.Result.Ok (Some 42) )
        );
        test "ok when sub-decoder fails" (fun () -> 
            expect (Decode.decode_string (Decode.optional (Decode.field "name" Decode.int)) {| { "name": "tom", "age": 42 } |}) |> toEqual( Belt.Result.Ok None )
        );
    );    

    describe "#succeed" (fun () -> 
        test "ok on anything" (fun () -> 
            expect (Decode.decode_string (Decode.succeed 42) {| { "name": "tom", "age": 42 } |}) |> toEqual( Belt.Result.Ok 42 )
        );
    );   

    describe "#fail" (fun () -> 
        test "error on anything" (fun () -> 
            expect (Decode.decode_string (Decode.fail "failure") {| { "name": "tom", "age": 42 } |}) |> toEqual( Belt.Result.Error "failure" )
        );
    );    

    describe "#and_then" (fun () -> 
        test "complex" (fun () -> 
            let json = {| { "name": "tom", "age" : 43 } |} in
            let new_user name age = (name, age) in
            let decoder =
                Decode.succeed new_user
                    |> Decode.and_then (fun f -> Decode.map f (Decode.field "name" Decode.string))
                    |> Decode.and_then (fun f -> Decode.map f (Decode.field "age" Decode.int))
            in
            expect (Decode.decode_string decoder json) |> toEqual( Belt.Result.Ok ("tom", 43) )
        );
    );

    describe "#and_map" (fun () -> 
        test "maps decoder values to function" (fun () -> 
            let json = {| { "name": "tom", "age" : 43 } |} in
            let new_user name age = (name, age) in
            let decoder =
                Decode.succeed new_user
                    |> Decode.and_map (Decode.field "name" Decode.string)
                    |> Decode.and_map (Decode.field "age" Decode.int)
            in
            expect (Decode.decode_string decoder json) |> toEqual( Belt.Result.Ok ("tom", 43) )
        );
    );
)