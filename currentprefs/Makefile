TARGET := iphone:clang:latest:7.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = currentprefs

currentprefs_FILES = $(wildcard *.m)
currentprefs_FRAMEWORKS = UIKit
digitalclockprefs_LIBRARIES = colorpicker
currentprefs_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
currentprefs_INSTALL_PATH = /Library/PreferenceBundles
currentprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
