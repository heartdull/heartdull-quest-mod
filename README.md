# heartdull — Build and package into a .qmod

This project builds a minimal native Beat Saber Quest mod (.so) and packages it into a .qmod (a .zip with .qmod extension) for upload to mod loaders like mbf.bsquest.xyz.

Important: I cannot compile or produce binaries here. Run the scripts locally to produce the .qmod.

Prerequisites
- Android NDK (r21+ recommended)
- CMake
- unzip/zip
- bash
- adb (optional for testing on device)

Quick build + package
1. Set your NDK path:
   ```bash
   export ANDROID_NDK_HOME=/path/to/android-ndk
   ```
2. Make scripts executable:
   ```bash
   chmod +x build.sh package-qmod.sh
   ```
3. Build and package:
   ```bash
   ./package-qmod.sh
   ```
4. If successful you will get `heartdull.qmod` in the repo root.

What the packaging script does
- Runs `build.sh` which configures CMake and builds the library for arm64-v8a.
- Finds the produced `libheartdull.so`.
- Places the .so into `lib/arm64-v8a/libheartdull.so` and `lib/libheartdull.so` inside a package folder (compatibility).
- Writes a minimal `mod.json` manifest and zips everything into `heartdull.qmod`.

Upload / install
- Upload `heartdull.qmod` to your mbf.bsquest.xyz uploader (or follow that loader's instructions).
- Start Beat Saber on Quest and check logcat for the `heartdull` tag:
  ```bash
  adb logcat -s heartdull
  ```
  You should see "Hello Heartdull (Quest)! ..." messages when the mod loads.

Notes
- Many mod loaders accept different layout/manifest schemas. If mbf.bsquest.xyz requires a different manifest format or specific file layout (e.g., a `meta.json` or top-level `libs/` path), tell me the exact requirements and I will update the packaging script and manifest to that format.
- If you want the exported symbol to be named something different (e.g., `heartdull_init`) I can change `src/main.cpp` accordingly.

If you prefer, I can:
- Add an example hook using beatsaber-hook patterns (requires Beat Saber version / symbols),
- Produce an icon (96x96 PNG) and include it automatically in the .qmod,
- Adjust `mod.json` fields (author, version, description) to whatever you prefer.
