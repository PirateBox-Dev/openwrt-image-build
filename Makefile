VERSION_FILE=files/etc/pbx_custom_image
VERSION_TAG="PBX_Image_2.0"
IMAGEBUILDER_URL="https://github.com/FriedZombie/OpenWrt_Attitude-Adjustment_backports/releases/download/V0.2.1/OpenWrt-ImageBuilder-opkg618-fw2-ar71xx_generic-for-linux-x86_64.tar.bz2"
WGET=wget
DL_FILE="ImageBuilder.tar.bz2"
IB_FOLDER=OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64


#Image configuration
FILES_FOLDER=../files/
################  -minimum needed-
GENERAL_PACKAGES="pbxopkg kmod-usb2 kmod-usb-storage kmod-fs-vfat kmod-nls-cp437 kmod-nls-cp850 kmod-nls-iso8859-1 kmod-nls-iso8859-15 kmod-fs-ext4 block-mount kmod-loop losetup kmod-batman-adv wireless-tools kmod-lib-crc16 kmod-nls-utf8 kmod-ip6tables kmod-ipt-nat  kmod-ipv6 zlib hostapd-mini iw swap-utils -ppp -ppp-mod-pppoe " 
 
$(DL_FILE):
	$(WGET) -c  -O $(DL_FILE) $(IMAGEBUILDER_URL)

$(IB_FOLDER): $(DL_FILE) $(VERSION_FILE)
	pbzip2 -cd $(DL_FILE) | tar -xv || tar -xvjf $(DL_FILE)
	echo "src/gz piratebox http://stable.openwrt.piratebox.de/all/packages" >> $(IB_FOLDER)/repositories.conf

$(VERSION_FILE): 
	mkdir -p files/etc
	echo $(VERSION_TAG) > $@

imagebuilder: $(IB_FOLDER) 


%.bin: 
	cp $(IB_FOLDER)/bin/ar71xx/$@ ./

GLINET TLMR3020 TLMR3040 TLMR10U TLMR11U TLMR13U TLWR703 TLWR842 TLWR1043 :
	cd $(IB_FOLDER)  &&	make image PROFILE="$@" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)

############## uncommented. We can reuse one until we need different packages
#TLMR3040 : 
#	cd $(IB_FOLDER) &&	make image PROFILE="$@" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)
#
#TLWR703 : 
#	cd $(IB_FOLDER) &&	make image PROFILE="$@" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)


all: imagebuilder INET MR3020 MR3040 MR10U MR11U MR13U WR703N WR842 WR1043

INET: GLINET openwrt-ar71xx-generic-gl-inet-v1-squashfs-factory.bin

MR3020: TLMR3020 openwrt-ar71xx-generic-tl-mr3020-v1-squashfs-factory.bin

MR3040: TLMR3040 openwrt-ar71xx-generic-tl-mr3040-v1-squashfs-factory.bin openwrt-ar71xx-generic-tl-mr3040-v2-squashfs-factory.bin

MR10U: TLMR10U openwrt-ar71xx-generic-tl-mr10u-v1-squashfs-factory.bin

MR11U: TLMR11U openwrt-ar71xx-generic-tl-mr11u-v1-squashfs-factory.bin openwrt-ar71xx-generic-tl-mr11u-v2-squashfs-factory.bin

MR13U: TLMR13U openwrt-ar71xx-generic-tl-mr13u-v1-squashfs-factory.bin

WR703N: TLWR703 openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-factory.bin

WR842: TLWR842 openwrt-ar71xx-generic-tl-wr842n-v1-squashfs-factory.bin

WR1043: TLWR1043 openwrt-ar71xx-generic-tl-wr1043nd-v1-squashfs-factory.bin openwrt-ar71xx-generic-tl-wr1043nd-v2-squashfs-factory.bin

clean:
	-rm $(VERSION_FILE)
	-rm  -r $(IB_FOLDER)
	-rm $(DL_FILE)
	-rm openwrt-ar71xx-generic*
