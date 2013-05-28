
VERSION_TAG="PBX_Image_2.0"
IMAGEBUILDER_URL="http://downloads.openwrt.org/attitude_adjustment/12.09/ar71xx/generic/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-i486.tar.bz2"
WGET=wget
DL_FILE="ImageBuilder.tar.bz2"

#Image configuration
FILES_FOLDER="../files"
################  -minimum needed-
GENERAL_PACKAGES="kmod-usb2 kmod-usb-storage kmod-fs-vfat kmod-nls-cp437 kmod-nls-cp850 kmod-nls-iso8859-1 kmod-nls-iso8859-15 kmod-fs-ext4 block-mount kmod-loop losetup kmod-batman-adv wireless-tools kmod-lib-crc16 kmod-nls-utf8 kmod-ip6tables kmod-ipt-nat  kmod-ipv6 zlib hostapd-mini iw swap-utils -ppp -ppp-mod-pppoe " 
 
$(DL_FILE): 
	$(WGET) -O $(DL_FILE)
	tar -xvjf $(DL_FILE)


## Configuration for MR3020
MR3020: $(DL_FILE)
	cd OpenWrt-Image*
	## Configuration for MR3020
	make image PROFILE="TLMR3020" PACKAGES="$(GENERAL_PACKAGES)" FILES_FOLDER="$(FILES_FOLDER)"

MR3040: $(DL_FILE)
	cd OpenWrt-Image*
	## Configuration for MR3020
	make image PROFILE="TLMR3040" PACKAGES="$(GENERAL_PACKAGES)" FILES_FOLDER="$(FILES_FOLDER)"

WR703N: $(DL_FILE)
	cd OpenWrt-Image*
	## Configuration for WR703N
	make image PROFILE="WR703N" PACKAGES="$(GENERAL_PACKAGES)" FILES_FOLDER="$(FILES_FOLDER)"

all: MR3020 MR3040 WR703N

clean:
	-rm  -r OpenWrt-Image*
	-rm $(DL_FILE)
