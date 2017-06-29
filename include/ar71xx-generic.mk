## Build rules for ar71xx-generic

TARGET=ar71xx
TARGET_TYPE=generic
ARCH=mips_24kc
ARCH_BUILDROOT=$(ARCH)_musl-1.1.16


all: \
	imagebuilder \
	GLAR150 \
	INET \
	MR3020 \
	MR3040 \
	MR3220 \
	MR3420 \
	MR10U \
	MR11U \
	MR13U \
	WR703N \
	WR710 \
	WR842 \
	WR2543 \
	WR1043 \
	WDR4300 \
	install_zip

INET: \
	lede-$(LEDE_VERSION)-ar71xx-generic-gl-inet-6408A-v1-squashfs-factory.bin \
	lede-$(LEDE_VERSION)-ar71xx-generic-gl-inet-6416A-v1-squashfs-factory.bin


GLAR150: \
	lede-$(LEDE_VERSION)-ar71xx-generic-gl-ar150-squashfs-sysupgrade.bin

MR3020: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr3020-v1-squashfs-factory.bin

MR3040: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr3040-v1-squashfs-factory.bin \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr3040-v2-squashfs-factory.bin 

MR3220: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr3220-v1-squashfs-factory.bin \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr3220-v2-squashfs-factory.bin 

MR3420: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr3420-v1-squashfs-factory.bin \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr3420-v2-squashfs-factory.bin 

MR10U: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr10u-v1-squashfs-factory.bin 

MR11U: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr11u-v1-squashfs-factory.bin \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr11u-v2-squashfs-factory.bin 

MR13U: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-mr13u-v1-squashfs-factory.bin

WR703N: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr703n-v1-squashfs-factory.bin

WR710: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr710n-v1-squashfs-factory.bin \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr710n-v2-squashfs-factory.bin \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr710n-v2.1-squashfs-factory.bin

WR842: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr842n-v1-squashfs-factory.bin\
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr842n-v2-squashfs-factory.bin\
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr842n-v3-squashfs-factory.bin

WR1043: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr1043nd-v1-squashfs-factory.bin\
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr1043nd-v2-squashfs-factory.bin\
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr1043nd-v3-squashfs-factory.bin\
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr1043nd-v4-squashfs-factory.bin

WR2543: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wr2543-v1-squashfs-factory.bin

WDR4300: \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wdr4300-v1-squashfs-factory.bin \
	lede-$(LEDE_VERSION)-ar71xx-generic-tl-wdr4300-v1-il-squashfs-factory.bin

