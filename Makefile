TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Current

Current_FILES = $(wildcard *.xm *.m)
$(TWEAK_NAME)_LIBRARIES = colorpicker
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei
Current_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += currentprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
