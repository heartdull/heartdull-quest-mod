#include <jni.h>
#include <android/log.h>

#define LOG_TAG "heartdull"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

// Called if the library is loaded by the Java VM
jint JNI_OnLoad(JavaVM* vm, void* reserved) {
    (void)vm;
    (void)reserved;
    LOGI("Hello Heartdull (Quest)! JNI_OnLoad called.");
    return JNI_VERSION_1_6;
}

// Constructor runs when the .so is dlopen()'d (covers some loaders)
__attribute__((constructor)) static void on_load(void) {
    LOGI("Hello Heartdull (Quest)! constructor called.");
}

// Exported init function in case the loader calls a symbol directly
extern "C" void __attribute__((visibility("default"))) mod_init() {
    LOGI("Hello Heartdull (Quest)! mod_init called.");
}
