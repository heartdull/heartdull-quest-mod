# heartdull — Barebones Beat Saber Quest mod (native .so)

This repository is a minimal native plugin for Quest, renamed to "heartdull". It logs when it is loaded and is intended as a starting point for building Beat Saber Quest mods that run under a modloader (you mentioned mbf.bsquest.xyz).

Files
- `CMakeLists.txt` — Android/CMake build (builds libheartdull.so)
- `src/main.cpp` — logs on load (constructor, JNI_OnLoad, and `mod_init`)
- `build.sh` — convenience script to build the .so

Prerequisites
- Android NDK (r21+ recommended)
- CMake
- adb (Android platform-tools)
- Your modloader installed on the Quest (you said: mbf.bsquest.xyz)
- Developer/Sideloading mode enabled on the Quest

Build (example)
1. Set NDK path:
   ```bash
   export ANDROID_NDK_HOME=/path/to/android-ndk
   ```
2. Make the build script executable and run:
   ```bash
   chmod +x build.sh
   ./build.sh
   ```
3. The compiled library will be in `build/` (look for `libheartdull.so` or under `CMakeFiles/`).

Install with your modloader
- mbf.bsquest.xyz: use its mod upload UI or place the built .so into whatever mod folder the loader expects. Check the loader docs — many Quest mod managers accept a .zip or an .so placed in a "mods" directory or uploaded via web UI.
- Alternatively, you can push it directly with adb if your loader supports loading from a device path:
  ```bash
  adb push build/libheartdull.so /sdcard/ModFolder/  # adjust path per loader
  ```
- Restart Beat Saber / your modloader and/or reapply mods as required by the loader.

Test / Verify
- Watch logcat for the tag `heartdull`:
  ```bash
  adb logcat -s heartdull
  ```
  You should see one or more of:
  - "Hello Heartdull (Quest)! constructor called."
  - "Hello Heartdull (Quest)! JNI_OnLoad called."
  - "Hello Heartdull (Quest)! mod_init called."

Notes and next steps
- This is intentionally minimal and only demonstrates that a library loads.
- To build a functional mod you will typically:
  - Use hooking infrastructure (beatsaber-hook / libquesthook patterns) to intercept Unity/Beat Saber functions,
  - Generate and use wrappers for IL2CPP symbols if you need to call into managed code,
  - Add a mod manifest or packaging if mbf.bsquest.xyz expects a specific layout (I can package a .zip for that if you tell me the required structure).
- Modding multiplayer or distributing pirated content is unethical and may violate terms of service. Use at your own risk.

If you want, I can:
- Add a simple hook example (e.g., hook a Unity function or Beat Saber method) — tell me the Beat Saber version or provide symbol names.
- Package this as a zip/mod file tailored to mbf.bsquest.xyz if you tell me its expected mod structure.
