#!/bin/sh

#--------------------------------------------------------------------------
#-                AVR-Ada - A GCC Ada environment for AVR-Atmel          --
#-                                      *                                --
#-                                 AVR-Ada 1.1.0                         --
#-                     Copyright (C) 2009 Neil Davenport                 --
#-                     Copyright (C) 2005, 2007 Rolf Ebert               --
#-                     Copyright (C) 2005 Stephane Riviere               --
#-                     Copyright (C) 2003-2005 Bernd Trog                --
#-                            avr-ada.sourceforge.net                    --
#-                                      *                                --
#-                                                                       --
#--------------------------------------------------------------------------
#- The AVR-Ada Library is free software;  you can redistribute it and/or --
#- modify it under terms of the  GNU General Public License as published --
#- by  the  Free Software  Foundation;  either  version 2, or  (at  your --
#- option) any later version.  The AVR-Ada Library is distributed in the --
#- hope that it will be useful, but  WITHOUT ANY WARRANTY;  without even --
#- the  implied warranty of MERCHANTABILITY or FITNESS FOR A  PARTICULAR --
#- PURPOSE. See the GNU General Public License for more details.         --
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
#-                          AVR-Ada EasyBake Build script                --
#-                                      *                                --
#-  This script  will download,  prepare and build  AVR-Ada without      --
#-  any human interaction and is designed to make the build process      --
#-  easier for beginners and experts alike                               --
#-                                      *                                --
#-  To use simply create a directory and copy this script to it then     --
#-  cd into the directory and type ./build-avr-ada-gcc-4.3.x.sh          --
#-
#-  N.B. This script was written for BASH. If you use another shell      --
#-  invoke with bash ./build-avr-ada-gcc-4.3.x.sh                        --
#-                                                                       --
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# Under Windows 2K/XP, you need :
#
# MinGW-5.1.4.exe (Windows installer).
# MSYS-1.0.10.exe (Windows installer).
# msysCORE-1.0.11-<latestdate>
# msysDTK-1.0.1.exe (Windows installer).
# flex-2.5.33-MSYS-1.0.11-1
# bison-2.3-MSYS-1.0.11-1
# regex-0.12-MSYS-1.0.11-1
# gettext-0.16.1-1
# tar-1.13.19-MSYS-2005.06.08
# autoconf 2.59
# automake 1.8.2
# wget
# cvs
#
#---------------------------------------------------------------------------
#
# $DOWNLOAD  : should point to directory which contains the files
#              specified by : FILE_BINUTILS, FILE_GCC and FILE_LIBC
# $AVR_BUILD : the temporary directory used to build AVR-Ada
# $PREFIX    : the root of the installation directory
# $FILE_...  : filenames of the source distributions without extension
# $BIN_PATCHES : blank separated list of binutils patch files
# $GCC_PATCHES : blank separated list of patch files for gcc
#
#---------------------------------------------------------------------------

BASE_DIR=$PWD
OS=`uname -s`
if test $OS = "Linux" ; then
    PREFIX="/opt/avr"
else
    PREFIX="/mingw/avr"
fi

# add PREFIX/bin to the PATH
# Be sure to have the local directory very late in your PATH, best at the
# very end.
export PATH="${PREFIX}/bin:${PATH}"

VER_BINUTILS=2.19
VER_GCC=4.3.2
VER_MPFR=2.4.0
VER_GMP=4.2.4
VER_LIBC=1.6.2
VER_AVRADA=1.0.2

FILE_BINUTILS="binutils-$VER_BINUTILS"
FILE_GCC="gcc-$VER_GCC"
FILE_MPFR="mpfr-$VER_MPFR"
FILE_GMP="gmp-$VER_GMP"
FILE_LIBC="avr-libc-$VER_LIBC"
FILE_AVRADA="avr-ada-$VER_AVRADA"

BASE_DIR=$PWD
DOWNLOAD="$BASE_DIR/src"
AVR_BUILD="$BASE_DIR/build"

AVRADA_DIR=$DOWNLOAD/AVR-Ada/patches
AVRADA_GCC_DIR="$AVRADA_DIR/gcc/$VER_GCC"
AVRADA_BIN_DIR="$AVRADA_DIR/binutils/$VER_BINUTILS"

WINAVR_DIR=$DOWNLOAD/WinAVR/patches
WINAVR_GCC_DIR="$WINAVR_DIR/gcc/$VER_GCC"
WINAVR_BIN_DIR="$WINAVR_DIR/binutils/$VER_BINUTILS"


# actions:

# Download necessary tarbals and patches using wget and cvs
download_files="yes"    
delete_obj_dirs="yes"
delete_build_dir="yes"
delete_install_dir="no"
build_binutils="yes"
build_gcc="yes"
build_libc="yes"
build_avrada="yes"

# The following are advanced options not required for a normal build
# either delete the build directory completely
#
#   delete_build_dir="yes"
#
# or delete only the obj directories.  You probably want to keep the
# extracted and patched sources
#
#   delete_build_dir="no"
#   delete_obj_dirs="yes"
#   no_extract="yes"
#   no_patch="yes"
#

#CC="gcc -mno-cygwin"
CC=gcc
export CC

#echo "Please adjust the variables above to your environment."
#echo "No need to change anything below."
#exit


#---------------------------------------------------------------------------
# utility functions
#---------------------------------------------------------------------------

# print date/time in ISO format
function print_time () {
    date +"%Y-%m-%d_%H:%M:%S"
}

function display_noeol () {
    printf "$@"
    printf "$@" >> $AVR_BUILD/build.log
}

function display () {
    echo "$@"
    echo "$@" >> $AVR_BUILD/build.log
}

function log () {
    echo "$@" >> $AVR_BUILD/build.log
}

function header () {
    display
    display       "--------------------------------------------------------------"
    display_noeol `print_time`
    display "  $@"
    display       "--------------------------------------------------------------"
    display
}

function check_return_code () {
    if [ $? != 0 ]; then
        echo
        echo " **** The last command failed :("
        echo "Please check the generated log files for errors and warnings."
        echo "Exiting.."
        exit 2
    fi
}

#---------------------------------------------------------------------------
# build script
#---------------------------------------------------------------------------

export PATH=$PREFIX/bin:$PATH

echo "--------------------------------------------------------------"
echo "GCC AVR-Ada build script: all output is saved in log files"
echo "--------------------------------------------------------------"
echo

GCC_VERSION=`$CC -dumpversion`
GCC_MAJOR=`echo $GCC_VERSION | awk -F. ' { print $1; } '`
GCC_MINOR=`echo $GCC_VERSION | awk -F. ' { print $2; } '`
GCC_PATCH=`echo $GCC_VERSION | awk -F. ' { print $3; } '`

if test "$GCC_VERSION" < "4.3.0" ; then  # string comparison (?)
    echo "($version) is too old"
    echo "AVR-Ada V1 requires gcc-4.3.0 or later as build compiler"
    exit 2
else
    echo "Found native compiler gcc-"$GCC_VERSION
fi

if test "x$delete_build_dir" = "xyes" ; then
    echo
    echo "--------------------------------------------------------------"
    echo "Deleting previous build and source files"
    echo "--------------------------------------------------------------"
    echo

    echo "Deleting :" $AVR_BUILD
    rm -fr $AVR_BUILD

else
    if test "x$delete_obj_dirs" = "xyes" ; then
        echo
        echo "--------------------------------------------------------------"
        echo "Deleting previous obj dirs"
        echo "--------------------------------------------------------------"
        echo

        echo "Deleting :" $AVR_BUILD/binutils-obj
        rm -fr $AVR_BUILD/binutils-obj

        echo "Deleting :" $AVR_BUILD/gcc-obj
        rm -fr $AVR_BUILD/gcc-obj

    fi
fi

mkdir $AVR_BUILD

rm -f $AVR_BUILD/build.sum; touch $AVR_BUILD/build.sum
rm -f $AVR_BUILD/build.log; touch $AVR_BUILD/build.log


if test $delete_install_dir = "yes" ; then
    echo "Deleting :" $PREFIX
    rm -fr $PREFIX
fi


if test "x$download_files" = "xyes" ; then
   #########################################################################
    header "Downloading Files"

    WGET="wget --no-clobber --directory-prefix=$DOWNLOAD"
    if test ! -d $DOWNLOAD ; then
        mkdir -p $DOWNLOAD
    fi

    display "--------------------------------------------------------------"
    display "Downloading Binutils"
    display "--------------------------------------------------------------"
    display
    $WGET "ftp://anonymous:fireftp@mirrors.kernel.org/gnu/binutils/$FILE_BINUTILS.tar.bz2"


    display "--------------------------------------------------------------"
    display "Downloading GCC"
    display "--------------------------------------------------------------"
    display
    $WGET "ftp://anonymous:fireftp@mirrors.kernel.org/gnu/gcc/$FILE_GCC/$FILE_GCC.tar.bz2"


    display "--------------------------------------------------------------"
    display "Downloading GMP"
    display "--------------------------------------------------------------"
    display
    $WGET "ftp://ftp.gnu.org/gnu/gmp/$FILE_GMP.tar.bz2"


    display "--------------------------------------------------------------"
    display "Downloading MPFR"
    display "--------------------------------------------------------------"
    display
    $WGET "http://www.mpfr.org/mpfr-current/$FILE_MPFR.tar.bz2"


    display "--------------------------------------------------------------"
    display "Downloading AVR-Libc"
    display "--------------------------------------------------------------"
    display
    $WGET "http://mirror.dknss.com/nongnu/avr-libc/$FILE_LIBC.tar.bz2"


    display "--------------------------------------------------------------"
    display "Downloading AVR-Ada"
    display "--------------------------------------------------------------"
    display
    $WGET "http://downloads.sourceforge.net/avr-ada/$FILE_AVRADA.tar.bz2"


    display "--------------------------------------------------------------"
    display "Checking out WinAVR Patches"
    display "--------------------------------------------------------------"
    display
    mkdir -p $WINAVR_DIR
    (cd $WINAVR_DIR/..; cvs -z3 \
	-d:pserver:anonymous@winavr.cvs.sourceforge.net:/cvsroot/winavr co -P patches)

    display "--------------------------------------------------------------"
    display "Checking out AVR-Ada Patches"
    display "--------------------------------------------------------------"
    display
    mkdir -p $AVRADA_DIR
    (cd $AVRADA_DIR/..; svn co \
	http://avr-ada.svn.sourceforge.net/svnroot/avr-ada/trunk/patches)

fi
print_time > $AVR_BUILD/time_run.log

#---------------------------------------------------------------------------

#
# set the list of patches after downloading
#
WINAVR_BIN_PATCHES=`(cd $WINAVR_BIN_DIR; ls -1 [0-9][0-9]-*binutils-*.patch)`
AVRADA_BIN_PATCHES=`(cd $AVRADA_BIN_DIR; ls -1 [0-9][0-9]-*binutils-*.patch)`
BIN_PATCHES=`echo "$WINAVR_BIN_PATCHES $AVRADA_BIN_PATCHES" | sort | uniq`

WINAVR_GCC_PATCHES=`(cd $WINAVR_GCC_DIR; ls -1 [0-9][0-9]-*gcc-*.patch)`
AVRADA_GCC_PATCHES=`(cd $AVRADA_GCC_DIR; ls -1 [0-9][0-9]-*gcc-*.patch)`
GCC_PATCHES=`echo "$WINAVR_GCC_PATCHES $AVRADA_GCC_PATCHES" | sort | uniq`

#---------------------------------------------------------------------------

cd $AVR_BUILD

#---------------------------------------------------------------------------

if test "x$build_binutils" = "xyes" ; then
   #########################################################################
    header "Building Binutils"

    if test "x$no_extract" != "xyes" ; then
        display "Extracting $DOWNLOAD/$FILE_BINUTILS.tar.bz2 ..."
        bunzip2 -c $DOWNLOAD/$FILE_BINUTILS.tar.bz2 | tar xf -
    fi


    if test "x$no_patch" != "xyes" ; then

        display "patching binutils"

        cd $AVR_BUILD/$FILE_BINUTILS
        for p in $BIN_PATCHES; do
            display "   $p"
            if test -f $AVRADA_BIN_DIR/$p ; then
	        # if a patch is part of AVR-Ada -> take it and skip
	        # duplicates from WinAVR
                PDIR=$AVRADA_BIN_DIR
		
            elif test -f $WINAVR_BIN_DIR/$p ; then
	        # else take it from WinAVR
                PDIR=$WINAVR_BIN_DIR
            else
                display "cannot find $p in any of the patch directories"
                exit 2
            fi
            patch --verbose --strip=0 --input=$PDIR/$p  2>&1 >> $AVR_BUILD/build.log
            check_return_code
        done

#         # This copies the new avr-dis.c file to the source
#         # directory to fix a problem with the default use of -Wformat-security 
#         # in Ubuntu 8.10
#         if [ "$VER_BINUTILS" = "2.19" ] ; then
#             if [ "$OS" = "Linux" ] ; then
#                 cp $DOWNLOAD/avr-dis.c $AVR_BUILD/$FILE_BINUTILS/opcodes/avr-dis.c
#             fi
#         fi
    fi

    mkdir $AVR_BUILD/binutils-obj

    cd $AVR_BUILD/binutils-obj

    display "Configure binutils ... (log in $AVR_BUILD/step01_bin_configure.log)"

    if test $OS = "Linux" ; then
        BINUTILS_OPS=
    else
        BINUTILS_OPS=--build=x86-winnt-mingw32
    fi
    ../$FILE_BINUTILS/configure --prefix=$PREFIX \
        --target=avr \
        $BINUTILS_OPS \
        &>$AVR_BUILD/step01_bin_configure.log
    check_return_code


    display "Make binutils ...      (log in $AVR_BUILD/step02_bin_make.log)"

    make &>$AVR_BUILD/step02_bin_make.log
    check_return_code

    display "Install binutils ...   (log in $AVR_BUILD/step03_bin_install.log)"

    make install &>$AVR_BUILD/step03_bin_install.log
    check_return_code
fi

#---------------------------------------------------------------------------

if test "$build_gcc" = "yes" ; then
    #########################################################################
    header "Building gcc cross compiler for AVR"

    cd $AVR_BUILD

    if test "x$no_extract" = "xyes" ; then
        true
        # do nothing
    else
        display "Extracting $DOWNLOAD/$FILE_GCC.tar.bz2 ..."
        bunzip2 -c $DOWNLOAD/$FILE_GCC.tar.bz2 | tar xf -
        bunzip2 -c $DOWNLOAD/$FILE_MPFR.tar.bz2 | \
	    (cd $FILE_GCC; tar xf -; mv $FILE_MPFR mpfr)
        bunzip2 -c $DOWNLOAD/$FILE_GMP.tar.bz2 | \
	    (cd $FILE_GCC; tar xf -; mv $FILE_GMP gmp)
    fi


    if test x$no_patch = "xyes" ; then
        true
        # do nothing
    else
        display "patching gcc"

        cd $AVR_BUILD/$FILE_GCC
        for p in $GCC_PATCHES; do
            display "   $p"
            if test -f $AVRADA_GCC_DIR/$p ; then
                PDIR=$AVRADA_GCC_DIR
            elif test -f $WINAVR_GCC_DIR/$p ; then
                PDIR=$WINAVR_GCC_DIR
            else
                display "cannot find $p in any of the patch directories"
                exit 2
            fi
            patch --verbose --strip=0 --input=$PDIR/$p  2>&1 >> $AVR_BUILD/build.log
            check_return_code
        done
    fi

    mkdir $AVR_BUILD/gcc-obj
    cd $AVR_BUILD/gcc-obj

    display "Configure GCC-AVR ... (log in $AVR_BUILD/step04_gcc_configure.log)"

    echo "AVR-Ada V$VER_AVRADA" > ../$FILE_GCC/gcc/PKGVERSION

    ../$FILE_GCC/configure --prefix=$PREFIX \
        --target=avr \
        --enable-languages=ada,c,c++ \
        --with-dwarf2 \
        --disable-nls \
        --disable-libssp \
        --disable-libada \
        --with-bugurl=http://avr-ada.sourceforge.net \
        &>$AVR_BUILD/step04_gcc_configure.log
    check_return_code

    display "Make GCC ...          (log in $AVR_BUILD/step05_gcc_gcc_obj.log)"

    make &> $AVR_BUILD/step05_gcc_gcc_obj.log
    check_return_code

    display "Install GCC ...       (log in $AVR_BUILD/step08_gcc_install.log)"

    cd $AVR_BUILD/gcc-obj
    make install &>$AVR_BUILD/step08_gcc_install.log
    check_return_code
fi

#---------------------------------------------------------------------------

if test "x$build_libc" = "xyes" ; then
    #########################################################################
    header "Building AVR libc"

    cd $AVR_BUILD

    display "Extracting $DOWNLOAD/$FILE_LIBC.tar.bz2 ..."
    bunzip2 -c $DOWNLOAD/$FILE_LIBC.tar.bz2 | tar xf -

    cd $AVR_BUILD/$FILE_LIBC

    display "configure AVR-LIBC ... (log in $AVR_BUILD/step09_libc_conf.log)"
    CC=avr-gcc ./configure --build=`./config.guess` --host=avr --prefix=$PREFIX &>$AVR_BUILD/step09_libc_conf.log
    check_return_code

    display "Make AVR-LIBC ... (log in $AVR_BUILD/step10_libc_make.log)"
    make &>$AVR_BUILD/step10_libc_make.log
    check_return_code

    display "Install AVR-LIBC ... (log in $AVR_BUILD/step11_libc_install.log)"
    make install &>$AVR_BUILD/step11_libc_install.log
    check_return_code
fi
print_time >> $AVR_BUILD/time_run.log

#---------------------------------------------------------------------------

if test "x$build_avrada" = "xyes" ; then
    #########################################################################
    header "Building AVR-Ada"

    cd $AVR_BUILD

    display "Extracting $DOWNLOAD/$FILE_AVRADA.tar.bz2 ..."
    bunzip2 -c $DOWNLOAD/$FILE_AVRADA.tar.bz2 | tar xf -

    cd $AVR_BUILD/$FILE_AVRADA

    display "configure AVR-Ada ... (log in $AVR_BUILD/step12_avrada_conf.log)"
    ./configure >& ../step12_avrada_conf.log
    check_return_code
    display "build AVR-Ada RTS ... (log in $AVR_BUILD/step13_avrada_rts.log)"
    make build_rts >& ../step13_avrada_rts.log
    check_return_code
    make install_rts >& ../step13_avrada_rts_inst.log
    check_return_code
    display "build AVR-Ada libs ... (log in $AVR_BUILD/step14_avrada_libs.log)"
    make build_libs >& ../step14_avrada_libs.log
    check_return_code
    make install_libs >& ../step14_avrada_libs_inst.log
    check_return_code
fi

cd ..

#########################################################################
header  "Build end"

display
display "Build logs are located in $AVR_BUILD"
display "Programs are in the $PREFIX hierarchy"
display "You may remove $AVR_BUILD directory"

#---------------------------------------------------------------------------
# eof
#---------------------------------------------------------------------------
