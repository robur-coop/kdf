external salsa_core : int -> string -> bytes -> unit = "caml_salsa_core" [@@noalloc]

let salsa20_core count i =
  let l = 64 in
  if String.length i <> l then invalid_arg "input must be 16 blocks of 32 bits"
  else
    let o = Bytes.create l in
    salsa_core count i o;
    Bytes.unsafe_to_string o

let salsa20_8_core i =
  salsa20_core 4 i

let scrypt_block_mix b r =
  let b' = Bytes.create (String.length b) in
  let x = Bytes.create 64 in
  Bytes.unsafe_blit_string b ((2 * r - 1) * 64) x 0 64;
  for i = 0 to 2 * r - 1 do
    let b_i = Bytes.unsafe_of_string (String.sub b (i * 64) 64) in
    Mirage_crypto.Uncommon.unsafe_xor_into (Bytes.unsafe_to_string x) ~src_off:0 b_i ~dst_off:0 64;
    Bytes.unsafe_blit_string (salsa20_8_core (Bytes.unsafe_to_string b_i)) 0 x 0 64;
    let offset = (i mod 2) lsl (max 0 (r / 2 - 1)) + i / 2 in
    Bytes.blit x 0 b' (offset * 64) 64
  done;
  b'

let scrypt_ro_mix b ~r ~n =
  let blen = r * 128 in
  let x = ref (Bytes.copy b) in
  let v = Bytes.create (blen * n) in
  for i = 0 to n - 1 do
    Bytes.unsafe_blit !x 0 v (blen * i) blen;
    x := scrypt_block_mix (Bytes.unsafe_to_string !x) r
  done;
  for _ = 0 to n - 1 do
    let integerify x =
      let k = Bytes.get_int32_le x (128 * r - 64) in
      let n' = n - 1 in
      Int32.(to_int (logand k (of_int n')))
    in
    let j = integerify !x in
    Mirage_crypto.Uncommon.unsafe_xor_into (Bytes.unsafe_to_string v) ~src_off:(blen * j) !x ~dst_off:0 blen;
    x := scrypt_block_mix (Bytes.unsafe_to_string !x) r;
  done;
  !x

let scrypt ~password ~salt ~n ~r ~p ~dk_len =
  let is_power_of_2 x = (x land (x - 1)) = 0 in
  if n <= 1 then invalid_arg "n must be larger than 1"
  else if not (is_power_of_2 n) then invalid_arg "n must be a power of 2"
  else if p <= 0 then invalid_arg "p must be a positive integer"
  else if p > (Int64.to_int (Int64.div 0xffffffffL 4L) / r) then invalid_arg "p too big"
  else if dk_len <= 0l then invalid_arg "derived key length must be a positive integer";
  let rec partition b blocks = function
    | 0 -> blocks
    | i ->
      let off = (i - 1) * r * 128 in
      let block = Bytes.unsafe_of_string (String.sub b off (r * 128)) in
      partition b (block :: blocks) (i - 1)
  in
  let blen = Int32.of_int (128 * r * p) in
  let dk = Pbkdf.pbkdf2 ~prf:`SHA256 ~password ~salt ~count:1 ~dk_len:blen in
  let b = partition dk [] p in
  let b' = List.map (scrypt_ro_mix ~r ~n) b in
  let salt = String.concat "" (List.map Bytes.unsafe_to_string b') in
  Pbkdf.pbkdf2 ~prf:`SHA256 ~password ~salt ~count:1 ~dk_len
