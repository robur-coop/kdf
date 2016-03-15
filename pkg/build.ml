#!/usr/bin/env ocaml
#directory "pkg";;
#use "topkg.ml";;

let alcotest = Env.bool "alcotest"
let () = Pkg.describe "scrypt-kdf" ~builder:(`OCamlbuild []) [
    Pkg.lib "pkg/META";
    Pkg.lib ~exts:Exts.module_library "salsa20_core";
    Pkg.lib ~exts:Exts.module_library "scrypt_kdf";
    Pkg.bin ~cond:alcotest ~auto:true "salsa20_core_tests";
    Pkg.bin ~cond:alcotest ~auto:true "scrypt_kdf_tests";
    Pkg.doc "README.md"; ]
