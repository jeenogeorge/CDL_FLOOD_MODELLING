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

    ##     terra    raster        sp        sf     tidyr     rgdal     dplyr tidyverse 
    ##      TRUE      TRUE      TRUE      TRUE      TRUE      TRUE      TRUE      TRUE

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
```

##plotting the mean annual rainfall
![](sample_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->
