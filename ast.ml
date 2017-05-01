type t =
  | BoolT
  | IntT
  | StarT
  | ArrowT of t * t
[@@deriving show]

type exp =
  | BoolL of bool
  | IntL of int
  | Var of string
  | Lambda of string * exp * t
  | App of exp * exp
[@@deriving show]

type texp = exp * t

let rec string_of_t t =
  match t with
  | BoolT -> "bool"
  | IntT -> "int"
  | StarT -> "?"
  | ArrowT (t1, t2) -> (string_of_t t1) ^ " -> " ^ (string_of_t t2)
