# Gradual Scheme

A gradually typed GTLC with Scheme-like syntax.

## Syntax of GTLC

- [x] AST
- [x] Allow type annotations
- [ ] Fix AST to have option type for annotations
- [x] Pretty print AST
- [x] REPL
- [ ] Gradual Typecheck - Need environment
- [ ] Evaluation? With casts

Extensions

- [ ] Blame, to be assigned by parser
- [ ] Type Inference

## Examples

```
A simple implementation of gradual scheme.
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


## References

http://norvig.com/lispy.html
