title: Obtaining DEMS for ROI_PAC
date: 2014-04-29 5:00
tags: ROI_PAC, InSAR, DEM, GDAL
slug: get-roipac-dem

{% img /blog/images/anatahan_v2_30m.jpg %}

# Obtaining Digital Elevation Data for ROI_PAC

This post and compares variou DEM sources and provides from useful scripts for ROI_PAC. ROI_PAC processing is typically done with an SRTM digital elevation model (DEM). The [SRTM mission](http://en.wikipedia.org/wiki/Shuttle_Radar_Topography_Mission) was flown on the space shuttle Endeavor 02/2000 and in a mere 11 days acquired data to map elevations between 56S to 60N. 

The data is freely available at 30m resolution for US territory and 90m for the rest of the world. It can be obtained from a variety of sources (e.g. [NASA/USGS LPDAAC](https://lpdaac.usgs.gov),[CGIAR](http://www.cgiar-csi.org/data/srtm-90m-digital-elevation-database-v4-1) at various levels of processing and quality control. The [get_SRTM.pl](http://roipac.org/cgi-bin/moin.cgi/ContribSoftware) fetches SRTM with voids from [USGS server](http://dds.cr.usgs.gov/). For example, to obtain a DEM for [Anatahan Volcano](http://www.volcano.si.edu/volcano.cfm?vn=284200) in the South Pacific (16.35N, 145.67E) is easy:

```
get_SRTM.pl anatahan.dem 16 17 145 146 1 3
```

The 1 indicates to swap-bytes since SRTM data is processed as 'big-endian' and most machines are 'little-endian' and the 3 indicates 90m SRTM data (use 1 if fetching higher resolution data over the US).

I've updated the script to obtain void-filled SRTM data from LPDAAC available [here}(link to github). The usage is identical:

```
get_SRTM3.pl anatahan.dem 16 17 145 146 1 3
```

## Visualizing the DEM

You should now have the files  `anatahan.dem` and `anatahan.dem.rsc`. The rsc file contains georeferencing information, but the uncommon format isn't recognized by GIS software (e.g. [QGIS](http://www.qgis.org/en/site/). Here is a [simple script](github/dem2envi.py) to take the georeferencing information from the rsc file and create a standard [ENVI header](http://www.exelisvis.com/docs/ENVIHeaderFiles.html).

```
dem2envi.py anatahan.dem
```

Which outputs the header file `anatahan.dem.hdr`. Now it's eay to take advatange of [GDAL](http://www.gdal.org) or [GMT](http://gmt.soest.hawaii.edu) command line utilities. For example, you can easily upsample the SRTM data to 30m resolution

```
gdalwarp -tr 0.000277777 0.000277777 -r bilinear anatahan.dem anatahan_30m.tif
```

And quickly make a shaded relief image

``` 
gdaldem hillshade anatahan_30m.tif anatahan_30m_shade.tif
```

And easily import the imagery into google earth

```
gdal_translate -of KMLSUPEROVERLAY anatahan_30m_shade.tif anatahan_30m_shade.kmz
```

## Comparison of SRTM v2, v3 and GDEM

The kmz files provide a convenient way to qualitatively compare the dems. Take a look at the following series of images for Anatahan:


{% img /blog/images/anatahan_imagery.jpg %}

The google earth imagery shows the rugged relief at Anatahan.


{% img /blog/images/anatahan_v2.jpg %}

The version 2 SRTM data has a native resolution of 90m, which claearly doesn't do the volcano justice. Also notice the presence of voids, common in areas of high relief. 

{% img /blog/images/anatahan_v2_30m.jpg %}

Version 2 after upsampling to 30m resolution. The terrain is clearer, so are the voids. When processing InSAR data over such a small area, it would be nice to get rid of those, which is where the void-filled SRTM comes in:

{% img /blog/images/anatahan_v3.jpg %}

Notice the voids are gone, but we again have to upsample


{% img /blog/images/anatahan_v3_90m.jpg %}

Much better. Voids are gone, and relief matches up with google earth imagery quite well. Time to use with ROI_PAC! There is just one last step, you have to create a new rsc file that matches the georeferencing information in the upsampled data.

In reality any DEM can be used in processing as long as it's in the correct format and has an .rsc file to go with it. For example, the [ASTER GDEM version 2](https://lpdaac.usgs.gov/products/aster_products_table/astgtm) was released 10/2011 and promises native 30m resolution. It is freely available from [NASA REVEB](http://reverb.echo.nasa.gov/reverb/). Unfortunately, data accuracy is [still suspect](http://www.viewfinderpanoramas.org/reviews.html#aster) since inaccuracies due to clouds and other issues exist. Let's see how the GDEM2 looks for Anatahan:

{% img /blog/images/anatahan_gdem.jpg %}

As you can see, the data has an artifical 'bumpiness' to it, and some other spurious features (e.g. a large bump in the north of the island presumably due to a cloud artifact.


## Other Data Sources

Here are a few other interesting sources for elevation data:

* [Open Topography](http://www.opentopography.org) You can get extremely high resolution [LiDAR](http://en.wikipedia.org/wiki/Lidar) here!

* [Viewfinder Panoramas](http://www.viewfinderpanoramas.org) An excellent resource for assessing freely available digital elevation models in detail, and also obtaining 90m elevation data outside of the SRTM vcoverage zone

* [WorldDEM](http://www.astrium-geo.com/worlddem/) The TanDEM-X mission is currently compiling an X-band DEM, which promises 12mx12m horizontal resolution and 4m absolute vertical accuracy with pole-to-pole coverage. This is exciting! But unfortunately, you'll have to pay, and most areas won't be available for years to come.


## Conclusion

For the time being, SRTM Plus (version 3) is the go-to, freely available digital elevation model for ROI_PAC processing.


