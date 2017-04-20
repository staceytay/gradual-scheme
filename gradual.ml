open Ast
open Lexer
open Parser

let untyped_exp = [
    "123";
    "#t";
    "(lambda (x) x)";
    "(lambda (x) (x 1))";
    "((lambda (f) f) (lambda (x) x))";
  ]

let typed_exp = [
    "((lambda (f : ? -> ?) f) (lambda (x : int) x))";
  ]

let print_ast (input : string) : unit =
  Printf.printf "INPUT: %s\n" input;
  let lexbuf = Sedlexing.Utf8.from_string input
  in let tokens = tokenize lexbuf
     in let ast =
          Printf.printf "TOKENS: ";
          print_endline (String.concat " " (List.map show_token tokens));
          parse tokens
        in Printf.printf "AST: %s\n" (show_exp ast);
           print_endline "-----------------------------------------------------------------------"
;;

List.map print_ast untyped_exp

