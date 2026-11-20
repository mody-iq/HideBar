TARGET ?= iphone:clang:latest:14.0
ARCHS ?= arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HideBar

HideBar_FILES = Tweak.x
HideBar_CFLAGS = -fobjc-arc
HideBar_FRAMEWORKS = UIKit

include $(THEOS)/makefiles/tweak.mk
