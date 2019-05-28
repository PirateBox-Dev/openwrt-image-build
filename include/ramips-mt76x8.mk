TARGET=ramips
TARGET_TYPE=mt76x8
ARCH=mipsel_24kc
ARCH_BUILDROOT=$(ARCH)_musl


all: \
	imagebuilder \
	GLMT300v2 \
	install_zip

GLMT300v2: \
	openwrt-$(OPENWRT_VERSION)-$(TARGET)-$(TARGET_TYPE)-gl-mt300n-v2-squashfs-sysupgrade.bin

