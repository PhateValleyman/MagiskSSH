ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(ROOT_DIR)/helpers.mk

BUILD_DIR?=.
BUILD_DIR_ROOT:=$(shell realpath $(BUILD_DIR))
VERSION:=$(shell grep '^version=' $(ROOT_DIR)/module_data/module.prop | sed 's/^version=//')


override NO_GLOBAL:=true

# $(1): ANDROID_ARCH (ie. arm64)          -- how android distinguishes architectures
# $(2): TRIPLET_ARCH (ie. aarch64)        -- the architecture as used in the architecture triplet
# $(3): ANDROID_MARCH (ie. armv8-a)       -- an actual 'version' of an arch. Passed to -march
# $(4): CROSS (ie. aarch64-linux-android) -- the full architecture triplet
define single-arch

BUILD_DIR=$(BUILD_DIR_ROOT)/$(1)
ANDROID_ARCH:=arm
TRIPLET_ARCH:=armv4
ANDROID_MARCH:=armv7-a
CROSS:=$(4)
PHONY_TARGET_PREFIX:=_$(1)
CFLAGS:=
LDFLAGS:=

$(call submk,main.mk)
endef

.DEFAULT_GOAL := module


.PHONY: copy
copy: copy_arm

.PHONY: all
all: all_arm

$(eval $(call single-arch,arm,arm,armv7-a,armv7a-linux-androideabi,armv4))

#reset paths
BUILD_DIR:=$(BUILD_DIR_ROOT)
$(eval $(call submk,magisk_module.mk))
