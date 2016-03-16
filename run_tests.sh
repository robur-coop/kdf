if [ -f ./salsa20_core_tests.native ]; then
    ./salsa20_core_tests.native -v
else
    ./salsa20_core_tests.byte -v
fi
if [ -f ./scrypt_kdf_tests.native ]; then
    ./scrypt_kdf_tests.native -v
else
    ./scrypt_kdf_tests.byte -v
fi
