OCAMLBUILD=ocamlbuild -tag debug -classic-display -use-ocamlfind
OCAMLDOCFLAGS=-docflags -colorize-code,-charset,utf-8
BUILDDIR=_build
DOCDIR=doc/api.docdir

all: lib test docs

salsa20_core: salsa20_core.ml salsa20_core.mli
	${OCAMLBUILD} salsa20_core.cmx

salsa20_core_test: salsa20_core_tests.ml salsa20_core
	${OCAMLBUILD} salsa20_core_tests.native

lib: scrypt.ml scrypt.mli salsa20_core
	${OCAMLBUILD} scrypt.cmx

test: scrypt_tests.ml salsa20_core_test
	${OCAMLBUILD} scrypt_tests.native

docs: scrypt.mli
	${OCAMLBUILD} -no-links ${OCAMLDOCFLAGS} doc/api.docdir/index.html
	cp doc/style.css ${BUILDDIR}/${DOCDIR}/style.css

clean:
	${OCAMLBUILD} -clean
	rm -rf _tests
	rm -f *.install
