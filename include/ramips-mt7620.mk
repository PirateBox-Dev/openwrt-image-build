## Build rules for ar71xx-generic

TARGET=ramips
TARGET_TYPE=mt7620
ARCH=mipsel_24kc
ARCH_BUILDROOT=$(ARCH)_musl-1.1.16


all: \
	imagebuilder \
	GLMT300 \
	install_zip

GLMT300: \
	lede-$(LEDE_VERSION)-$(TARGET)-$(TARGET_TYPE)-gl-mt300a-squashfs-sysupgrade.bin \
	lede-$(LEDE_VERSION)-$(TARGET)-$(TARGET_TYPE)-gl-mt300n-squashfs-sysupgrade.bin

GLMT70: \
	lede-$(LEDE_VERSION)-$(TARGET)-$(TARGET_TYPE)-gl-mt750-squashfs-sysupgrade.bin
