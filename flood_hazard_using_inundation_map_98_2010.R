library(terra)

fd_1998 <- rast("as_fld_1998.tif")
fd_1999 <- rast("as_fld_1999.tif")
fd_2000 <- rast("as_fld_2000.tif")
fd_2001 <- rast("as_fld_2001.tif")
fd_2002 <- rast("as_fld_2002.tif")
fd_2003 <- rast("as_fld_2003.tif")
fd_2004 <- rast("as_fld_2004.tif")
fd_2005 <- rast("as_fld_2005.tif")
fd_2006 <- rast("as_fld_2006.tif")
fd_2007 <- rast("as_fld_2007.tif")
fd_2008 <- rast("as_fld_2008.tif")
fd_2009 <- rast("as_fld_2009.tif")
fd_2010 <- rast("as_fld_2010.tif")

fd_2010$as_fld_2010_4[fd_2010$as_fld_2010_4 == 255] <- 1
plot(fd_2010$as_fld_2010_4)

fd_2009$as_fld_2009_4[fd_2009$as_fld_2009_4 == 255] <- 1
plot(fd_2009$as_fld_2009_4)

fd_2008$as_fld_2008_4[fd_2008$as_fld_2008_4 == 255] <- 1

fd_2007$as_fld_2007_4[fd_2007$as_fld_2007_4 == 255] <- 1

fd_2006$as_fld_2006_4[fd_2006$as_fld_2006_4 == 255] <- 1

fd_2005$as_fld_2005_4[fd_2005$as_fld_2005_4 == 255] <- 1

fd_2004$as_fld_2004_4[fd_2004$as_fld_2004_4 == 255] <- 1

fd_2003$as_fld_2003_4[fd_2003$as_fld_2003_4 == 255] <- 1

fd_2002$as_fld_2002_4[fd_2002$as_fld_2002_4 == 255] <- 1

fd_2001$as_fld_2001_4[fd_2001$as_fld_2001_4 == 255] <- 1

fd_2000$as_fld_2000_4[fd_2000$as_fld_2000_4 == 255] <- 1

fd_1999$as_fld_1999_4[fd_1999$as_fld_1999_4 == 255] <- 1

fd_1998$as_fld_1998_4[fd_1998$as_fld_1998_4 == 255] <- 1

fd_hz <- sum(fd_2010$as_fld_2010_4,fd_2009$as_fld_2009_4,
             fd_2008$as_fld_2008_4,
             fd_2006$as_fld_2006_4,fd_2005$as_fld_2005_4,
             fd_2004$as_fld_2004_4,fd_2003$as_fld_2003_4,
             fd_2002$as_fld_2002_4,fd_2001$as_fld_2001_4,
             fd_2000$as_fld_2000_4,fd_1999$as_fld_1999_4,
             fd_1998$as_fld_1998_4)
             
fd_hz <- sum(fd_2010$as_fld_2010_4,fd_2009$as_fld_2009_4,
             fd_2008$as_fld_2008_4,fd_2007$as_fld_2007_4,
             fd_2006$as_fld_2006_4,fd_2005$as_fld_2005_4,
             fd_2004$as_fld_2004_4,fd_2003$as_fld_2003_4,
             fd_2002$as_fld_2002_4,fd_2001$as_fld_2001_4,
             fd_2000$as_fld_2000_4,fd_1999$as_fld_1999_4,
             fd_1998$as_fld_1998_4)
plot(fd_hz, main = "Flood hazard map based on real inundation maps from 1998 to 2010")
writeRaster(fd_hz, "E:/cdl/maps/raster/flood_hazard_1998_2010.tif", overwrite=TRUE)
