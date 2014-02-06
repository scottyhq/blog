title: ROI_PAC ON_MAC
date: 2014-02-06 2:00
tags: ROI_PAC, InSAR, Homebrew
slug: install-roipac-onmac

# ROI_PAC ON_MAC

[ROI_PAC](http://www.openchannelfoundation.org/projects/ROI_PAC) is software for processing Interferometeric Synthetic Aperture Radar (InSAR) data. For general info about InSAR see this. The last major ROI_PAC update was in August 2009, since development focus seems to have moved to [ISCE software](http://esto.nasa.gov/news/news_ISCE_3_2013.html). Nevertheless, it is still widely used and will likely continue to be for some time!

This post walks you through installing an up-to-date version on ROI_PAC on a modern Mac (e.g my Macbook Pro from 2010 w/ OSX 10.9.1). The target audience is people who are familiar with ROI_PAC, but since the software can be acquired for free ( __for research & academic uses__), I hope this will be useful for anyone wanting to try out InSAR processing.

The [ROI_PAC](http://www.roipac.org/Installation) wiki does have some older notes on installation, but the recipe below is more recent. In the end, you'll be set-up to process ERS, Envisat, ALOS, and TSX data. And there are instructions for installing visualization software MDX or Roiview.

## Download the software
From [here](http://www.openchannelfoundation.org/orders/index.php?group_id=282).

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

We'll be using Homebrew again to install stuff if you want to use MDX or Roiview visualization software on the Mac (see post)

