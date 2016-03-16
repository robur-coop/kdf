let scrypt_block_mix b r =
  let b' = Cstruct.create (Cstruct.len b)
  and x = ref (Cstruct.sub b ((2 * r - 1) * 64) 64) in
  for i = 0 to 2 * r - 1 do
    let b_i = Cstruct.sub b (i * 64) 64 in
    Nocrypto.Uncommon.Cs.xor_into !x b_i 64;
    x := Salsa20_core.salsa20_8_core b_i;
    let offset = ((i mod 2) lsl (r - 1)) + i / 2 in
    Cstruct.blit !x 0 b' (offset * 64) 64
  done;
  b'
