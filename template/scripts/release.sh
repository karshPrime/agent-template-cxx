#!/usr/bin/env bash
# Cross-compiles one binary per release target into dist/, using zig.
# Usage: scripts/release.sh <name> "<target...>" <cc|c++> <compiler argument...>

set -euo pipefail
cd "$(dirname "$0")/.."

zig_target() {
    case "$1" in
        windows-arm64)       echo "aarch64-windows-gnu" ;;
        windows-x86)         echo "x86-windows-gnu" ;;
        windows-x64)         echo "x86_64-windows-gnu" ;;
        linux-arm32)         echo "arm-linux-musleabihf" ;;
        linux-arm64)         echo "aarch64-linux-musl" ;;
        linux-x86)           echo "x86-linux-musl" ;;
        linux-x64)           echo "x86_64-linux-musl" ;;
        macOS-intel)         echo "x86_64-macos" ;;
        macOS-apple-silicon) echo "aarch64-macos" ;;
        *) echo "Unknown release target: $1" >&2; return 1 ;;
    esac
}

name="$1"
targets="$2"
compiler="$3"
shift 3

rm -rf dist
mkdir -p dist
for target in $targets; do
    triple="$(zig_target "$target")"
    suffix=""
    if [[ "$target" == windows-* ]]; then
        suffix=".exe"
    fi
    echo "Building $target"
    # Linux builds link musl statically, so they run on any distribution
    zig "$compiler" -target "$triple" "$@" -o "dist/$name-$target$suffix"
done
