#!/usr/bin/env ocaml
#directory "pkg"
#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "scrypt-kdf" @@ fun _c ->
  Ok [
    Pkg.mllib "scrypt-kdf.mllib";
    Pkg.test "scrypt_kdf_tests"
  ]
