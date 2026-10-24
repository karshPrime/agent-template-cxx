#!/usr/bin/env bash
# Checks the command-line interface of a built binary.
# Usage: tests/cli.sh <binary> <expected version>

set -uo pipefail

binary="$1"
version="$2"
name="$(basename "$binary")"
failures=0

fail() {
    echo "FAIL: $1" >&2
    failures=$((failures + 1))
}

[ "$("$binary" --version)" = "$name $version" ] || fail "--version prints \"$name $version\""
[ "$("$binary" -v)" = "$name $version" ] || fail "-v prints \"$name $version\""
grep -q '^Usage:' <<< "$("$binary" --help)" || fail "--help prints the usage"
grep -q '^Usage:' <<< "$("$binary")" || fail "no arguments prints the usage"
if "$binary" --no-such-option > /dev/null 2>&1; then
    fail "an unknown option exits non-zero"
fi

if [ "$failures" -ne 0 ]; then
    exit 1
fi
echo "cli: all checks passed"
