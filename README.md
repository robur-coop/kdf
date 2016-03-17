[![docs](https://img.shields.io/badge/doc-online-blue.svg)](https://abeaumont.github.io/ocaml-scrypt-kdf)
[![Build Status](https://travis-ci.org/abeaumont/ocaml-scrypt-kdf.svg?branch=master)](https://travis-ci.org/abeaumont/ocaml-scrypt-kdf)

# The scrypt Password-Based Key Derivation Function

A pure OCaml implementation of [scrypt](https://en.wikipedia.org/wiki/Scrypt) password based key derivation function, as defined in [The scrypt Password-Based Key Derivation Function internet draft](https://tools.ietf.org/html/draft-josefsson-scrypt-kdf-04), including test cases from the RFC.

It also includes a pure OCaml implementation of [Salsa20 Core](http://cr.yp.to/salsa20.html) functions, both Salsa20/20 Core and the reduced Salsa20/8 Core (required by scrypt) and Salsa20/12 Core functions, including test cases from the spec.
