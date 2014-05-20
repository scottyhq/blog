title: Roiview on Mac
date: 2014-02-06 4:00
tags: ROI_PAC, InSAR, MDX, Roiview
slug: install-roiview-mac

{% img /blog/images/roiview_mac.png %}

## Visualizing ROI_PAC Output

ROI_PAC outputs many images files in a few different binary formats ([install ROI_PAC post]({filename}ROI_PAC_ON_MAC.md)]). You can view these files [many ways](http://aws.roipac.org/cgi-bin/moin.cgi/Viewing_results/), bust there are two programs designed specifically with ROI_PAC in mind: [MDX](http://winsar.unavco.org/isce.html) and [Roiview](http://roiview.sourceforge.net). Since MDX is standard, I've described installing it on Mac in [this post]({filename}mdx_on_mac.md). 

Here I go over installing the alternative Roiview. I haven't used it much, but it seems like Roiview is an excellent free alternative to MDX. Getting it to run on a Mac takes a little fiddling. Fortunately it's not too hard!

## Homebrew installation recipe

Roiview is coded in Python, so it is effectively cross-platform. But it utilizes linux-based GUI libraries that are not part of the standard Mac operating system. So the easiest way to install a functioning version of Python that can utilize these libraries is with [Homebrew]((http://brew.sh)). Here are the lines you need to run:

```
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew doctor
```

This installs home-brew and checks to make sure you're system is ready to install homebrew packages.

Now you have to access additional packages repositories to get required python packages

```
brew tap homebrew/python
brew tap homebrew/science
brew tap homebrew/dupes
```

Then install python. Some python package dependencies aren't available through the home-brew repositories, so you have to install them with pip:

```
brew install python
pip install --upgrade setuptools
pip install --upgrade pip

pip install nose
pip install python-dateutil
pip install pyparsing
brew install numpy
brew install pygtk —-glade
brew install matplotlib --with-pygtk
```

The GTK and Glade stuff relates to the libraries required for Roiview to work. Now you can run Roiview! For example (Picture Here):

## Notes

Roiview was last updated in 2010, so I've noticed that sometimes it doesn't work well with newer python packages. According to the README file it is tested with tested with: 

* python 2.6
* numpy 1.3.0
* matplotlib 0.99.1

So you can either look into installing these packages specifically (probably matplotlib 0.99.1 is the only one that matters). Or fiddling with the source code so that it runs with new syntax. For example I had to change the following line 601 in roiviewdata.py:

```python
#cb = self.V['im'].colorbar[0]
cb = self.V['im'].colorbar #SH
```

There may be lots of other issues, so no guarantees....
