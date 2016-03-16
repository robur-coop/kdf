let scrypt_block_mix i r =
  let o = Cstruct.create (Cstruct.len i)
  and x = ref (Cstruct.sub i ((2 * r - 1) * 64) 64) in
  for j = 0 to 2 * r - 1 do
    let b_i = Cstruct.sub i (j * 64) 64 in
    Nocrypto.Uncommon.Cs.xor_into !x b_i 64;
    x := Salsa20_core.salsa20_8_core b_i;
    let offset = ((j mod 2) lsl (r - 1)) + j / 2 in
    Cstruct.blit !x 0 o (offset * 64) 64
  done;
  o
