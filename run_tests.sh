if [ -f ./scrypt_kdf_tests.native ]; then
    ./scrypt_kdf_tests.native -v
else
    ./scrypt_kdf_tests.byte -v
fi
