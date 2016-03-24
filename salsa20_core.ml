let salsa_core count i =
  let len = 64 in
  if Cstruct.len i <> len then invalid_arg "input must be 16 blocks of 32 bits"
  else
    let r a b =
      let rs = 32 - b in
      let open Nocrypto.Numeric.Int32 in (a lsl b) lor (a lsr rs) in
    let x = Nocrypto.Uncommon.Cs.clone i in
    let combine y0 y1 y2 shift =
      let open Nocrypto.Numeric.Int32 in (r (y1 + y2) shift) lxor y0 in
    let quarterround y0 y1 y2 y3 =
      let a = ref (Cstruct.LE.get_uint32 x (y0 * 4))
      and b = ref (Cstruct.LE.get_uint32 x (y1 * 4))
      and c = ref (Cstruct.LE.get_uint32 x (y2 * 4))
      and d = ref (Cstruct.LE.get_uint32 x (y3 * 4)) in
      b := combine !b !a !d 7;
      c := combine !c !b !a 9;
      d := combine !d !c !b 13;
      a := combine !a !d !c 18;
      Cstruct.LE.set_uint32 x (y0 * 4) !a;
      Cstruct.LE.set_uint32 x (y1 * 4) !b;
      Cstruct.LE.set_uint32 x (y2 * 4) !c;
      Cstruct.LE.set_uint32 x (y3 * 4) !d in
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
