TARGET=ramips
TARGET_TYPE=mt7620
ARCH=mipsel_24kc
ARCH_BUILDROOT=$(ARCH)_musl-1.1.16


all: \
	imagebuilder \
	GLMT300 \
	GLMT750 \
	install_zip

GLMT300: \
	openwrt-$(OPENWRT_VERSION)-$(TARGET)-$(TARGET_TYPE)-gl-mt300a-squashfs-sysupgrade.bin \
	openwrt-$(OPENWRT_VERSION)-$(TARGET)-$(TARGET_TYPE)-gl-mt300n-squashfs-sysupgrade.bin

GLMT750: \
	openwrt-$(OPENWRT_VERSION)-$(TARGET)-$(TARGET_TYPE)-gl-mt750-squashfs-sysupgrade.bin
