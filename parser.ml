open Ast
open Lexer

let rec parse_lambda (tokens : token list) : exp * token list =
  match tokens with
  | LPAREN::(ID id)::RPAREN::tail ->
     let exp, tail = parse_exp tail
     in (Lambda (id, exp), tail)
  | _ -> failwith "parse_lambda: Unexpected token"

and parse_app (tokens : token list) : exp * token list =
  let exp0, tail = parse_exp tokens
  in let exp1, tail = parse_exp tail
     in (match tail with
         | RPAREN::_ -> (App (exp0, exp1)), tail
         | _ -> failwith "parse_app: Unexpected token")

and parse_exp (tokens : token list) : exp * token list =
  match tokens with
  | TRUE::tail -> (BoolL true), tail
  | FALSE::tail -> (BoolL false), tail
  | (INTL n)::tail -> (IntL n), tail
  | (ID str)::tail -> (Var str), tail
  | LPAREN::LAMBDA::tail ->
     let lambda_exp, tail = parse_lambda tail
     in (match tail with
         | RPAREN::tail ->
            lambda_exp, tail
         | _ ->
            failwith "parse_exp: Unexpected token")
  | LPAREN::tail ->
     let app_exp, tail = parse_app tail
     in (match tail with
         | RPAREN::tail -> app_exp, tail
         | _ -> failwith "parse_exp: Unexpected token")
  | _ ->
     failwith "parse_exp: Unexpected token"

let parse (tokens : token list) : exp =
  match (parse_exp tokens) with
  | e, [] -> e
  | e, tail ->
     failwith "parse: Unexpected token"
