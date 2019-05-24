## Build rules for ar71xx-generic

TARGET=ar71xx
TARGET_TYPE=generic
ARCH=mips_24kc
ARCH_BUILDROOT=$(ARCH)_musl-1.1.16


all: \
	imagebuilder \
	GLAR150 \
	GLAR300 \
	INET \
	WR710 \
	WR842 \
	WR2543 \
	WR1043 \
	WDR4300 \
	WR902AC \
	install_zip

INET: \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-gl-inet-6408A-v1-squashfs-factory.bin \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-gl-inet-6416A-v1-squashfs-factory.bin


GLAR150: \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-gl-ar150-squashfs-sysupgrade.bin

GLAR300: \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-gl-ar300-squashfs-sysupgrade.bin  \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-gl-ar300m-squashfs-sysupgrade.bin

WR710: \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr710n-v1-squashfs-factory.bin \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr710n-v2.1-squashfs-factory.bin

WR842: \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr842n-v1-squashfs-factory.bin\
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr842n-v2-squashfs-factory.bin\
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr842n-v3-squashfs-factory.bin

WR1043: \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr1043nd-v1-squashfs-factory.bin\
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr1043nd-v2-squashfs-factory.bin\
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr1043nd-v3-squashfs-factory.bin\
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr1043nd-v4-squashfs-factory.bin

WR2543: \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr2543-v1-squashfs-factory.bin

WDR4300: \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wdr4300-v1-squashfs-factory.bin \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wdr4300-v1-il-squashfs-factory.bin

WR902AC: \
	openwrt-$(OPENWRT_VERSION)-ar71xx-generic-tl-wr902ac-v1-squashfs-factory.bin 
