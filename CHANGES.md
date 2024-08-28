# v1.0.0 (2024-08-28)

* Migrate scrypt from Cstruct.t to string
* Merge ocaml-pbkdf (from https://github.com/abeaumont/ocaml-pbkdf),
  hkdf (from https://github.com/hannesm/ocaml-hkdf), and scrypt (from
  https://github.com/abeaumont/ocaml-scrypt-kdf) into a single repository
  and opam package (with three subpackages, kdf.pbkdf. kdf.hkdf, and
  kdf.scrypt).
* Disable a failing testcase for architectures with integers no longer than 31
  bits (thanks to @kit-ty-kate)

# pbkdf 2.0.0 (2024-06-29)

* Update to mirage-crypto 1.0.0 (#13 @dinosaure)

# hkdf v2.0.0 (2024-06-29)

* use digestif instead of mirage-crypto (@dinosaure @hannesm)

# scrypt-kdf 1.2.0 (2021-08-03)

* Upgrade to Cstruct 6.0.0

# pbkdf 1.2.0 (2020-08-03)

* Upgrade to Cstruct 6.0.0

# pbkdf 1.1.0 (2020-03-31)

* Port to mirage-crypto (thanks to @hannesm)

# scrypt-kdf 1.1.0 (2020-03-31)

* Port to mirage-crypto (thanks to @hannesm)

# hkdf v1.0.4 (2020-03-11)

* use mirage-crypto instead of nocrypto

# scrypt-kdf 1.0.0 (2019-04-12)

* Move to dune
* Upgrade to opam 2.0

# pbkdf 1.0.0 (2019-04-12)

* Move to dune
* Upgrade to opam 2.0
* Reimplement `cdiv`, no longer available in `nocrypto`.

# hkdf 1.0.3 (2019-02-15)

* move to dune

# pbkdf 0.3.0 (2018-02-16)

* Build: switch to jbuilder

# scrypt-kdf 0.4.0 (2017-03-09)

* Removed Makefile, unneeded with topkg
* Made pkg.ml executable
* Added salsa20-core as a dependency and remove related code

# scrypt-kdf 0.3.0 (2017-02-21)

* Replaced underscores by dashes in library names
* Exported Salsa20_core module

# pbkdf 0.2.0 (2016-10-31)

* Added topkg dependency

# scrypt-kdf 0.2.0 (2016-10-31)

* Added topkg dependency
* Optimized inner loop in salsa_core to improve performance
* Replaced custom clone function by Nocrypto's implementation

# hkdf 1.0.2 (2016-07-18)

* move to topkg

# scrypt-kdf 0.1.0 (2016-03-18)

* Initial release

# pbkdf 0.1.0 (2016-03-14)

* Initial release

# hkdf 1.0.1 (2015-12-20)

* move from oasis to topkg

# hkdf 1.0.0 (2015-11-30)

* initial release
