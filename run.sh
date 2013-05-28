GENERAL_PACKAGES="kmod-usb2 kmod-usb-storage kmod-fs-vfat kmod-nls-cp437 kmod-nls-cp850 kmod-nls-iso8859-1 kmod-nls-iso8859-15 kmod-fs-ext4 block-mount kmod-loop losetup kmod-batman-adv wireless-tools kmod-lib-crc16 kmod-nls-utf8 kmod-ip6tables kmod-ipt-nat  kmod-ipv6 zlib hostapd-mini iw swap-utils -ppp -ppp-mod-pppoe " 

## Configuration for MR3020
make image PROFILE="TLMR3020" PACKAGES="$GENERAL_PACKAGES"

## Configuration for MR3040
make image PROFILE="TLMR3040" PACKAGES="$GENERAL_PACKAGES"

## Configuration for WR703N
make image PROFILE="WR703N" PACKAGES="$GENERAL_PACKAGES"


