let scrypt_block_mix b r =
  let b' = Cstruct.create (Cstruct.len b)
  and x = ref (Cstruct.sub b ((2 * r - 1) * 64) 64) in
  for i = 0 to 2 * r - 1 do
    let b_i = Cstruct.sub b (i * 64) 64 in
    Nocrypto.Uncommon.Cs.xor_into !x b_i 64;
    x := Salsa20_core.salsa20_8_core b_i;
    let offset = (i mod 2) lsl (max 0 (r / 2 - 1)) + i / 2 in
    Cstruct.blit !x 0 b' (offset * 64) 64
  done;
  b'

let scrypt_ro_mix b ~r ~n =
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

let scrypt_kdf ~password ~salt ~n ~r ~p ~dk_len =
  let is_power_of_2 x = (x land (x - 1)) = 0 in
  if n <= 1 then invalid_arg "n must be larger than 1"
  else if not (is_power_of_2 n) then invalid_arg "n must be a power of 2"
  else if p <= 0 then invalid_arg "p must be a positive integer"
  else if p > (Int64.to_int (Int64.div 0xffffffffL 4L) / r) then invalid_arg "p too big"
  else if dk_len <= 0l then invalid_arg "derived key length must be a positive integer";
  let b_len = 128 * r * p in
  let rec divide_into_blocks b blocks = function
      0 -> blocks
    | i -> let off = (i - 1) * r * 128 in
           divide_into_blocks b ((Cstruct.sub b off (r * 128))::blocks) (i - 1) in
  let dk = Pbkdf.pbkdf2 ~prf:`SHA256 ~password ~salt ~count:1 ~dk_len:(Int32.of_int b_len) in
  let b = divide_into_blocks dk [] p in
  let b' = List.map (scrypt_ro_mix ~r ~n) b in
  let salt = Cstruct.concat b' in
  Pbkdf.pbkdf2 ~prf:`SHA256 ~password ~salt ~count:1 ~dk_len
