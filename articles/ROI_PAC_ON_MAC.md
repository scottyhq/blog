title: ROI_PAC ON_MAC
date: 2014-02-01 2:00
tags: ROI_PAC, InSAR, Homebrew
slug: install-roipac-mac

{% img /blog/images/hector_mine_roi_pac.jog %}

## What is it?

[ROI_PAC](http://www.openchannelfoundation.org/projects/ROI_PAC) is software for processing Interferometeric Synthetic Aperture Radar (InSAR) data. For general info about InSAR see this. The last major ROI_PAC update was in August 2009, since development focus seems to have moved to [ISCE software](http://esto.nasa.gov/news/news_ISCE_3_2013.html). Nevertheless, it is still widely used and will likely continue to be for some time! 

This post walks you through installing an up-to-date version on ROI_PAC on a modern Mac (e.g my Macbook Pro from 2010 w/ OSX 10.9.1). The target audience is people who are familiar with ROI_PAC, but since the software can be acquired for free ( _for research & academic uses_), I hope this will be useful for anyone wanting to try out InSAR processing. Note that this will get you up and running, but if you're looking for more information on how to use the software I recommend short-courses hosted by [UNAVCO](https://www.unavco.org/edu_outreach/short-courses/2011/insar/insar.html).

The [ROI_PAC](http://www.roipac.org/Installation) wiki does have some older notes on installation, but the recipe below is recent (Feb. 2014). In the end, you'll be set-up to process ERS, Envisat, ALOS, and TSX data. And there are instructions for installing visualization software MDX or Roiview.

## Download the software
From [here](http://www.openchannelfoundation.org/orders/index.php?group_id=282). You should have:
1. ROI_PAC_3_0_1.tar
2. roi_pac_testdir.tar

## Before you begin
Note that _ROI_PAC itself takes up < 100Mb of space_, but _orbit files for ERS and Envisat are ~3Gb_, and _individual interferograms take up 1-10Gb_ depending on the size of data and processing resolution. Point being, make sure you have a spacious drive to work with ROI_PAC.

## Prepare your computer
You're going to need C and Fortran compilers, and some other non-standard libraries. Apple versions of these can be installed from the terminal with:

```
xcode-select --install
```

For non-apple stuff the slickest package manager seems to currently be [Homebrew](http://brew.sh). If you're familiar with Fink and Macports, it is very similar. Install it with:

```
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

Before continuing, I recommend familiarizing yourself with [how Homebrew works](https://github.com/Homebrew/homebrew/wiki). Now you can easily install an up-to-date fortran compiler:

```
brew install gfortran
```

We'll be using Homebrew again to install stuff if you want to use [MDX](roiview_on_mac.md) or [Roiview]({filename}roiview_on_mac.md) visualization software on the Mac. You can now extract the ROI_PAC source and start installing!

```
tar -xvf ROI_PAC_3_0_1.tar
cd /Users/scott/Software/ROI_PAC_3_0_1/ROI_PAC
./contrib/install-fftw.sh
```

Hopefully that succeeds and you can now assign the following environment variables:

```
export FFTW_LIB_DIR=/Users/scott/Software/ROI_PAC_3_0_1/ROI_PAC/NetInst/fftw-140203-1620/lib
export FFTW_INC_DIR=/Users/scott/Software/ROI_PAC_3_0_1/ROI_PAC/NetInst/fftw-140203-1620/include
```

NOTE that `fftw-140203-1620` will change according to todays date and time. Next you compile ROI_PAC. `./contrib/multibuild.sh` is designed to try a whole bunch of compiler options. For mac, we only want to try gfortran, so you can delete the relevant lines at the bottom of `multibuild.sh` or I've posted a copy of the modified file [here]. Now run:

```
./contrib/multibuild.sh
```


You should see this output: `Build >gfortran64< succeeded.` Great! Now make sure you can process data:

```
mkdir test-runs
cd test-runs
../contrib/multitest.sh ../roi_pac_testdir.tar ./multibuild-140203-1629/installs/share/roi_pac/ ./multibuild-140203-1629/installs/gfortran/bin ./multibuild-140203-1629/installs/gfortran64/bin
```

You'll have to change the paths for the `multitest.sh` command. It tries to process test data with each compiled version of ROI_PAC, and it keeps track of how long it takes to run things. `tail -7 */TEST_DIR/batchlog* > summary_log.out` will give you something like the following output:

```
==> gfortran/TEST_DIR/batchlog-140203-1743 <==
+process_2pass.pl That's all folks

real    10m18.709s
user    9m37.598s
sys     0m18.208s
+ date
Mon Feb  3 17:54:42 EST 2014

==> gfortran64/TEST_DIR/batchlog-140203-1946 <==
+process_2pass.pl That's all folks

real    10m34.378s
user    9m57.075s
sys     0m21.314s
+ date
Mon Feb  3 19:57:15 EST 2014
```

You can see that the 32-bit version ran just a bit faster than the 64-bit version. Since software/hardware seems to be moving in the 64 bit direction, we’ll use gfortan64 compiled executables:

```
cd ../
mkdir INT_BIN
cp multibuild-140203-1629/installs/gfortran64/bin/* INT_BIN
```

Finally, edit the configuration file SAR_CONFIG as described here. Or use my copy here as a template. Success! ROI_PAC is now working. But if you want it to be really useful, you have to download precise orbit files and special add-ons for each satellite. The sections below make sure you've got what you need for processing ERS, Envisat, ALOS, and TSX data.

## ERS1 & 2
" **E** uropian **R** emote-Sensing **S** atellite". Details [here](https://earth.esa.int/web/guest/missions/esa-operational-eo-missions/ers). This data is commonly obtained through [EOLi](http://earth.esa.int/EOLi/EOLi.html). Lots of processing tips are on the ROI_PAC wiki [ERS page](http://www.roipac.org/ERS). Usually, you'll want to process data with precise orbit files:

#### PRC Orbits
These are precise orbits Contact the ESA Earth Observation [Help Desk](eohelp@esa.int]) to get the download information. Select OrbitType=PRC to process with these orbits.

#### ODR Orbits 
"Orbital Data Records". Second source of precise orbits from Delft University. Need [getorb](http://www.deos.tudelft.nl/ers/precorbs/tools/getorb/) program installed to use. 
```
tar -xzvf getorb_2.3.2.tar
cd getorb
```

edit the `Makefile` to set `FC=gfortran` and `BIN_DIR=$INT_BIN`, then run:

```
make install
```

Be sure to download the actual orbit files through the Delft Institute for Earth-oriented Space Research (DEOS) [website](http://www.deos.tudelft.nl/ers/precorbs/). In SAR_CONFIG, set `SAR_ODR_DIR=path-to-downloaded-files`. Select OrbitType=ODR to process with these orbits.


#### HDR Orbits
If you don't have PRC or ODR, use the defaults that come with metadata in file headers. Select OrbitType=HDR to process with these orbits.


## Envisat
" **Envi** ronmental **Sat** ellite ". Details [here](https://earth.esa.int/web/guest/missions/esa-operational-eo-missions/envisat). This data is commonly obtained through [EOLi](http://earth.esa.int/EOLi/EOLi.html). Lots of processing notes are on the ROI_PAC wiki [Envisat Page](http://www.roipac.org/Envisat). Similar to ERS, precise orbits can be downloaded via FTP by contacting the ESA Earth Observation [Help Desk](eohelp@esa.int]) to get the download information. Unlike ERS, you *need* to obtain separate orbit files to processes the data:

#### VOR Orbits
In your .proc file, set OrbitType=VOR to process with these orbits.

#### POR Orbits
In your .proc file, set OrbitType=POR to process with these orbits.


## ALOS-1
" **A** danced **L** and **O** observation **S** satellite ". Details here. Data searched for [here](https://auig.eoc.jaxa.jp/auigs/) and obtained [here](https://ursa.asfdaac.alaska.edu/cgi-bin/login/guest/). Lots of processing notes are on the ROI_PAC wiki [Envisat Page](http://www.roipac.org/ALOS_PALSAR). You need scripts to pre-process ALOS data before it is ingested into the ROI_PAC processing chain. Instructions follow:

1. Download an updated [make_raw_alos.pl](http://www.roipac.org/ALOS_PALSAR?action=AttachFile&do=get&target=make_raw_alos.pl) script. And add it to $INT_SCR

2. Download and compile ALOS [pre-processing codes](http://www-rohan.sdsu.edu/~rmellors/RJM_InSAR_software.html) (~28Mb)

```
cd alos_preproc
tar -xvf ALOS_preproc_040910.tar
make
mkdir $INT_BIN/MY_BIN
export $MY_BIN=$INT_BIN/MY_BIN
mv ./bin/i386/* $MY_BIN
```

3. Add $MY_BIN variable to SAR_CONFIG


I've recently created some useful scripts for working with ALOS data which you can find [here](https://github.com/scottyhq/insar_scripts/tree/master/ALOS).


## TerraSAR-X & Tandem-X
Details on the [German Space Agency Website](http://www.dlr.de/dlr/en/desktopdefault.aspx/tabid-10377/565_read-436/#gallery/350). Data can be searched and ordered [here](https://centaurus.caf.dlr.de:8443). Lots of processing notes are on the ROI_PAC wiki [TSX Page](http://www.roipac.org/TSX).You need scripts to pre-process TSX data before it is ingested into the ROI_PAC processing chain. Instructions follow:

On the ROI_PAC wiki you can get a file called sar-0.4.tar.gz [here](http://www.roipac.org/ContribSoftware), which includes C++ parses for several satellites. Alternatively, [tsx_parser.tar.gz](link) contains Python code that is a bit easier to use, which you install in the following way:

```
tar -xzvf tsx_parser.tar.gz
cd tsx_parser/src
make
cd ../
mv src/doppler src/cosar get_height.pl make_slc_tsx.csh $MY_BIN
```


I have some of my own small utilities for working with TSX data posted [here](link-github)