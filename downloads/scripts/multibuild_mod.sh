#!/bin/sh
#
# Script to build ROI_PAC using each Fortran compiler on system.
#
# To use set the following environment variables
#   FFTW_LIB_DIR : to directory containing libfftw3f.a
#   FFTW_INC_DIR : to directory containing fftw3.h
#   configure_path : to path to configure script if not in current directory

# Builds with be placed in directory "multibuild-YYMMDD-HHMM" under current
# directory.

# Note: script runs all the builds as background jobs
#       so this can put a heavy load on your system.
#       Consider reducing build list at bottom.

# This script was original developed when working on ROI_PAC Fortran source
# portability.  But it may be useful to other people who want
# to build ROI_PAC.  Should be able to run it on any system.
# It will try building with lots of different compilers.
# Some will fail.  But helpfully at least one will succeed.

parallel_build=false
if [ "$1" = "-p" ]
then
  parallel_build=true
  shift
fi

if [ $# -gt 0 ]
then
  build_subset=true
  build_list="$*"
  echo "Limiting builds to subset $build_list"
else
  build_subset=false
fi

# try to find configure

# configure_path=/home/bswift/afrl/builddev/ROI_PAC_DIST/ROI_PAC/configure

for try in "$configure_path" configure ../configure `dirname $0`/configure `dirname $0`/../configure
do
  case "$try" in
    /*) # absolut path, do nothing
        ;;
    *)  try=`pwd`/"$try"
        ;;
  esac

  if [ -f "$try" -a -x "$try" ]
  then
    configure_path="$try"
    break
  else
    :
    # echo ">$try< is not configure."
  fi
done
  
if [ -f "$configure_path" -a -x "$configure_path" ]
then
  echo "Will configure using $configure_path"
else
  echo "Could not find executable configure."
  echo "Try setting configure_path environment variable"
  exit 1
fi

# Builds are done in separate subdirectories
# under a "multibuild-{date}" directory.

group_suffix=`date '+%y%m%d-%H%M'`
group_dir=multibuild-$group_suffix

# Specify where to install ROI_PAC
ROI_PREFIX=`pwd`/$group_dir/installs

# Specify where to find FFTW
# FFTW_LIB_DIR=$HOME/afrl/builddev/NetInst/fftw-3.0.1,absoft_f95/lib
# FFTW_INC_DIR=$HOME/afrl/builddev/NetInst/fftw-3.0.1,absoft_f95/include

if [ ! -f ${FFTW_LIB_DIR}/libfftw3f.a ]
then
  echo "FFTW_LIB_DIR needs to be set to directory containing libfftw3f.a"
  exit 1
fi

if [ ! -f ${FFTW_INC_DIR}/fftw3.h ]
then
  echo "FFTW_INC_DIR needs to be set to directory containing fftw3.h"
  exit 1
fi

# Special non-space character used as IFS separator to allow parameters
# which have values that are space separated lists to
# be passed to configure
sep='#'

#common_options="LDFLAGS=-L/home/bswift/afrl/builddev/NetInst/fftw-3.0.1,absoft_f95/lib${sep}CPPFLAGS=-I/home/bswift/afrl/builddev/NetInst/fftw-3.0.1,absoft_f95/include"
common_options="LDFLAGS=-L${FFTW_LIB_DIR}${sep}CPPFLAGS=-I${FFTW_INC_DIR}"

# echo $common_options

mkdir $group_dir
if cd $group_dir  ; then
  echo "Doing builds in $group_dir"
else
  echo "cd $group_dir failed.  Exiting..." 1>&2
  exit 1
fi

# gmake doesn't work, default to make
make=gmake
if $make -v -f /dev/null > /dev/null 2>&1
then
   :
else
   make=make
fi
# Set make to false to just run configure without doing builds
# make=false

echo "common_options are >$common_options<"
echo "installation directory is $ROI_PREFIX"

echo " "
echo "DON'T PANIC!"
echo "  Failed builds are expected for compilers you do not have installed."

while read build_name build_options
do
  if $build_subset
  then
     do_build=false
     for check_build in $build_list
     do
        if [ $check_build = $build_name ]
        then
          do_build=true
        fi
     done
  else
     do_build=true
  fi

  if $do_build
  then
     echo "Starting >$build_name< build with options >$build_options<"
     ( 
       ( set -x
         mkdir $build_name
	 IFS=${sep}
	 cd $build_name && \
	   # was ../../configure
	   ${configure_path} $build_options $common_options \
	   --prefix=$ROI_PREFIX --exec-prefix=$ROI_PREFIX/$build_name && \
	     $make install
       ) >${build_name}-build-log 2>&1
       if [ -x $ROI_PREFIX/$build_name/bin/sch_to_dem ]
       then
	 echo "   Build >$build_name< succeeded."
       else
	 echo "   Build >$build_name< failed.     See $group_dir/${build_name}-build-log"
       fi
     ) </dev/null &
     if $parallel_build
     then
       :
     else
       wait
     fi
  else
     echo "  Skipped >$build_name< because not listed on command line."
  fi
# Deleted most compiler options irrelevant to MacOSX -SH
done <<EOF
gfortran FC=gfortran${sep}FCFLAGS=-O2
gfortran64 FC=gfortran${sep}FCFLAGS=-O2 -m64${sep}CC=cc${sep}CFLAGS=-O2 -m64
EOF

# NOTE: build_names in first column above must be unique

# Notes on above buid_names

# defaults: Is a build with whatever 'configure' picks.
#    This allows builder to specify custom options via environment variables.
#   '-verbose' is just an option that will be ignored by configure
#   rather than an empty-string parameter which is not ignored.

# f90cc: Is for Sun and SGI using native compilers

# f90nc: for Sun Solaris compiler on SunFire added EJF 2006/8/11

# *FFT*: Builds with NATIVE FFT routines
#    Will use default compilers found by configure.
#    (except on Sun which forces use of 'cc' so -lsunperf will be found.)
#    Can override by setting FC and CC environment variables.

#    *FFT* lines should not be needed if more work was put into
#    configure.  But ran out of time, so just try them all and
#    see if any work.

#    (SGI -lscs) -DHAVE_CCFFT
#    (SGI -lcomplib.sgimath) -DHAVE_CFFT1D
#    (SUN -lsunperf) -DHAVE_CFFTF
#    (HP  -lveclib) -DHAVE_C1DFFT

# CFFTF: -xvector=no is because of bug in compiler
#    which causes compiler segfault when compiling LIB/src/svd.f
#    using "-fast" optimizations.
#    System Information where problem occured:
#      f95 -V
#        f95: Sun WorkShop 6 update 2 Fortran 95 6.2 2001/05/15
#      uname -a
#        SunOS fugue 5.9 Generic_118558-09 sun4u sparc SUNW,Ultra-Enterprise
#    Getting a "Floating exception" running 
#      "ampcor 930110-950523_ampcor_gross.in rdf"
#      Tried lowering optimization level to
#        CFFTF    FCFLAGS=-O2 -DHAVE_CFFTF${sep}LIBS=-lsunperf${sep}--without-fftw${sep}CC=cc${sep}CFLAGS=-xO2
#      but still got core dump.  Needs further investigation.

# CFFT1D
#    Tried this higher optimization level on SGI.  However, it resulted
#    in a "PAUSE no convergence in svdcmp" while running resamp.
# 
#      CFFT1D   FCFLAGS=-Ofast -DHAVE_CFFT1D${sep}LIBS=-lcomplib.sgimath${sep}--without-fftw${sep}CC=cc${sep}CFLAGS=-Ofast


# gfortran:  Build will not complete until bug 20811 is fixed.

# gfortran64: added to force 64-bit compilation option in gfortran

# This is the group used for initial testing and cross comparisons on Linux.
# The additional fortran compiler flags are intended to produce
# more numerically consistent results.
#
# ifort    FC=ifort${sep}FCFLAGS=-O2 -fp_port
# g95      FC=g95${sep}FCFLAGS=-O2 -ffloat-store
# f95      FC=f95${sep}FCFLAGS=-O2 +B41
# pgf95    FC=pgf95${sep}FCFLAGS=-O2 -Kieee


echo " "
echo "Be patient waiting for some builds to succeed."
echo " "

wait


good_builds_file=/tmp/good_builds.$$
ls -1 $ROI_PREFIX/*/bin/sch_to_dem >$good_builds_file 2>/dev/null
# sch_to_dem is currently last application built
if [ `wc -l $good_builds_file | sed 's/  *[^ ]*$//'` -eq 0 ]
then
   echo "No builds completed.  Check the build-log files mentioned above."
else

   echo " "
   echo "Fully completed build binaries are in:"


   < $good_builds_file xargs -n 1 dirname

   echo " "
   echo " Perl scripts (which are common to all sets of binaries) are in:"
   echo "   $ROI_PREFIX/share/roi_pac"

   echo " "
   echo "See README_ROI_BUILD for information on how to run" 
   echo "  contrib/multitest.sh"
   echo "to do test runs using data from TEST_DIR.tar"
#   echo "To run ROI_PAC"
#   echo "  setenv INT_BIN to one of the above directories"
#   echo "  setenv INT_SCR  $ROI_PREFIX/share/roi_pac"
#   echo '  setenv PATH  ${INT_BIN}:${INT_SCR}:${PATH}'
#   echo " "
#   echo "If you are running with the TEST_DIR dataset (on a big-endian computer)"
#   echo "  cd TEST_DIR"
#   echo '  setenv testrun_dir `pwd`'
#   echo '  echo "DEM=$testrun_dir/DEM/SoCal.dem" >>$testrun_dir/int.proc'
#   echo '  setenv  SAR_PRC_DIR "$testrun_dir/PRC"'
#   echo '  setenv  SAR_ODR_DIR "$testrun_dir/ERS/Delft"'

#   echo "This setup is normaly handeled in your SAR_CONFIG script."
fi
rm $good_builds_file
