
VERSION_FILE=files/etc/pbx_custom_image
VERSION_TAG="PBX_Image_2.0 trunk beta "
SRC_OPENWRT_TAG=OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64/build_dir/target*/root-ar71xx/etc/openwrt_release 
MY_OPENWRT_TAG=./openwrt_release
IMAGEBUILDER_URL="http://downloads.openwrt.org/snapshots/trunk/ar71xx/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-x86_64.tar.bz2"
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
	tar -xvjf $(DL_FILE) 
	echo "src/gz piratebox http://stable.openwrt.piratebox.de/all/packages" >> $(IB_FOLDER)/repositories.conf

$(VERSION_FILE): 
	mkdir -p files/etc
	echo $(VERSION_TAG) > $@

imagebuilder: $(IB_FOLDER) 
	- rm -f $(MY_OPENWRT_TAG)


%.bin: 
	cp $(IB_FOLDER)/bin/ar71xx/$@ ./

TLMR3020 TLMR3040 TLWR703 TLMR11U TLMR10U TLWR842 :  
	cd $(IB_FOLDER)  &&	make image PROFILE="$@" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)

############## uncommented. We can reuse one until we need different packages
#TLMR3040 : 
#	cd $(IB_FOLDER) &&	make image PROFILE="$@" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)
#
#TLWR703 : 
#	cd $(IB_FOLDER) &&	make image PROFILE="$@" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)


all: imagebuilder MR3020 MR3040 WR703N MR11U MR10U WR842  version_tag

version_tag:
	cp $(SRC_OPENWRT_TAG) $(MY_OPENWRT_TAG)

MR3020: TLMR3020 openwrt-ar71xx-generic-tl-mr3020-v1-squashfs-factory.bin

MR3040: TLMR3040 openwrt-ar71xx-generic-tl-mr3040-v1-squashfs-factory.bin

WR703N: TLWR703 openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-factory.bin

MR11U: TLMR11U openwrt-ar71xx-generic-tl-mr11u-v1-squashfs-factory.bin

MR10U: TLMR10U openwrt-ar71xx-generic-tl-mr10u-v1-squashfs-factory.bin

WR842: TLWR842 openwrt-ar71xx-generic-tl-wr842n-v1-squashfs-factory.bin

clean:
	-rm -f $(MY_OPENWRT_TAG)
	-rm $(VERSION_FILE)
	-rm  -r $(IB_FOLDER)
	-rm $(DL_FILE)
	-rm openwrt-ar71xx-generic*
