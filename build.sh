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

popd >/dev/null

echo "Build finished. Output .so should be in ${BUILD_DIR}/libheartdull.so or under ${BUILD_DIR}/CMakeFiles/heartdull.dir/"
