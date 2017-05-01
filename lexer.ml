type token =
  | ARROW
  | BOOL
  | COLON
  | FALSE
  | ID of string
  | INT
  | INTL of int
  | LAMBDA
  | LPAREN
  | RPAREN
  | STAR
  | TRUE
[@@deriving show]

exception Syntax_error of string

let digit = [%sedlex.regexp? '0'..'9']
let number = [%sedlex.regexp? Plus digit]
let letter = [%sedlex.regexp? 'a'..'z'|'A'..'Z']

let tokenize input =
  let rec aux buf tokens =
    match%sedlex buf with
    | '(' -> aux buf (LPAREN::tokens)
    | ')' -> aux buf (RPAREN::tokens)
    | ':' -> aux buf (COLON::tokens)
    | '?' -> aux buf (STAR::tokens)
    | "->" -> aux buf (ARROW::tokens)
    | "bool" -> aux buf (BOOL::tokens)
    | "int" -> aux buf (INT::tokens)
    | "#t" -> aux buf (TRUE::tokens)
    | "#f" -> aux buf (FALSE::tokens)
    | "lambda" -> aux buf (LAMBDA::tokens)
    | number ->
       aux buf (INTL (int_of_string (Sedlexing.Utf8.lexeme buf))::tokens)
    | letter, Star ('A'..'Z' | 'a'..'z' | digit) ->
       aux buf (ID (Sedlexing.Utf8.lexeme buf)::tokens)
    | white_space -> aux buf tokens
    | eof -> tokens
    | any ->
       let char = Sedlexing.Utf8.lexeme buf
       in raise (Syntax_error char)
    | _ -> assert false
  in List.rev (aux (Sedlexing.Utf8.from_string input) [])
;;
