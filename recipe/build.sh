#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

sh bootstrap.sh

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" = "1" ]] && [[ "${target_platform}" = linux-* ]]; then
    sed -i 's@AC_FUNC_MALLOC@@' configure.ac
    sed -i 's@AC_FUNC_REALLOC@@' configure.ac
fi

./configure \
    --prefix="${PREFIX}" \
    --with-globus-lib="${PREFIX}/lib" \
    --with-globus-include="${PREFIX}/include" \
    --with-krb5-gssapi-include="${PREFIX}/include"

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
    make check
fi
make install
make installcheck
