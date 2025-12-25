#!/usr/bin/env bash
set -euo pipefail

# Simple build script. Edit ANDROID_NDK_HOME or set ANDROID_NDK if not set in env.
: "${ANDROID_NDK_HOME:=${ANDROID_NDK:-}}"

if [ -z "$ANDROID_NDK_HOME" ]; then
  echo "Set ANDROID_NDK_HOME (or ANDROID_NDK) to your Android NDK path and re-run."
  exit 1
fi

BUILD_DIR=build
ABI=arm64-v8a
API=21

mkdir -p "$BUILD_DIR"
pushd "$BUILD_DIR" >/dev/null

cmake -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake" \
      -DANDROID_ABI="$ABI" \
      -DANDROID_PLATFORM="android-$API" \
      ..

cmake --build . -- -j$(nproc || echo 4)

# Try to copy the built .so to a predictable place
SO_SRC=""
# Common CMake outputs
if [ -f "libheartdull.so" ]; then
  SO_SRC="libheartdull.so"
else
  SO_SRC="$(find . -type f -name 'libheartdull.so' -print -quit || true)"
fi

if [ -n "$SO_SRC" ]; then
  cp "$SO_SRC" ../build-libheartdull.so
  echo "Copied built SO to ../build-libheartdull.so"
else
  echo "Warning: could not find libheartdull.so in build output."
fi

popd >/dev/null

echo "Build finished. Look for the library under build/ or the copied file build-libheartdull.so"
