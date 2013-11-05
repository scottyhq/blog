#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
import os

AUTHOR = u'Scott Henderson'
SITENAME = u'Geophysics Notes'
SITESUBTITLE = u'' #I don't like subtitles
SITEURL = '' #change in publishconf.py

#THEME = '/Users/scott/Web/pelican-themes/iris'
THEME = '/Users/scott/Web/pelican-themes/pelican-octopress-theme'

# Time and Date
TIMEZONE = 'US/Eastern'
DEFAULT_DATE_FORMAT = '%b %d, %Y'

# Set the article URL
ARTICLE_URL = '{date:%Y}/{date:%m}/{date:%d}/{slug}/'
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'


# Title menu options - note in order
DISPLAY_PAGES_ON_MENU = True
MENUITEMS = [('Archives', '/blog/archives.html'), # not even if SITEURL = 'https://scottyhq.github.io/blog/', need to preprend 'blog here' and with liquid tags for absolute paths...
		#('About', '/about.html'), #appears automatically with DISPLAY_PAGES_ON_MENU = True
		('Home Page', 'http://www.geo.cornell.edu/eas/gstudent/sth54/')] #https://github.com/scottyhq/scottyhq.github.io
NEWEST_FIRST_ARCHIVES = False

#Github links on sidebar
GITHUB_USER = 'scottyhq'
GITHUB_REPO_COUNT = 3
GITHUB_SKIP_FORK = True
GITHUB_SHOW_USER_LINK = True

DEFAULT_LANG = u'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None

# Blogroll - a bunch of links
#LINKS =  (('Pelican', 'http://getpelican.com/'),
#          ('Python.org', 'http://python.org/'),
#          ('Jinja2', 'http://jinja.pocoo.org/'),
#          ('You can modify those links in your config file', '#'),)

# Social widget
#SOCIAL = (('You can add links in your config file', '#'),
#          ('Another social link', '#'),)

DEFAULT_PAGINATION = 10


# Website source directory structure
STATIC_PATHS = ['articles','pages','images', 'figures', 'downloads', 'favicon.ico']
CODE_DIR = 'downloads/code'
NOTEBOOK_DIR = 'downloads/notebooks'


PLUGIN_PATH = '../pelican-plugins'
PLUGINS = ['summary', 'liquid_tags.img', 'liquid_tags.video', 'liquid_tags.include_code', 'liquid_tags.notebook','liquid_tags.literal']

# The theme file should be updated so that the base header contains the line:
#
#  {% if EXTRA_HEADER %}
#    {{ EXTRA_HEADER }}
#  {% endif %}
# 
# This header file is automatically generated by the notebook plugin
if not os.path.exists('_nb_header.html'):
	import warnings
	warnings.warn("_nb_header.html not found.  "
				  "Rerun make html to finalize build.")
else:
	EXTRA_HEADER = open('_nb_header.html').read().decode('utf-8')


# Search - need to update theme to include it!
SEARCH_BOX=True

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True
