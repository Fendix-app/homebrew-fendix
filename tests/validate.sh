#!/bin/sh
set -eu

ROOT=$(cd -- "$(dirname -- "$0")/.." && pwd)
cd "$ROOT"

sh -n install.sh
ruby -c Formula/fendix.rb

grep -F 'brew tap Fendix-app/fendix' README.md >/dev/null
grep -F 'github.com/Fendix-app/Fendix/releases/download/' Formula/fendix.rb >/dev/null
# shellcheck disable=SC2016 # Match the literal shell assignment in install.sh.
grep -F 'REPO="${FENDIX_REPO:-Fendix-app/Fendix}"' install.sh >/dev/null
grep -F '<meta name="robots" content="noindex,follow">' index.html >/dev/null
grep -F '<link rel="canonical" href="https://www.fendix.dev/docs/getting-started">' index.html >/dev/null

if grep -Eiq 'ghcr\.io/abdel-rahmansaied|github\.com/Abdel-RahmanSaied/homebrew-fendix/releases|brew tap Abdel-RahmanSaied/fendix' Formula/fendix.rb install.sh index.html; then
  echo "current distribution files contain a retired installation path" >&2
  exit 1
fi

echo "distribution contract checks passed"
