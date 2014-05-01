title: Obtaining DEMs for ROI_PAC
date: 2014-04-29 5:00
tags: ROI_PAC, InSAR, DEM, GDAL
slug: get-roipac-dem

{i img /blog/images/anatahan_v2_30m.jpg %}

<!-- # Obtaining Digital Elevation Data for ROI_PAC -->

This post and compares various Digital Elevation Model (DEM) sources and provides from useful scripts for working with ROI_PAC. ROI_PAC processing is typically done with SRTM DEM. The [SRTM mission](http://en.wikipedia.org/wiki/Shuttle_Radar_Topography_Mission) was flown on the space shuttle Endeavor 02/2000 and in a mere 11 days acquired data to map elevations between 56S to 60N! 

The data is freely available at 30m resolution for US territory and 90m for the rest of the world. It can be obtained from a variety of sources (e.g. [NASA/USGS LPDAAC](https://lpdaac.usgs.gov), [CGIAR](http://www.cgiar-csi.org/data/srtm-90m-digital-elevation-database-v4-1) at various levels of processing and quality control. The [get_SRTM.pl](http://roipac.org/cgi-bin/moin.cgi/ContribSoftware) script with ROI_PAC fetches SRTM data with voids from this [USGS server](http://dds.cr.usgs.gov/). For example, it's easy to obtain a DEM for [Anatahan Volcano](http://www.volcano.si.edu/volcano.cfm?vn=284200) in the South Pacific (16.35N, 145.67E):
```
get_SRTM.pl anatahan.dem 16 17 145 146 1 3
```

The 1 indicates to swap byte order since SRTM data is processed as 'big-endian' and most machines are 'little-endian' and the 3 indicates 90m SRTM data (use 1 if fetching higher resolution data over the US). You'll have to compile the [byte-swap](https://github.com/scottyhq/insar_scripts/DEM/byte-swap.c) C program and put it in the ROI_PAC path:

```
gcc -o byte-swap byte-swap.c
```

I've modified the get_SRTM.pl script to obtain void-filled SRTM data (version 3, or "SRTM PLUS") from LPDAAC available since 11/2013. Download it [here](https://github.com/scottyhq/insar_scripts/DEM/get_SRTM3.pl) The usage is identical:

```
get_SRTM3.pl anatahan.dem 16 17 145 146 1 3
```

## Visualizing the DEM

You should now have the files  `anatahan.dem` and `anatahan.dem.rsc`. The rsc file contains georeferencing information, but the uncommon format isn't recognized by GIS software (e.g. [QGIS](http://www.qgis.org/en/site/). Here is a [simple script](github/dem2envi.py) to take the georeferencing information from the rsc file and create a standard [ENVI header](http://www.exelisvis.com/docs/ENVIHeaderFiles.html):

```
dem2envi.py anatahan.dem
```

Which outputs the header file `anatahan.dem.hdr`. Now it's eay to take advatange of [GDAL](http://www.gdal.org) or [GMT](http://gmt.soest.hawaii.edu) command line utilities. For example, you can easily upsample the SRTM data to 30m resolution:

```
gdalwarp -tr 0.000277777 0.000277777 -r bilinear anatahan.dem anatahan_30m.tif
```

And quickly make a shaded relief image:

``` 
gdaldem hillshade -s 111120 -compute_edges anatahan_30m.tif anatahan_30m_shade.tif
```

And easily import the imagery into google earth:

```
gdal_translate -of KMLSUPEROVERLAY anatahan_30m_shade.tif anatahan_30m_shade.kmz
```

## Comparison of SRTM v2, v3 and GDEM

The kmz files provide a convenient way to qualitatively compare the dems. Take a look at the following series of images for Anatahan:


{% img /blog/images/anatahan_imagery.jpg %}

The google earth imagery above shows the rugged relief at Anatahan.


{% img /blog/images/anatahan_v2.jpg %}

SRTM version 2 data has a native resolution of 90m, which clearly doesn't do the volcano justice. Also notice the presence of voids, common in areas of high relief. 

{% img /blog/images/anatahan_v2_30m.jpg %}

SRTM version 2 after upsampling to 30m resolution. The terrain is clearer, so are the voids. When processing InSAR data over such a small area, it would be nice to get rid of those! 

{% img /blog/images/anatahan_v3.jpg %}

SRTM Plus (version 3). Notice the voids are gone, but we again should upsample the data for higher resolution InSAR processing.


{% img /blog/images/anatahan_v3_30m.jpg %}

Much better! SRTM Plus upsampled to 30m resolution.  Voids are gone, and relief matches up with Google Earth imagery quite well. To use this upsampled data with ROI_PAC you have to ensure it's in the correct binary format and create a new rsc file that matches the georeferencing information in the upsampled data. The following GDAL commands will do:

```
gdal_translate -of ENVI -ot Int16 anatahan_30m.tif anatahan_30m.dem
gdalinfo anatahan_30m.dem
```

`gdalinfo` produces the following output:

```
Driver: ENVI/ENVI .hdr Labelled
Files: anatahan_30m.dem
       anatahan_30m.dem.aux.xml
       anatahan_30m.hdr
Size is 3600, 3600
Coordinate System is:
GEOGCS["GCS_WGS_1984",
    DATUM["WGS_1984",
        SPHEROID["WGS_84",6378137,298.257223563]],
    PRIMEM["Greenwich",0],
    UNIT["Degree",0.017453292519943295]]
Origin = (145.000000000000000,17.000000000000000)
Pixel Size = (0.000277777000000,-0.000277777000000)
Metadata:
  AREA_OR_POINT=Area
  Band_1=Band 1
Image Structure Metadata:
  INTERLEAVE=BAND
Corner Coordinates:
Upper Left  ( 145.0000000,  17.0000000) (145d 0' 0.00"E, 17d 0' 0.00"N)
Lower Left  ( 145.0000000,  16.0000028) (145d 0' 0.00"E, 16d 0' 0.01"N)
Upper Right ( 145.9999972,  17.0000000) (145d59'59.99"E, 17d 0' 0.00"N)
Lower Right ( 145.9999972,  16.0000028) (145d59'59.99"E, 16d 0' 0.01"N)
Center      ( 145.4999986,  16.5000014) (145d29'59.99"E, 16d30' 0.01"N)
Band 1 Block=3600x1 Type=Int16, ColorInterp=Undefined
  Description = Band 1
```

From which you can create the necessary `anatahan_30m.dem.rsc` (or write a script to do this!):

```
WIDTH                                    3600                          
FILE_LENGTH                              3600                          
X_STEP                                   0.000277777              
Y_STEP                                   -0.000277777             
X_FIRST                                  145                           
Y_FIRST                                  17                            
X_UNIT                                   degres                        
Y_UNIT                                   degres                        
Z_OFFSET                                 0                             
Z_SCALE                                  1                             
PROJECTION                               LATLON 
```

## Other DEM Sources

In reality any DEM can be used in processing as long as it's in the correct format and has an .rsc file to go with it. For example, the [ASTER GDEM version 2](https://lpdaac.usgs.gov/products/aster_products_table/astgtm) was released 10/2011 and promises native 30m resolution. It is freely available from [NASA REVEB](http://reverb.echo.nasa.gov/reverb/). Unfortunately, data accuracy is [still suspect](http://www.viewfinderpanoramas.org/reviews.html#aster) since inaccuracies due to clouds and other issues exist. Let's see how the GDEM2 looks for Anatahan:

{% img /blog/images/anatahan_gdem.jpg %}

As you can see, the data has an artifical 'bumpiness' to it, and some other spurious features (e.g. a large bump in the northwest is presumably due to a cloud artifact.

Here are a few other interesting sources for elevation data:

* [Open Topography](http://www.opentopography.org) You can get extremely high resolution [LiDAR](http://en.wikipedia.org/wiki/Lidar) here!

* [Viewfinder Panoramas](http://www.viewfinderpanoramas.org) An excellent resource for assessing freely available digital elevation models in detail, and also obtaining 90m elevation data outside of the SRTM coverage zone.

* [WorldDEM](http://www.astrium-geo.com/worlddem/) The TanDEM-X mission is currently compiling an X-band DEM, which promises 12mx12m horizontal resolution and 4m absolute vertical accuracy with pole-to-pole coverage. This is exciting! But unfortunately, you'll have to pay, and most areas won't be available for years to come.


## Conclusion

For the time being, SRTM Plus (version 3) is the go-to, freely available digital elevation model for ROI_PAC processing.


