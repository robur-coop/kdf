let test_scrypt_kdf ~password ~salt ~n ~r ~p ~dk_len ~dk =
  let dk = Ohex.decode dk in
  (fun () ->
     let edk = Scrypt.scrypt ~password ~salt ~n ~r ~p ~dk_len in
     Alcotest.check Alcotest.string "Scrypt test" edk dk)

let scrypt_kdf_test1 =
  test_scrypt_kdf
    ~password:""
    ~salt:""
    ~n:16
    ~r:1
    ~p:1
    ~dk_len:64l
    ~dk:"77d6576238657b203b19ca42c18a0497f16b4844e3074ae8dfdffa3fede21442fcd0069ded0948f8326a753a0fc81f17e8d3e0fb2e0d3628cf35e20c38d18906"

let scrypt_kdf_test2 =
  test_scrypt_kdf
    ~password:"password"
    ~salt:"NaCl"
    ~n:1024
    ~r:8
    ~p:16
    ~dk_len:64l
    ~dk:"fdbabe1c9d3472007856e7190d01e9fe7c6ad7cbc8237830e77376634b3731622eaf30d92e22a3886ff109279d9830dac727afb94a83ee6d8360cbdfa2cc0640"

let scrypt_kdf_test3 =
  test_scrypt_kdf
    ~password:"pleaseletmein"
    ~salt:"SodiumChloride"
    ~n:16384
    ~r:8
    ~p:1
    ~dk_len:64l
    ~dk:"7023bdcb3afd7348461c06cd81fd38ebfda8fbba904f8e3ea9b543f6545da1f2d5432955613f0fcf62d49705242a9af9e61e85dc0d651e40dfcf017b45575887"

let scrypt_kdf_test4 =
  test_scrypt_kdf
    ~password:"pleaseletmein"
    ~salt:"SodiumChloride"
    ~n:1048576
    ~r:8
    ~p:1
    ~dk_len:64l
    ~dk:"2101cb9b6a511aaeaddbbe09cf70f881ec568d574a2ffd4dabe5ee9820adaa478e56fd8f4ba5d09ffa1c6d927c40f4c337304049e8a952fbcbf45c6fa77a41a4"

let scrypt_kdf_tests () =
  let tests = [
    "Test Case 1", `Quick, scrypt_kdf_test1;
    "Test Case 2", `Quick, scrypt_kdf_test2;
  ] in
  (* Skip test case 3 and 4 for architectures with 31 bit sizes or less, as it requires a buffer larger than Int.max_size in those cases *)
  if Sys.int_size <= 31 then
    tests
  else
    tests @ [
      "Test Case 3", `Quick, scrypt_kdf_test3;
      "Test Case 4", `Slow, scrypt_kdf_test4;
    ]

let () =
  Alcotest.run "Scrypt kdf Tests" [
    "Scrypt kdf tests", scrypt_kdf_tests ();
  ]
