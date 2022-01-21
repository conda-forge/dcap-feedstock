#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

sh bootstrap.sh

./configure \
    --prefix="${PREFIX}" \
    --with-globus-lib="${PREFIX}/lib" \
    --with-globus-include="${PREFIX}/include" \
    --with-krb5-gssapi-include="${PREFIX}/include"

if [ "$(uname)" == "Darwin" ]; then
    sed -i 's/notelnet="0"/notelnet="1"/g' configure
fi

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi
make install
make installcheck
