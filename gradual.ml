open Lexer

let () =
  let lexbuf =
    Sedlexing.Utf8.from_string "((lambda (f : ? -> ?) f) (lambda (x : int) x))"
  in print_endline (String.concat " " (List.map show_token (tokenize lexbuf)));
;;
