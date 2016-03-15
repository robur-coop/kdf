let test_salsa20_8_core ~input ~output =
  let open Nocrypto.Uncommon.Cs in
  let open Cstruct in
  let input = of_hex input
  and output = to_string (of_hex output) in
  (fun () -> Alcotest.check Alcotest.string "Salsa20/8 Core test" output (to_string (Salsa20_core.salsa20_8_core input)))

let salsa20_8_core_test1 =
  test_salsa20_8_core
    ~input:"7e879a214f3ec9867ca940e641718f26baee555b8c61c1b50df846116dcd3b1dee24f319df9b3d8514121e4b5ac5aa3276021d2909c74829edebc68db8b8c25e"
    ~output:"a41f859c6608cc993b81cacb020cef05044b2181a2fd337dfd7b1c6396682f29b4393168e3c9e6bcfe6bc5b7a06d96bae424cc102c91745c24ad673dc7618f81"

let salsa20_8_core_tests = [
  "Test Case 1", `Quick, salsa20_8_core_test1;
]

let () =
  Alcotest.run "Salsa20 Core Tests" [
    "Salsa20 8 Core tests", salsa20_8_core_tests;
  ]
