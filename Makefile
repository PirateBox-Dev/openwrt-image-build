
VERSION_TAG="PBX_Image_2.0"
IMAGEBUILDER_URL="http://downloads.openwrt.org/attitude_adjustment/12.09/ar71xx/generic/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-i486.tar.bz2"
WGET=wget
DL_FILE="ImageBuilder.tar.bz2"
IB_FOLDER=OpenWrt-ImageBuilder-ar71xx_generic-for-linux-i486


#Image configuration
FILES_FOLDER=../files/
################  -minimum needed-
GENERAL_PACKAGES="kmod-usb2 kmod-usb-storage kmod-fs-vfat kmod-nls-cp437 kmod-nls-cp850 kmod-nls-iso8859-1 kmod-nls-iso8859-15 kmod-fs-ext4 block-mount kmod-loop losetup kmod-batman-adv wireless-tools kmod-lib-crc16 kmod-nls-utf8 kmod-ip6tables kmod-ipt-nat  kmod-ipv6 zlib hostapd-mini iw swap-utils -ppp -ppp-mod-pppoe " 
 
$(DL_FILE):
	$(WGET) -c  -O $(DL_FILE) $(IMAGEBUILDER_URL)

$(IB_FOLDER): $(DL_FILE) 
	tar -xvjf $(DL_FILE) 

imagebuilder: $(IB_FOLDER)


## Configuration for MR3020
MR3020: 
	cd $(IB_FOLDER)  &&	make image PROFILE="TLMR3020" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)
	cp $(IB_FOLDER)/bin/ar71xx/openwrt-ar71xx-generic-tl-mr3020-v1-squashfs-factory.bin ./

MR3040: 
	cd $(IB_FOLDER) &&	make image PROFILE="TLMR3040" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)
	cp $(IB_FOLDER)/bin/ar71xx/openwrt-ar71xx-generic-tl-mr3040-v1-squashfs-factory.bin ./

WR703N: 
	cd $(IB_FOLDER) &&	make image PROFILE="TLWR703N" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)
	cp $(IB_FOLDER)/bin/ar71xx/openwrt-ar71xx-generic-tl-WR703N-v1-squashfs-factory.bin ./


all: imagebuilder MR3020 MR3040 WR703N

clean:
	-rm  -r $(IB_FOLDER)
	-rm $(DL_FILE)
	-rm openwrt-ar71xx-generic*
