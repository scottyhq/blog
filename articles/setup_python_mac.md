title: Setting up Python for Scientific Computing on a Mac
date: 2013-11-10 12:00
tags: mac,osx,python,science
slug: setup-python-mac


The posts on this website are mostly related to my work as graduate student in geophysics. I was looking for a medium to easily keep records of my work and share computer code with colleagues, and naturally have settled into a combination of [Github](https://github.com/) and this weblog (which coincidentally is [hosted by Github](http://pages.github.com)). Since computers permeate all fields of science these days, I hope that the material I post here will be interesting and useful not just to geophysicists, but to many!

In my daily work I use a 2010 Macbook Pro running OSX 10.9 and a Linux Desktop running [Ubuntu](http://www.ubuntu.com) 13.04 (raring). The following recommendations are getting up and running with Python on a Mac.


## Why use Python?
Python is a fantastic language for scientific computing! Here are some specific reasons why you might consider using it: 

**high-level interpreted language**. What does that mean? It means the syntax is easy to read, and you can run code in a terminal window without pre-compiling! This is a huge advantage to languages like C and Fortran, which while fast, are *a pain to compile and debug*. 

**very versatile**. I use Python to do numerical calculations, write file system scripts that require string processing, and publish this website! Imagine trying to do all this with Matlab or C...

I was convinced by those two points, but there are many other people out there who have put even more thought into convincing scientists to use Python:

* [pythonforscientists](https://sites.google.com/site/pythonforscientists/)

* [scientific computing with python notebook](http://nbviewer.ipython.org/urls/raw.github.com/jrjohansson/scientific-python-lectures/master/Lecture-0-Scientific-Computing-with-Python.ipynb)

* [whypython?](http://www.stat.washington.edu/~hoytak/blog/whypython.html)


## Obtaining Python
If you have a Mac, you have Python already! It's accessible from the Terminal App type `usr/bin/python`. However, it's advisable to install another copy so as to not mess up Mac OSX in any way. Also, the system Python is a minimal distribution that's missing a lot of essential libraries for scientific computing. 

There are a bunch of different ways to install full-featured Python. The most painless way is to utilize Enthought's pre-packaged [Canopy distribution](https://www.enthought.com/products/canopy/). It includes a minimal Matlab-like interface with a combined text editor and Python prompt, in addition to a very easy-to-use package management system. It's *free for academic users*, and they also have a free version with limited access to non standard Python libraries. 

There are other options as well. I've tried [Active Python](http://www.activestate.com/activepython) in the past, but I really like Canopy. You can also check out the main Python page, which has an extensive list of [installation options](http://www.python.org/getit/). For now, I recommend installing Python 2, since many libraries are still not compatible with the newer Python 3 series. See [this article](http://jakevdp.github.io/blog/2013/01/03/will-scientists-ever-move-to-python-3/) for more info on Python 2 versus 3.

## Recommended Text Editors
Python comes standard with [IDLE](http://docs.python.org/2/library/idle.html), a very basic code editor. Also, if you download Canopy, its [built-in editor](http://docs.enthought.com/canopy/quick-start/code_editor.html) is pretty convenient. I find myself using several different editors day to day. Everyone has their favorites, and mine happen to be:

* [vi](http://www.vim.org): The standard command line editor. You may need to enable syntax highlighting and tab-preference on your Mac:
		
		vi ~/.vimrc
		syntax on
		set ts=4	

* [Komodo Edit](http://www.activestate.com/komodo-edit): The myriad features seem like overkill sometimes, but some of them are handy
* [iA writer](http://www.iawriter.com/mac/): I'm writing this document with iA writer. It's *fantastic* for simple stuff and webpages written in [Markdown](http://daringfireball.net/projects/markdown/)... but it's not free :( 

## Useful Python references
I've been using Python for 5 years now, and I have loved using it every step of the way! My first job involved creating some simple graphical user interfaces with Python, in which I heavily relied on these two books:

* [Python Cookbook](http://www.amazon.com/Python-Cookbook-David-Beazley/dp/1449340377/ref=sr_1_1?ie=UTF8&qid=1384231118&sr=8-1&keywords=python+cookbook)
* [Python Scripting for Computational Science](http://www.amazon.com/Python-Scripting-Computational-Science-Engineering/dp/3540739157/ref=sr_1_2?ie=UTF8&qid=1384231180&sr=8-2&keywords=scientific+computing+python)

Of course, there are tons of tutorials on the web! I recommend learning by example with iPython notebooks. The notebook is very intuitive, but I definitely benefitted from watching some [video tutorials](http://ipython.org/videos.html) by the developers of iPython. Otherwise you can get your hands dirty with [official examples](https://github.com/ipython/ipython/tree/master/examples/notebooks#a-collection-of-notebooks-for-using-ipython-effectively) or lots of other interesting examples in this [gallery](https://github.com/ipython/ipython/wiki/A-gallery-of-interesting-IPython-Notebooks). 

## Why to consider using Github
I didn't know what Github was until this year. But I started noticing a lot of software I used was 'moving to Github' (e.g. [iPython](https://github.com/ipython/ipython), [Pylith](https://github.com/geodynamics/pylith)). I quickly learned that it is a relatively new (est. 2008) website based around the Linux version control utility, `git`, which has been around for decades! So why is this website getting so much buzz? **It is a great tool for collaborative software development that encourages and facilitates writing well-documented open software.** 

I've always postponed learning version control software (e.g. `svn`) because it seemed complicated and tedious for the mostly small programs I write. However, I've learned over the years that these small programs can get quite big before you know it! And even small programs deserve clear commenting and accessibility. This goes beyond good etiquette, it is critical to reproducible science in the digital age! Per usual, there are some people that have beaten me to this realization, but on the bright side, I can stop writing and refer you their work:

* [Version Control for fun and profit](http://nbviewer.ipython.org/urls/github.com/fperez/reprosw/raw/master/Version%2520Control.ipynb) has useful info and links, including:
	* [Git for Scientists](http://nyuccl.org/pages/GitTutorial/) 
	* [Revision Control Software](http://nbviewer.ipython.org/urls/raw.github.com/jrjohansson/scientific-python-lectures/master/Lecture-7-Revision-Control-Software.ipynb)
		* which is Part of an [entire set of iPython notebooks in scientific computing](https://github.com/jrjohansson/scientific-python-lectures)!
