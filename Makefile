OCAMLBUILD=ocamlbuild -tag debug -classic-display -use-ocamlfind
OCAMLDOCFLAGS=-docflags -colorize-code,-charset,utf-8
BUILDDIR=_build
DOCDIR=doc/api.docdir

all: lib test docs

scrypt_kdf: scrypt_kdf.ml scrypt_kdf.mli
	${OCAMLBUILD} scrypt_kdf.cmx

scrypt_kdf_test: scrypt_kdf_tests.ml scrypt_kdf
	${OCAMLBUILD} scrypt_kdf_tests.native

lib: scrypt_kdf

test: scrypt_kdf_test

docs: scrypt_kdf.mli
	${OCAMLBUILD} -no-links ${OCAMLDOCFLAGS} doc/api.docdir/index.html
	cp doc/style.css ${BUILDDIR}/${DOCDIR}/style.css

clean:
	${OCAMLBUILD} -clean
	rm -rf _tests
	rm -f *.install
