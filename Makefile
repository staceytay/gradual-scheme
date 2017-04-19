all:
	ocamlbuild \
	-pkgs ppx_deriving.std,sedlex \
	-use-ocamlfind \
	gradual.native

clean:
	rm -rf *.native _build
