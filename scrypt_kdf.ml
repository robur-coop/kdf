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

let scrypt_ro_mix b r n =
  (* TODO: Use nocrypto's clone once it's available *)
  let clone cs =
    let l = Cstruct.len cs in
    let cs' = Cstruct.create l in
    Cstruct.blit cs 0 cs' 0 l;
    cs'
  and blen = r * 128 in
  let x = ref (clone b)
  and v = Cstruct.create (blen * n) in
  for i = 0 to n - 1 do
    Cstruct.blit !x 0 v (blen * i) blen;
    x := scrypt_block_mix !x r
  done;
  for _ = 0 to n - 1 do
    let integerify x =
      let k = Cstruct.LE.get_uint32 x (128 * r - 64) in
      let n' = n - 1 in
      let open Nocrypto.Numeric.Int32 in
      to_int (k land (of_int n')) in
    let j = integerify !x in
    let v_j = Cstruct.sub v (blen * j) blen in
    Nocrypto.Uncommon.Cs.xor_into v_j !x blen;
    x := scrypt_block_mix !x r;
  done;
  !x
