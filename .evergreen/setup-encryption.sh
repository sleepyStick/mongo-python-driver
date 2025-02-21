#!/bin/bash
set -o errexit  # Exit the script with error if any of the commands fail
set -o xtrace

if [ -z "${DRIVERS_TOOLS}" ]; then
    echo "Missing environment variable DRIVERS_TOOLS"
    exit 1
fi

TARGET=""

if [ "Windows_NT" = "${OS:-''}" ]; then # Magic variable in cygwin
    # PYTHON-2808 Ensure this machine has the CA cert for google KMS.
    powershell.exe "Invoke-WebRequest -URI https://oauth2.googleapis.com/" > /dev/null || true
    TARGET="windows-test"
fi

if [ "$(uname -s)" = "Darwin" ]; then
    TARGET="macos"
fi

if [ "$(uname -s)" = "Linux" ]; then
    rhel_ver=$(awk -F'=' '/VERSION_ID/{ gsub(/"/,""); print $2}' /etc/os-release)
    arch=$(uname -m)
    echo "RHEL $rhel_ver $arch"
    if [[ $rhel_ver =~ 7 ]]; then
        TARGET="rhel-70-64-bit"
    elif [[ $rhel_ver =~ 8 ]]; then
        if [ "$arch" = "x86_64" ]; then
            TARGET="rhel-80-64-bit"
        elif [ "$arch" = "arm" ]; then
            TARGET="rhel-82-arm64"
        fi
    fi
fi

if [ -z "$LIBMONGOCRYPT_URL" ] && [ -n "$TARGET" ]; then
    LIBMONGOCRYPT_URL="https://s3.amazonaws.com/mciuploads/libmongocrypt/$TARGET/master/latest/libmongocrypt.tar.gz"
fi

if [ -z "$LIBMONGOCRYPT_URL" ]; then
    echo "Cannot test client side encryption without LIBMONGOCRYPT_URL!"
    exit 1
fi
rm -rf libmongocrypt libmongocrypt.tar.gz
echo "Fetching $LIBMONGOCRYPT_URL..."
curl -O "$LIBMONGOCRYPT_URL"
echo "Fetching $LIBMONGOCRYPT_URL...done"
mkdir libmongocrypt
tar xzf libmongocrypt.tar.gz -C ./libmongocrypt
ls -la libmongocrypt
ls -la libmongocrypt/nocrypto

if [ -z "${SKIP_SERVERS:-}" ]; then
    PYTHON_BINARY_OLD=${PYTHON_BINARY}
    export PYTHON_BINARY=""
    bash "${DRIVERS_TOOLS}"/.evergreen/csfle/setup-secrets.sh
    export PYTHON_BINARY=$PYTHON_BINARY_OLD
    bash "${DRIVERS_TOOLS}"/.evergreen/csfle/start-servers.sh
fi
