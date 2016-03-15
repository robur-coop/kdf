if [ -f ./salsa20_core_tests.native ]; then
    ./salsa20_core_tests.native -v
else
    ./salsa20_core_tests.byte -v
fi
if [ -f ./scrypt_tests.native ]; then
    ./scrypt_tests.native -v
else
    ./scrypt_tests.byte -v
fi
