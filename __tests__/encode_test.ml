open Jest
open Expect

let () = describe "Encode" (fun () -> 
    describe "#encode" (fun () -> 
        test "encodes values to json string" (fun () -> 
            let got =
                Encode.encode 0
                    (Encode.object' 
                        [ ("name", Encode.string "John Doe")
                        ; ("age", Encode.int 41)
                        ; ("height", Encode.float 183.4)
                        ; ("has_hair", Encode.bool true)
                        ; ("parent_id", Encode.null)
                        ; ("pets", Encode.array [| Encode.string "fluffy"; Encode.string "zoomer"; Encode.string "oscar" |])
                        ; ("fav_colors", Encode.list [ Encode.string "red"; Encode.string "white" ])
                        ])
            in
            let want =
                {|{"name":"John Doe","age":41,"height":183.4,"has_hair":true,"parent_id":null,"pets":["fluffy","zoomer","oscar"],"fav_colors":["red","white"]}|}
            in
            expect want |> toEqual got
        );    
    );
)