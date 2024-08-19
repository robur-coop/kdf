(** {{:https://tools.ietf.org/html/rfc7914}
    The scrypt Password-Based Key Derivation Function}
    specifies the password-based key derivation function scrypt. The
    function derives one or more secret keys from a secret string.
    It is based on memory-hard functions which offer added protection
    against attacks using custom hardware. *)

(** [scrypt_kdf password salt n r p dk_len] is [dk], the derived key
    of [dk_len] octets.
    [n], the cost parameter, must be larger than 1 and a power of 2.
    [p], the parallelization parameter, must be a possitive integer
    and less than or equal to 2^32 - 1 / (4 * r)
    @raise Invalid_argument when either [n], [p] or [dk_len] are not
    valid *)
val scrypt : password:string -> salt:string -> n:int -> r:int -> p:int -> dk_len:int32 -> string
