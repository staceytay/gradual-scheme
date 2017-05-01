open Ast

exception Application_inconsistent_types of (texp * texp)
exception Application_non_procedure of texp
exception Misannotated_return_type of (exp * t)

let rec is_consistent (t1 : t) (t2 : t) : bool =
  match t1, t2 with
  | BoolT, BoolT
  | IntT, IntT
  | StarT, _ | _, StarT -> true
  | ArrowT (t1, t2), ArrowT (t3, t4) ->
    (is_consistent t1 t3) && (is_consistent t2 t4)
  | _, _ -> false

let rec type_check (env : (string * t) list) (e : exp) : texp =
  match e with
  | BoolL _ -> e, BoolT
  | IntL _ -> e, IntT
  | Var v ->
    let mapped (arg, argt) = (arg = v)
    in if List.exists mapped env
    then e, (snd (List.find mapped env))
    else e, StarT
  | Lambda (arg, eb, t) ->
    (match t with
     | ArrowT (argt, rett) ->
       let _, tb = type_check ((arg, argt)::env) eb
       in if is_consistent rett tb
       then e, t
       else raise (Misannotated_return_type (eb, rett))
     | _ -> assert false)
  | App (e1, e2) ->
    let _, t1 = type_check env e1
    in let _, t2 = type_check env e2
    in (match t1 with
    | ArrowT (argt, rett) ->
      if is_consistent argt t2
      then e, t2
      else raise (Application_inconsistent_types ((e1, argt), (e2, t2)))
    | StarT -> e, StarT
    | _ -> raise (Application_non_procedure (e1, t1)))
