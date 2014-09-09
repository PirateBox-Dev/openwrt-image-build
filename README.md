# OpenWRT image build
Scripts for creating PirateBox Images via OpenWRT's ImageBuilder

## Make targets
    make all

or

    make imagebuilder
    make MR3020

If an install_target wants or has specific needs on images already installed packages on the root, you have to run

    make MR3020 INSTALL_TARGET=librarybox

The results in a customized image containing additional packages. The customized images gets an extra prefix to to indicate this.


If you want to create a __install.zip__ for offline installtion, you have to run: 

    make imagebuilder
    make MR3020

and then finaly:

    make install_zip INSTALL_TARGET="piratebox"

which will result in an archive called __install_piratebox.zip__

## Cleanup
You can either run:
    
    make clean
    
to get rid of all build related files, except files that were downloaded during this build, or

    make distclean
    
which will delete all files and directories that were created during the build process.

## Available install targets

* _piratebox_:     
Creates install_zip (Basic PirateBox)
* _librarybox_:     
Creates rinstall_zip & image 

The imagebuilder refers to the first PirateBox-OpenWRT-Package repository under: 
* http://stable.openwrt.piratebox.de/all/packages/

During customization, the package pbxopg gets installed. This package is located at the 
repository above and modifies opkg.conf at the final image to use that repository too.

For further information check out the [OpenWRT temp repository](https://github.com/PirateBox-Dev/openwrt-temp-repository)
