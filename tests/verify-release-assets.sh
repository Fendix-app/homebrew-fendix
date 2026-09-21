#!/bin/sh
set -eu
umask 077

VERSION=v3.4.1
BASE="https://github.com/Fendix-app/Fendix/releases/download/${VERSION}"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT INT TERM

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

verify_asset() {
  platform=$1
  expected=$2
  asset="fendix-${VERSION}-${platform}"

  curl --proto '=https' --tlsv1.2 -fsSL -o "${TMP_DIR}/${asset}" "${BASE}/${asset}"
  curl --proto '=https' --tlsv1.2 -fsSL -o "${TMP_DIR}/${asset}.sha256" "${BASE}/${asset}.sha256"

  published=$(awk '{print $1}' "${TMP_DIR}/${asset}.sha256")
  actual=$(sha256_file "${TMP_DIR}/${asset}")

  [ "$published" = "$expected" ] || {
    echo "${asset}: release sidecar does not match the reviewed formula" >&2
    exit 1
  }
  [ "$actual" = "$expected" ] || {
    echo "${asset}: downloaded bytes do not match the reviewed formula" >&2
    exit 1
  }

  echo "${asset}: ${actual}"
}

verify_asset darwin-amd64 4540178a1a25609403bbc9cf326c097f4d404a56cf32a15dd092f011b96c84bb
verify_asset darwin-arm64 8813891266600867465cae1fc60a1934768452d7c19354615c74d83e12e4eecd
verify_asset linux-amd64 668b07d69ed0b9a2e30416dff75a77b203e6adb0b550b3e6cb6d8f8a2416a767
verify_asset linux-arm64 85930244fc3af97870853f14d104164fdc52b61acf67d033ce643c8595278489
