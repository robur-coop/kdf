let salsa_core count i =
  let len = 64 in
  if Cstruct.len i <> len then invalid_arg "input must be 16 blocks of 32 bits"
  else
    let combine y0 y1 y2 shift =
      let r a b =
        let rs = 32 - b in
        let open Nocrypto.Numeric.Int32 in (a lsl b) lor (a lsr rs) in
      let open Nocrypto.Numeric.Int32 in (r (y1 + y2) shift) lxor y0
    and x = Array.init 16 (fun j -> Cstruct.LE.get_uint32 i (j * 4)) in
    let quarterround y0 y1 y2 y3 =
      x.(y1) <- combine x.(y1) x.(y0) x.(y3) 7;
      x.(y2) <- combine x.(y2) x.(y1) x.(y0) 9;
      x.(y3) <- combine x.(y3) x.(y2) x.(y1) 13;
      x.(y0) <- combine x.(y0) x.(y3) x.(y2) 18 in
    for _ = 1 to count do
      quarterround 0 4 8 12;
      quarterround 5 9 13 1;
      quarterround 10 14 2 6;
      quarterround 15 3 7 11;

      quarterround 0 1 2 3;
      quarterround 5 6 7 4;
      quarterround 10 11 8 9;
      quarterround 15 12 13 14;
    done;
    let o = Cstruct.create len in
    for j = 0 to 15 do
      let xj = x.(j)
      and ij = Cstruct.LE.get_uint32 i (j * 4) in
      let open Nocrypto.Numeric.Int32 in
      Cstruct.LE.set_uint32 o (j * 4) (xj + ij)
    done;
    o

let salsa20_8_core i =
  salsa_core 4 i

let salsa20_12_core i =
  salsa_core 6 i

let salsa20_20_core i =
  salsa_core 10 i
