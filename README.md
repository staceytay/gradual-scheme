# Gradual Scheme

A simple implementation of the Gradually Typed Lambda Calculus with a Scheme-like syntax in OCaml. For an introduction to gradual typing and more details on this implementation, see _[Gradual Typing and The Gradually Typed Lambda Calculus](https://stace.dev/static/gradual-typing-e034014d3c4358b7745a06490939788f.pdf)_.

## Examples

```scheme
A typechecker for a simple, gradual scheme.
    Here are some example expressions.
        #t
        (lambda (x) x)
        ((lambda (x : int) x) 42)
        ((lambda : ? -> ? (x : ? -> ?) x) (lambda : bool (x : bool) x))
    Here are some misannotated example expressions.
        ((lambda (x : int) x) #t)
        ((lambda : int -> int (x : int -> int) x) (lambda (x : bool) x))

> (lambda (x) x)
[INPUT] (lambda (x) x)
[OK] (lambda (x) x)
> ((lambda (x : int) x) #t)
[ERROR] int is not consistent with bool.
```

## Installing

```bash
# Install dependencies.
> opam install ppx_deriving sedlex

# Build.
> make

# Run REPL.
> ./gradual.native
```


## Implementation Checklist

- [x] AST
- [x] Allow type annotations
- [ ] Fix AST to have option type for annotations
- [x] Pretty print AST
- [x] REPL
- [ ] Support assignment operation
- [ ] Support evaluation with casts

### Extensions

- [ ] Blame, to be assigned by parser
- [ ] Type Inference

## References

- [(How to Write a (Lisp) Interpreter (in Python))](http://norvig.com/lispy.html)
