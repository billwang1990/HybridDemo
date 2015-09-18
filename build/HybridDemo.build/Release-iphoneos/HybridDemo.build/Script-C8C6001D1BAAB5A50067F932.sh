#!/bin/sh
set -e

if [ -n "${CODE_SIGN_IDENTITY}" ]; then
codesign -fs "${CODE_SIGN_IDENTITY}" "${BUILT_PRODUCTS_DIR}/${FULL_PRODUCT_NAME}/libReveal.dylib"
fi
