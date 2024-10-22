module type S = sig
  val pbkdf1 : password:string -> salt:string -> count:int -> dk_len:int -> string
  val pbkdf2 : password:string -> salt:string -> count:int -> dk_len:int32 -> string
end

let cdiv x y =
  (* This is lifted from Nocrypto.Uncommon.(//)
     (formerly known as [cdiv]). It is part of the documented, publically
     exposed _internal_ utility library not for public consumption, hence
     the API break that prompted this copy-pasted function. *)
  if y < 1 then raise Division_by_zero else
    if x > 0 then 1 + ((x - 1) / y) else 0 [@@inline]

module Make (H: Digestif.S) : S = struct
  let pbkdf1 ~password ~salt ~count ~dk_len =
    if String.length salt <> 8 then invalid_arg "salt should be 8 bytes"
    else if count <= 0 then invalid_arg "count must be a positive integer"
    else if dk_len <= 0 then invalid_arg "derived key length must be a positive integer"
    else if dk_len > H.digest_size then invalid_arg "derived key too long"
    else
      let rec loop t = function
          0 -> t
        | i -> loop H.(to_raw_string (digest_string t)) (i - 1)
      in
      String.sub (loop (password ^ salt) count) 0 dk_len

  let pbkdf2 ~password ~salt ~count ~dk_len =
    if count <= 0 then invalid_arg "count must be a positive integer"
    else if dk_len <= 0l then invalid_arg "derived key length must be a positive integer"
    else
      let h_len = H.digest_size
      and dk_len = Int32.to_int dk_len in
      let l = cdiv dk_len h_len in
      let r = dk_len - (l - 1) * h_len in
      let block i =
        let rec f u xor = function
          | 0 -> xor
          | j ->
            let u = H.(to_raw_string (hmac_string ~key:password u)) in
            f u (Mirage_crypto.Uncommon.xor xor u) (j - 1)
        in
        let int_i = Bytes.create 4 in
        Bytes.set_int32_be int_i 0 (Int32.of_int i);
        let u_1 = H.hmac_string ~key:password (salt ^ Bytes.unsafe_to_string int_i) in
        let u_1 = H.to_raw_string u_1 in
        f u_1 u_1 (count - 1)
      in
      let rec loop blocks = function
        | 0 -> blocks
        | i -> loop (block i :: blocks) (i - 1)
      in
      String.concat "" (loop [String.sub (block l) 0 r] (l - 1))
end

let pbkdf1 ~hash ~password ~salt ~count ~dk_len =
  let module H = (val (Digestif.module_of_hash' hash)) in
  let module PBKDF = Make (H) in
  PBKDF.pbkdf1 ~password ~salt ~count ~dk_len

let pbkdf2 ~prf ~password ~salt ~count ~dk_len =
  let module H = (val (Digestif.module_of_hash' prf)) in
  let module PBKDF = Make (H) in
  PBKDF.pbkdf2 ~password ~salt ~count ~dk_len
