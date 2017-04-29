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
