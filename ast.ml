type t =
  | TBool
  | TInt
  | TStar
  | TArrow of t * t
[@@deriving show]

type exp =
  | BoolL of bool
  | IntL of int
  | Var of string
  | Lambda of string * t * exp
  | App of exp * exp
[@@deriving show]
