#HERE=$(dir $(lastword $(MAKEFILE_LIST)))
HERE:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
ARCH=ar71xx
VERSION_FILE=files/etc/pbx_custom_image
VERSION_TAG="PBX_auto_Image_2.0"
IMAGEBUILDER_URL="http://downloads.openwrt.org/attitude_adjustment/12.09/$(ARCH)/generic/OpenWrt-ImageBuilder-ar71xx_generic-for-linux-i486.tar.bz2"
WGET=wget
DL_FILE="ImageBuilder.tar.bz2"
IB_FOLDER=$(HERE)/OpenWrt-ImageBuilder-$(ARCH)_generic-for-linux-i486

#Is used for creation of the valid flag file for installer
## Which package should be installed later?
TARGET_PACKAGE="extendRoot-piratebox"
INSTALLER_CONF=$(HERE)/files/etc/auto_package

#Image configuration
FILES_FOLDER=$(HERE)/files/
################  -minimum needed-
GENERAL_PACKAGES="pbxopkg box-installer kmod-usb2 kmod-usb-storage kmod-fs-vfat kmod-nls-cp437 kmod-nls-cp850 kmod-nls-iso8859-1 kmod-nls-iso8859-15 kmod-fs-ext4 block-mount kmod-loop losetup kmod-batman-adv wireless-tools kmod-lib-crc16 kmod-nls-utf8 kmod-ip6tables kmod-ipt-nat  kmod-ipv6 zlib hostapd-mini iw swap-utils -ppp -ppp-mod-pppoe " 


#-----------------------------------------
#  Stuff for Install.zip
#
IPKG_TMP:=$(IB_FOLDER)/tmp/ipkgtmp
IPKG_INSTROOT:=$(IB_FOLDER)/build_dir/target-mips_r2_uClibc-0.9.33.2/root-$(ARCH)
IPKG_CONF_DIR:=$(IB_FOLDER)/tmp
IPKG_OFFLINE_ROOT:=$(IPKG_INSTROOT)

#
INSTALL_ZIP=$(HERE)/install.zip
INSTALL_FOLDER=$(HERE)install 
INSTALL_OPENWRT_IMAGE_FILE=$(INSTALL_FOLDER)/$(IMAGE_FILE)
INSTALL_CACHE_FOLDER=$(HERE)/cache
#
IMAGE_FILE=OpenWRT.img.gz
SRC_IMAGE_UNPACKED=OpenWRT.img
IMAGE_DL_URL=http://downloads.piratebox.de/OpenWRT.img.gz
OPKG_INSTALL_DEST=$(IPKG_OFFLINE_ROOT)/prebuilt_ext/

OPKG_CACHE=$(IB_FOLDER)/dl
OPKG_BIN=$(IB_FOLDER)/staging_dir/host/bin/opkg
REPOSITORY_CONF=$(IB_FOLDER)/repositories.conf 
OPKG:= \
  IPKG_TMP=$(IPKG_TMP) \
  IPKG_INSTROOT=$(IPKG_INSTROOT) \
  IPKG_CONF_DIR=$(IPKG_CONF_DIR) \
  IPKG_OFFLINE_ROOT=$(IPKG_OFFLINE_ROOT) \
  IPKG_STATE_DIR=$(IPKG_OFFLINE_ROOT)/usr/lib/opkg \
  $(OPKG_BIN) \
  -f $(REPOSITORY_CONF) \
  --offline-root $(IPKG_INSTROOT) \
  --force-depends \
  --force-overwrite \
  --force-postinstall \
  --add-dest ext:$(OPKG_INSTALL_DEST) \
  --add-dest root:/ \
  --add-arch all:100 \
  --add-arch $(ARCH):200


$(IMAGE_FILE):
	wget -c -O $@ $(IMAGE_DL_URL)

$(OPKG_INSTALL_DEST): $(IMAGE_FILE)
	mkdir -p $@
	gunzip  $(IMAGE_FILE) -c > $(SRC_IMAGE_UNPACKED)
	sudo  mount -o loop,rw,sync $(SRC_IMAGE_UNPACKED)  $@

opkg_test:
	$(OPKG) --download-only list-installed

install_piratebox: $(OPKG_INSTALL_DEST)
	 $(OPKG) -d ext install piratebox

#-----------------------------------------



$(DL_FILE):
	$(WGET) -c  -O $(DL_FILE) $(IMAGEBUILDER_URL)

$(IB_FOLDER): $(DL_FILE) $(VERSION_FILE) $(INSTALLER_CONF)
	tar -xvjf $(DL_FILE) 
	echo "src/gz piratebox http://dev.openwrt.piratebox.de/all/packages" >> $(IB_FOLDER)/repositories.conf

$(VERSION_FILE): 
	mkdir -p files/etc
	echo $(VERSION_TAG) > $@

$(INSTALLER_CONF):
	mkdir -p files/etc
	echo $(TARGET_PACKAGE) > $@

imagebuilder: $(IB_FOLDER) 


%.bin: 
	cp $(IB_FOLDER)/bin/ar71xx/$@ ./

TLMR3020 TLMR3040 TLWR703 :  
	cd $(IB_FOLDER)  &&	make image PROFILE="$@" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)

############## uncommented. We can reuse one until we need different packages
#TLMR3040 : 
#	cd $(IB_FOLDER) &&	make image PROFILE="$@" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)
#
#TLWR703 : 
#	cd $(IB_FOLDER) &&	make image PROFILE="$@" PACKAGES=$(GENERAL_PACKAGES) FILES=$(FILES_FOLDER)


all: imagebuilder MR3020 MR3040 WR703N

MR3020: TLMR3020 openwrt-ar71xx-generic-tl-mr3020-v1-squashfs-factory.bin

MR3040: TLMR3040 openwrt-ar71xx-generic-tl-mr3040-v1-squashfs-factory.bin

WR703N: TLWR703 openwrt-ar71xx-generic-tl-wr703n-v1-squashfs-factory.bin

clean:
	-rm $(VERSION_FILE) $(INSTALLER_CONF)
	-rm  -r $(IB_FOLDER)
	-rm $(DL_FILE)
	-rm openwrt-ar71xx-generic*
