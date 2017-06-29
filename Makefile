HERE:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
TARGET=ar71xx
TARGET_TYPE=generic
ARCH=mips_24kc
ARCH_BUILDROOT=$(ARCH)_musl-1.1.16

# Version related configuration
VERSION_FILE=files/etc/pbx_custom_image
VERSION_TAG="PBX_auto_Image_2.5"

# Imagebuilder related configuration
LEDE_VERSION=17.01.2

# Add a prefix to allow box installer to find these images, too...
#  .. LEDE and OpenWrt will join in future, the the name lede_
#  in the images will vanish, so we can revert it here back without
#  touching the autoflash feature
OPENWRT_COMP="openwrt_"

include ${CURDIR}/include/$(TARGET)-$(TARGET_TYPE).mk

IMAGEBUILDER_URL="https://downloads.lede-project.org/releases/$(LEDE_VERSION)/targets/$(TARGET)/$(TARGET_TYPE)/lede-imagebuilder-$(LEDE_VERSION)-$(TARGET)-$(TARGET_TYPE).Linux-x86_64.tar.xz"
IMAGE_BUILDER_FILE="ImageBuilder-$(TARGET)_$(TARGET_TYPE).tar.xz"
LEDE_REPOSITORY_PREFIX="reboot"


IMAGE_BUILD_REPOSITORY?=http://development.piratebox.de/all/packages
IMAGE_BUILD_FOLDER=$(HERE)/lede-imagebuilder-$(LEDE_VERSION)-$(TARGET)-$(TARGET_TYPE).Linux-x86_64/

# Prefix for the installer directory
#
# Set through INSTALL_TARGET variable passed while building.
# Possible options:
# * piratebox
TARGET_FOLDER_PREFIX=./target_

# Image configuration
FILES_FOLDER=$(HERE)/files/

# Minimum dependencies
#GENERAL_PACKAGES:=pbxopkg box-installer kmod-usb2 kmod-usb-storage kmod-fs-vfat kmod-nls-cp437 kmod-nls-cp850 kmod-nls-iso8859-1 kmod-nls-iso8859-15 kmod-fs-ext4 block-mount kmod-loop losetup kmod-batman-adv wireless-tools kmod-lib-crc16 kmod-nls-utf8 kmod-ip6tables kmod-ipt-nat zlib hostapd-mini iw swap-utils -ppp -ppp-mod-pppoe
GENERAL_PACKAGES:=pbxopkg box-installer kmod-usb2 kmod-usb-storage kmod-fs-vfat kmod-nls-cp437 kmod-nls-cp850 kmod-nls-iso8859-1 kmod-nls-iso8859-15 kmod-fs-ext4 kmod-loop losetup kmod-lib-crc16 kmod-nls-utf8 kmod-ip6tables zlib iw swap-utils -ppp -ppp-mod-pppoe block-mount kmod-batman-adv -odhcp6c 

# Install.zip related configuration
IPKG_TMP:=$(IMAGE_BUILD_FOLDER)/tmp/ipkgtmp
IPKG_INSTROOT:=$(IMAGE_BUILD_FOLDER)/build_dir/target-$(ARCH_BUILDROOT)/root-$(TARGET)
IPKG_CONF_DIR:=$(IMAGE_BUILD_FOLDER)/tmp
IPKG_OFFLINE_ROOT:=$(IPKG_INSTROOT)
IPKG_STATE_DIR=$(IPKG_OFFLINE_ROOT)/usr/lib/opkg

IMAGE_FILE:=OpenWRT.img.gz
SRC_IMAGE_UNPACKED:=OpenWRT.img
IMAGE_DL_URL:=http://downloads.piratebox.de/OpenWRT_ext4_100MB.img.gz
EXT_FOLDER:=/prebuilt_ext/
DEST_IMAGE_FOLDER=$(IMAGE_BUILD_FOLDER)/img_tmp
OPKG_INSTALL_DEST:=$(IPKG_OFFLINE_ROOT)/$(EXT_FOLDER)

# This has to be aligned with current piratebox version :(
parse_install_target:
ifeq ($(INSTALL_TARGET), piratebox)
ADDITIONAL_PACKAGE_IMAGE_URL:="http://stable.openwrt.piratebox.de/piratebox_images/piratebox_ws_1.2_img.tar.gz"
ADDITIONAL_PACKAGE_FILE:=piratebox_ws_1.2_img.tar.gz
GENERAL_PACKAGES:=$(GENERAL_PACKAGES) pbxmesh
TARGET_PACKAGE=extendRoot-$(INSTALL_TARGET) piratebox-mod-imageboard extendRoot-minidlna  extendRoot-avahi extendRoot-dbus extendRoot-avahi-tools
AUTO_PACKAGE_ORDER="extendRoot-dbus extendRoot-avahi extendRoot-avahi-tools extendRoot-piratebox piratebox-mod-imageboard extendRoot-minidlna"
KAREHA_RELEASE:=kareha_3.1.4.zip
endif 
ifeq ($(INSTALL_TARGET),librarybox)
ADDITIONAL_PACKAGE_IMAGE_URL:="http://downloads.librarybox.us/librarybox_2.2_img.tar.gz"
ADDITIONAL_PACKAGE_FILE=librarybox_2.2_img.tar.gz
TARGET_PACKAGE=extendRoot-$(INSTALL_TARGET) extendRoot-minidlna extendRoot-avahi extendRoot-avahi-tools extendRoot-dbus
AUTO_PACKAGE_ORDER="extendRoot-dbus extendRoot-avahi extendRoot-avahi-tools extendRoot-librarybox"
# Add additional packages to image build directly on root
GENERAL_PACKAGES:=$(GENERAL_PACKAGES) usb-config-scripts-librarybox pbxmesh
endif

INSTALL_PREFIX:=$(TARGET_FOLDER_PREFIX)$(INSTALL_TARGET)_$(TARGET)-$(TARGET_TYPE)
INSTALL_ZIP:=$(HERE)/$(INSTALL_PREFIX)/install_$(INSTALL_TARGET).zip
INSTALL_FOLDER:=$(HERE)/$(INSTALL_PREFIX)/install
INSTALL_OPENWRT_IMAGE_FILE:=$(INSTALL_FOLDER)/$(IMAGE_FILE)
INSTALL_CACHE_FOLDER:=$(INSTALL_FOLDER)/cache/
INSTALL_ADDITIONAL_PACKAGE_FILE=$(INSTALL_FOLDER)/$(ADDITIONAL_PACKAGE_FILE)
INSTALLER_CONF=$(INSTALL_FOLDER)/auto_package


REPOSITORY_CONF=$(IMAGE_BUILD_FOLDER)/repositories.conf
OPKG_CACHE=$(IMAGE_BUILD_FOLDER)/dl
OPKG_BIN=$(IMAGE_BUILD_FOLDER)/staging_dir/host/bin/opkg
OPKG_WITHOUT_POSTINSTALL:= \
  IPKG_TMP=$(IPKG_TMP) \
  IPKG_INSTROOT=$(IPKG_INSTROOT) \
  IPKG_CONF_DIR=$(IPKG_CONF_DIR) \
  IPKG_OFFLINE_ROOT=$(IPKG_OFFLINE_ROOT) \
  IPKG_STATE_DIR=$(IPKG_STATE_DIR) \
  $(OPKG_BIN) \
  --cache $(INSTALL_CACHE_FOLDER) \
  -f $(REPOSITORY_CONF) \
  --offline-root $(IPKG_INSTROOT) \
  --force-depends \
  --force-overwrite \
  --add-dest ext:$(EXT_FOLDER) \
  --add-dest root:/ \
  --add-arch all:100 \
  --add-arch $(ARCH):200
OPKG:= \
  $(OPKG_WITHOUT_POSTINSTALL) \
  --force-postinstall

$(INSTALL_CACHE_FOLDER) $(INSTALL_FOLDER) $(OPKG_INSTALL_DEST):
	mkdir -p $@

# Obtain the OpenWRT image file
$(IMAGE_FILE):
	wget -c $(IMAGE_DL_URL) -O $@

# Download the piratebox image file
$(ADDITIONAL_PACKAGE_FILE):
	wget -c $(ADDITIONAL_PACKAGE_IMAGE_URL) -O $@

$(INSTALL_ADDITIONAL_PACKAGE_FILE): $(ADDITIONAL_PACKAGE_FILE)
	cp -v $(ADDITIONAL_PACKAGE_FILE) $@

$(INSTALLER_CONF):
	 printf '%b\n' "$(AUTO_PACKAGE_ORDER)" > $@

mount_ext: 
	mkdir -p $(DEST_IMAGE_FOLDER)
	gunzip $(IMAGE_FILE) -c > $(SRC_IMAGE_UNPACKED)
	sudo mount -o loop,rw,sync $(SRC_IMAGE_UNPACKED) $(DEST_IMAGE_FOLDER)

transfer_data_to_ext:
	sudo cp -rv --preserve=mode,links $(OPKG_INSTALL_DEST)/* $(DEST_IMAGE_FOLDER)

umount_ext: 
	sudo umount $(DEST_IMAGE_FOLDER)

create_cache: $(IMAGE_FILE) $(OPKG_INSTALL_DEST) $(INSTALL_CACHE_FOLDER)
	mkdir -p "$(IPKG_CONF_DIR)"
	cd $(IMAGE_BUILD_FOLDER) && \
	$(OPKG) update && \
	$(OPKG) -d ext --download-only install $(TARGET_PACKAGE) | tee $(HERE)/opkg_log
	grep file\:packages $(HERE)/opkg_log | sed 's|Downloading file\:||' | sed 's|.ipk.|.ipk|' | xargs -I {} cp -v $(IMAGE_BUILD_FOLDER)/{} $(INSTALL_CACHE_FOLDER)

$(INSTALL_OPENWRT_IMAGE_FILE):
	gzip -c $(SRC_IMAGE_UNPACKED) > $@

# Repository-Informations
# On the live image it is called attitiude_adjustment... on the imagebuild - yeah u know
cache_package_list:
	cd $(IPKG_STATE_DIR)/lists/ ; ls -1 piratebox $(LEDE_REPOSITORY_PREFIX)* | while read packagefile ; do cp -v $(IPKG_STATE_DIR)/lists/$$packagefile $(INSTALL_CACHE_FOLDER)/Package.gz_$$packagefile ; done 

$(INSTALL_ZIP):
	cd $(INSTALL_PREFIX) && zip -r9 $@ ./install
	cd $(INSTALL_PREFIX) && sha256sum ` basename $@ `   > $@.sha256

# Prepare the installation zip
install_zip: eval_install_zip prepare_install_zip $(INSTALL_ZIP)

eval_install_zip:
ifeq ($(INSTALL_TARGET),)
	$(error "No INSTALL_TARGET set")
else
	rm -rf $(INSTALLER_CONF)
	$(parse_install_target)
endif

prepare_install_zip: create_cache cache_package_list $(INSTALLER_CONF) mount_ext transfer_data_to_ext umount_ext $(INSTALL_OPENWRT_IMAGE_FILE) $(INSTALL_ADDITIONAL_PACKAGE_FILE)
ifeq ($(INSTALL_TARGET), piratebox)
	if [ ! -e $(KAREHA_RELEASE) ]; then wget -c http://wakaba.c3.cx/releases/$(KAREHA_RELEASE) -O $(KAREHA_RELEASE); fi;
	cp -v $(KAREHA_RELEASE) $(INSTALL_FOLDER)
endif 

# Prepare the image builder folder
imagebuilder: $(IMAGE_BUILD_FOLDER)

# Extract the image builder
$(IMAGE_BUILD_FOLDER): $(IMAGE_BUILDER_FILE) $(VERSION_FILE)
	pbzip2 -cd $(IMAGE_BUILDER_FILE) | tar -xv || tar -xvf $(IMAGE_BUILDER_FILE) 
	echo "src/gz piratebox $(IMAGE_BUILD_REPOSITORY)" >> $(IMAGE_BUILD_FOLDER)/repositories.conf

# Download the imagebuilder file
$(IMAGE_BUILDER_FILE):
	wget -c $(IMAGEBUILDER_URL) -O $(IMAGE_BUILDER_FILE)

# Create the version file
$(VERSION_FILE): 
	mkdir -p files/etc
	echo $(VERSION_TAG) > $@

%.bin:  parse_install_target
	echo "$@" | sed -e 's|lede-$(LEDE_VERSION)-$(TARGET)-$(TARGET_TYPE)-||' -e 's|-squashfs-factory.bin||' -e 's|-squashfs-sysupgrade.bin||' > $(IMAGE_BUILD_FOLDER)/profile.build.tmp
	cd $(IMAGE_BUILD_FOLDER) &&	make image PROFILE="$$(cat $(IMAGE_BUILD_FOLDER)/profile.build.tmp )" PACKAGES="$(GENERAL_PACKAGES)" FILES=$(FILES_FOLDER)
ifneq ($(INSTALL_PREFIX),)
	mkdir -p $(INSTALL_PREFIX)
	cp $(IMAGE_BUILD_FOLDER)/bin/targets/$(TARGET)/$(TARGET_TYPE)/$@ $(INSTALL_PREFIX)/$(OPENWRT_COMP)$@
	cd $(INSTALL_PREFIX) && sha256sum $(OPENWRT_COMP)$@ > $(OPENWRT_COMP)$@.sha256
else
	cp $(IMAGE_BUILD_FOLDER)/bin/targets/$(TARGET)/$(TARGET_TYPE)/$@ ./$@
	sha256sum $@ > $@.sha256
endif






distclean: clean
	rm -rf $(IMAGE_BUILDER_FILE)
	rm -rf $(FILES_FOLDER)
	rm -rf $(KAREHA_RELEASE)

clean: clean_installer
	rm -rf $(VERSION_FILE) $(INSTALLER_CONF)
	rm -rf $(IMAGE_BUILD_FOLDER)
	rm -rf lede-*

clean_installer:
	if mount | grep $(DEST_IMAGE_FOLDER) > /dev/null; then sudo umount $(DEST_IMAGE_FOLDER); fi;
	rm -rf $(INSTALL_FOLDER)
	rm -rf $(OPKG_INSTALL_DEST)
	rm -rf $(DEST_IMAGE_FOLDER)
	rm -rf $(TARGET_FOLDER_PREFIX)*
	rm -rf $(SRC_IMAGE_UNPACKED)
	rm -rf $(IMAGE_FILE)
	rm -rf $(HERE)/opkg_log
