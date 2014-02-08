title: Install MDX on Mac
date: 2014-02-03 5:00
tags: ROI_PAC, InSAR, MDX, Roiview
slug: install-mdx-mac

{% img /blog/images/mdx_mac.png %}

[MDX](http://roipac.org/Viewing_results#head-5b86fe6df122f36c359afab0b01792d812664bfa) is the go-to visualization software for ROI_PAC files, and this post explains how to get it working on a Mac. You can see about installing alternative software on [this post]({filename}roiview_on_mac.md)

MDX is tricky to obtain,,, [here is one place](http://winsar.unavco.org/isce.html). 

You'll need some dated open motif libraries to run it. Fortunately, with Homebrew (see previous post), it's not hard to get it working on a Mac:

```
brew install lesstif
```

Assuming you have obtained `mdx_190_79_03.tar`

```
tar -xzf mdx_190_79_03.tar
cd mdx_190_79_03
```
Change the following two lines in Makemdx_gfortran:

```
XINC = -I/usr/X11R6/include/ -I/opt/X11/include/
XLIB = -L/opt/X11/lib  -lXm -L/usr/X11R6/lib -lXt -lX11
```

And run:

``` 
make -f Makemdx_gfortran
```

Now just add the MDX environment variable to SAR_CONFIG and system PATH (e.g. `export PATH=/Users/scott/Software/mdx_190_79_03/mdx:$PATH`). Assuming you have the ROI_PAC test data, you can see an image with the following command. More details on using MDX are [here](http://roipac.org/Viewing_results#head-5b86fe6df122f36c359afab0b01792d812664bfa).