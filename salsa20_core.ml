let salsa_core count i =
  let len = 64 in
  if Cstruct.len i <> len then invalid_arg "input must be 16 blocks of 32 bits"
  else
    let r a b =
      let rs = 32 - b in
      let open Nocrypto.Numeric.Int32 in (a lsl b) lor (a lsr rs) in
    let clone cs =
      let l = Cstruct.len cs in
      let cs' = Cstruct.create l in
      Cstruct.blit cs 0 cs' 0 l;
      cs'
    in
    let x = clone i in
    let combine y0 y1 y2 shift =
      let a = Cstruct.LE.get_uint32 x (y0 * 4)
      and b = Cstruct.LE.get_uint32 x (y1 * 4)
      and c = Cstruct.LE.get_uint32 x (y2 * 4) in
      let open Nocrypto.Numeric.Int32 in
      let tmp = (r (b + c) shift) lxor a in
      Cstruct.LE.set_uint32 x (y0 * 4) tmp in
    let quarterround y0 y1 y2 y3 =
      combine y1 y0 y3 7;
      combine y2 y1 y0 9;
      combine y3 y2 y1 13;
      combine y0 y3 y2 18 in
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
      let xj = Cstruct.LE.get_uint32 x (j * 4) in
      let ij = Cstruct.LE.get_uint32 i (j * 4) in
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
