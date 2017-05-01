open Ast
open Lexer

let rec parse_annotation (tokens : token list) : t * token list =
  match tokens with
  | BOOL::ARROW::tail ->
    let t, tail = parse_annotation tail
    in (ArrowT (BoolT, t)), tail
  | INT::ARROW::tail ->
    let t, tail = parse_annotation tail
    in (ArrowT (IntT, t)), tail
  | STAR::ARROW::tail ->
    let t, tail = parse_annotation tail
    in (ArrowT (StarT, t)), tail
  | BOOL::tail -> BoolT, tail
  | INT::tail -> IntT, tail
  | STAR::tail -> StarT, tail
  | _ -> failwith "parse_annotation: Unexpected token"

let rec parse_lambda (tokens : token list) : exp * token list =
  let rett, tail =
    (match tokens with
     | COLON::tail -> parse_annotation tail
     | LPAREN::_ -> StarT, tokens
     | _ -> failwith "parse_lambda: Unexpected token")
  in let id, argt, tail =
       (match tail with
        | LPAREN::(ID id)::COLON::tail ->
          let t, tail = parse_annotation tail
          in let tail =
               (match tail with
                | RPAREN::tail -> tail
                | _ -> failwith "parse_lambda: Unexpected token")
          in id, t, tail
        | LPAREN::(ID id)::RPAREN::tail -> id, StarT, tail
        | _ -> failwith "parse_lambda: Unexpected token")
  in let exp, tail = parse_exp tail
  in (Lambda (id, exp, ArrowT (argt, rett)), tail)

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
