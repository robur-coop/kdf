OCAMLBUILD=ocamlbuild -tag debug -classic-display -use-ocamlfind
OCAMLDOCFLAGS=-docflags -colorize-code,-charset,utf-8
BUILDDIR=_build
DOCDIR=doc/api.docdir

all: lib test docs

salsa20_core: salsa20_core.ml salsa20_core.mli
	${OCAMLBUILD} salsa20_core.cmx

salsa20_core_test: salsa20_core_tests.ml salsa20_core
	${OCAMLBUILD} salsa20_core_tests.native

scrypt_kdf: scrypt_kdf.ml scrypt_kdf.mli
	${OCAMLBUILD} scrypt_kdf.cmx

scrypt_kdf_test: scrypt_kdf_tests.ml scrypt_kdf
	${OCAMLBUILD} scrypt_kdf_tests.native

lib: salsa20_core scrypt_kdf

test: salsa20_core_test scrypt_kdf_test

docs: salsa20.mli scrypt_kdf.mli
	${OCAMLBUILD} -no-links ${OCAMLDOCFLAGS} doc/api.docdir/index.html
	cp doc/style.css ${BUILDDIR}/${DOCDIR}/style.css

clean:
	${OCAMLBUILD} -clean
	rm -rf _tests
	rm -f *.install
