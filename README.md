Scripts for creating PirateBox Images via OpenWRT's ImageBuilder

make all 

or

make imagebuilder
make MR3020 


If an install_target wants or has specific needs on images already installed packages on the root, you can/have to run

make MR3020 INSTALL_TARGET=librarybox

That results in a customized image containing additional packages. The customized images get an extra prefix to its name.


If you want to create a install.zip for a offline installtion, you have to run 

make imagebuilder
make MR3020

and then the final command ist

make install_zip INSTALL_TARGET="piratebox"

(that results an install_piratebox.zip)

Currently available INSTALL_TARGETs:

   - piratebox  - for  install_zip  (Basic PirateBox)
   - librarybox  - install_zip & image 

The imagebuilder refers to the first PirateBox-OpenWRT-Packagerepository under: 
http://stable.openwrt.piratebox.de/all/packages/

During customization, the package pbxopg gets installed. This package is located at the 
repository above and modifies opkg.conf at the final image to use that repository too.


See our repository for that too: https://github.com/PirateBox-Dev/openwrt-temp-repository


