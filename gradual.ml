open Ast
open Checker
open Lexer
open Parser

let example_exp = [
  "#t";
  "(lambda (x) x)";
  "((lambda (x : int) x) 42)";
  "((lambda : ? -> ? (x : ? -> ?) x) (lambda : bool (x : bool) x))";
]

let misannotated_exp = [
  "((lambda (x : int) x) #t)";
  "((lambda : int -> int (x : int -> int) x) (lambda (x : bool) x))";
]

let welcome_message =
  "A typechecker for a simple, gradual scheme.\n" ^
  "    Here are some example expressions.\n" ^
  "        " ^ (String.concat "\n        " example_exp) ^ "\n" ^
  "    Here are some misannotated example expressions.\n" ^
  "        " ^ (String.concat "\n        " misannotated_exp) ^ "\n" ^
  "\n"

let check_input input =
  try
    let tokens = tokenize input
    in match tokens with
    | [] -> ()
    | _ ->
      let ast = parse tokens
      in let _ = type_check [] ast
      in Printf.printf "[INPUT] %s\n" input;
      Printf.printf "[OK] %s\n" input
  with
  | Application_inconsistent_types ((e1, t1), (e2, t2)) ->
    Printf.printf "[ERROR] %s is not consistent with %s.\n"
      (string_of_t t1) (string_of_t t2);
  | Application_non_procedure (e, t)  ->
    Printf.printf "[ERROR] %s has type %s and is not a procedure.\n"
      (show_exp e) (string_of_t t);
  | Misannotated_return_type (e, t) ->
    Printf.printf "[ERROR] Misannotated return type %s for %s.\n"
      (string_of_t t) (show_exp e)
  | Parse_error token ->
    Printf.printf "[ERROR] Unexpected token %s in %s.\n"
      (show_token token) input
  | Parser_invalid_annot token ->
    Printf.printf "[ERROR] Invalid annotation syntax %s in %s.\n"
      (show_token token) input
  | Parser_missing_rparen ->
    Printf.printf "[ERROR] Missing closing parenthesis in %s.\n" input
  | Parser_unexpected_end ->
    Printf.printf "[ERROR] Unexpected end in %s.\n" input
  | Syntax_error s ->
    Printf.printf "[ERROR] Invalid syntax %s in %s.\n" s input

let rec rcpl () =
  print_string "> ";
  check_input (read_line ());
  rcpl ()

let () =
  print_string welcome_message;
  rcpl ()
