LOCAL_PATH:= $(call my-dir)

COMMON_CFLAGS := \
	-DLOG_TAG=\"libEGL_swiftshader\" \
	-std=c++11 \
	-DEGLAPI= \
	-DEGL_EGLEXT_PROTOTYPES \
	-Wno-unused-parameter \
	-Wno-implicit-exception-spec-mismatch \
	-Wno-overloaded-virtual

ifneq (16,${PLATFORM_SDK_VERSION})
COMMON_CFLAGS += -Xclang -fuse-init-array
else
COMMON_CFLAGS += -D__STDC_INT64__
endif

COMMON_SRC_FILES := \
	Config.cpp \
	Display.cpp \
	Surface.cpp \
	libEGL.cpp \
	main.cpp

COMMON_C_INCLUDES := \
	bionic \
	$(LOCAL_PATH)/../../../include \
	$(LOCAL_PATH)/../ \
	$(LOCAL_PATH)/../../

COMMON_STATIC_LIBRARIES := \
	libLLVM_swiftshader

COMMON_SHARED_LIBRARIES := \
	libdl \
	liblog \
	libcutils \
	libhardware

# Marshmallow does not have stlport, but comes with libc++ by default
ifeq ($(shell test $(PLATFORM_SDK_VERSION) -lt 23 && echo PreMarshmallow),PreMarshmallow)
COMMON_SHARED_LIBRARIES += libstlport
COMMON_C_INCLUDES += external/stlport/stlport
endif

COMMON_LDFLAGS := \
	-Wl,--version-script=$(LOCAL_PATH)/exports.map \
	-Wl,--hash-style=sysv

include $(CLEAR_VARS)
ifdef TARGET_2ND_ARCH
LOCAL_MODULE_PATH_64 := vendor/transgaming/swiftshader/$(TARGET_ARCH)/debug/obj
LOCAL_UNSTRIPPED_PATH_64 := vendor/transgaming/swiftshader/$(TARGET_ARCH)/debug/sym
LOCAL_MODULE_PATH_32 := vendor/transgaming/swiftshader/$(TARGET_2ND_ARCH)/debug/obj
LOCAL_UNSTRIPPED_PATH_32 := vendor/transgaming/swiftshader/$(TARGET_2ND_ARCH)/debug/sym
else
LOCAL_MODULE_PATH := vendor/transgaming/swiftshader/$(TARGET_ARCH)/debug/obj
LOCAL_UNSTRIPPED_PATH := vendor/transgaming/swiftshader/$(TARGET_ARCH)/debug/sym
endif
LOCAL_MODULE := libEGL_swiftshader_vendor_debug
LOCAL_MODULE_TAGS := optional
LOCAL_INSTALLED_MODULE_STEM := libEGL_swiftshader.so
LOCAL_CFLAGS += $(COMMON_CFLAGS) -UNDEBUG -g -O0
LOCAL_CLANG := true
LOCAL_SRC_FILES := $(COMMON_SRC_FILES)
LOCAL_C_INCLUDES += $(COMMON_C_INCLUDES)
LOCAL_STATIC_LIBRARIES += swiftshader_top_debug $(COMMON_STATIC_LIBRARIES)
LOCAL_SHARED_LIBRARIES += $(COMMON_SHARED_LIBRARIES)
LOCAL_LDFLAGS += $(COMMON_LDFLAGS)
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
ifdef TARGET_2ND_ARCH
LOCAL_MODULE_PATH_64 := vendor/transgaming/swiftshader/$(TARGET_ARCH)/release/obj
LOCAL_UNSTRIPPED_PATH_64 := vendor/transgaming/swiftshader/$(TARGET_ARCH)/release/sym
LOCAL_MODULE_PATH_32 := vendor/transgaming/swiftshader/$(TARGET_2ND_ARCH)/release/obj
LOCAL_UNSTRIPPED_PATH_32 := vendor/transgaming/swiftshader/$(TARGET_2ND_ARCH)/release/sym
else
LOCAL_MODULE_PATH := vendor/transgaming/swiftshader/$(TARGET_ARCH)/release/obj
LOCAL_UNSTRIPPED_PATH := vendor/transgaming/swiftshader/$(TARGET_ARCH)/release/sym
endif
LOCAL_MODULE := libEGL_swiftshader_vendor_release
LOCAL_MODULE_TAGS := optional
LOCAL_INSTALLED_MODULE_STEM := libEGL_swiftshader.so
LOCAL_CFLAGS += $(COMMON_CFLAGS) -DANGLE_DISABLE_TRACE
LOCAL_CLANG := true
LOCAL_SRC_FILES := $(COMMON_SRC_FILES)
LOCAL_C_INCLUDES += $(COMMON_C_INCLUDES)
LOCAL_STATIC_LIBRARIES += swiftshader_top_release $(COMMON_STATIC_LIBRARIES)
LOCAL_SHARED_LIBRARIES += $(COMMON_SHARED_LIBRARIES)
LOCAL_LDFLAGS += $(COMMON_LDFLAGS)
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libEGL_swiftshader
ifdef TARGET_2ND_ARCH
LOCAL_MODULE_PATH_32 := $(TARGET_OUT_VENDOR)/lib/egl
LOCAL_MODULE_PATH_64 := $(TARGET_OUT_VENDOR)/lib64/egl
else
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/lib/egl
endif
LOCAL_MODULE_TAGS := optional
LOCAL_CLANG := true
LOCAL_SRC_FILES := $(COMMON_SRC_FILES)
LOCAL_C_INCLUDES += $(COMMON_C_INCLUDES)
LOCAL_STATIC_LIBRARIES += swiftshader_top_$(SWIFTSHADER_OPTIM) $(COMMON_STATIC_LIBRARIES)
LOCAL_SHARED_LIBRARIES += $(COMMON_SHARED_LIBRARIES)
LOCAL_LDFLAGS += $(COMMON_LDFLAGS)
ifeq (debug,$(SWIFTSHADER_OPTIM))
LOCAL_CFLAGS += $(COMMON_CFLAGS) -UNDEBUG -g -O0
else
LOCAL_CFLAGS += $(COMMON_CFLAGS) -DANGLE_DISABLE_TRACE
endif
include $(BUILD_SHARED_LIBRARY)
