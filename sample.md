Sample
================
CDL - Jeeno
March 21, 2022

## Introduction

This is an AHP for mapping the flood prone areas in Assam.

We are going to use the following libraries:

``` r
packages <- c("terra", "raster", "sp", "sf", "tidyr", "rgdal", "dplyr", "tidyverse")
```

and load the data we have already prepared.

``` r
R_15 <- rast('rainfall_2015.tif')
R_16 <- rast('rainfall_2016.tif')
R_17 <- rast('rainfall_2017.tif')
R_18 <- rast('rainfall_2018.tif')
R_19 <- rast('rainfall_2019.tif')
R_20 <- rast('rainfall_2020.tif')
R_21 <- rast('rainfall_2021.tif')
```

## Calculating and plotting mean annual rainfall

``` r
rainfall <- c(R_15, R_16, R_17, R_18, R_19, R_20, R_21)
R_mean <- mean(R_15, R_16, R_17, R_18, R_19, R_20, R_21)
R_mean
```

    ## class       : SpatRaster 
    ## dimensions  : 129, 135, 1  (nrow, ncol, nlyr)
    ## resolution  : 0.25, 0.25  (x, y)
    ## extent      : 66.375, 100.125, 6.375, 38.625  (xmin, xmax, ymin, ymax)
    ## coord. ref. : lon/lat WGS 84 (EPSG:4326) 
    ## source      : memory 
    ## name        :      sum 
    ## min value   : 88.25242 
    ## max value   : 10288.39

##plotting the mean annual rainfall
![](sample_files/figure-gfm/plotting%20the%20mean%20annual%20rainfall-1.png)<!-- -->
