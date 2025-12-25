#!/usr/bin/env bash
set -euo pipefail

# Package the built library into a .qmod (zip renamed).
# Usage: ./package-qmod.sh
# Requires build.sh to produce the .so (or you can place the .so manually into ./built-so/libheartdull.so)

QMOD_NAME="heartdull.qmod"
PKG_DIR="pkg"
ABI_DIR="arm64-v8a"  # architecture we package for by default

# 1) Build
./build.sh

# 2) Locate built .so
# Prefer the copied predictable path, then search build/
SO_CANDIDATES=()
if [ -f "build-libheartdull.so" ]; then
  SO_CANDIDATES+=("build-libheartdull.so")
fi
while IFS= read -r -d $'\0' f; do
  SO_CANDIDATES+=("$f")
done < <(find build -type f -name "libheartdull.so" -print0 || true)

if [ "${#SO_CANDIDATES[@]}" -eq 0 ]; then
  echo "Error: no libheartdull.so found. Build may have failed. Expected a .so under build/."
  exit 1
fi

# Prefer candidate that contains the ABI name if present
SO_PATH="${SO_CANDIDATES[0]}"
for c in "${SO_CANDIDATES[@]}"; do
  case "$c" in
    *"$ABI_DIR"*) SO_PATH="$c"; break ;;
  esac
done

echo "Using .so: $SO_PATH"

# 3) Prepare package layout
rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR/lib/$ABI_DIR"
mkdir -p "$PKG_DIR/lib"  # also include generic path for compatibility

# copy the .so into both locations (some loaders expect one or the other)
cp "$SO_PATH" "$PKG_DIR/lib/$ABI_DIR/libheartdull.so"
cp "$SO_PATH" "$PKG_DIR/lib/libheartdull.so"

# 4) Add mod manifest (mod.json)
cat > "$PKG_DIR/mod.json" <<'JSON'
{
  "id": "heartdull",
  "name": "heartdull",
  "version": "1.0.0",
  "author": "assholebee",
  "description": "Barebones Heartdull native plugin for Beat Saber (Quest).",
  "game": "Beat Saber",
  "platform": "quest",
  "entry": "lib/libheartdull.so",
  "abi": "arm64-v8a"
}
JSON

# Optional: copy icon if exists
if [ -f "icon.png" ]; then
  cp icon.png "$PKG_DIR/icon.png"
fi

# 5) Zip and rename to .qmod
TMP_ZIP="heartdull.zip"
pushd "$PKG_DIR" >/dev/null
zip -r "../$TMP_ZIP" ./*
popd >/dev/null
mv "$TMP_ZIP" "$QMOD_NAME"
rm -rf "$PKG_DIR"

echo "Created $QMOD_NAME. Upload that file to your mbf.bsquest.xyz mod uploader or place it in your loader's mods folder."
