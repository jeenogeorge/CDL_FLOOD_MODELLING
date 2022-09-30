
Abstract

Annual floods acutely affect the state of Assam, impacting over 100,000 people and killing hundreds of people, livestock and animals. Consequently, building a flood hazard model that identifies the basin’s flood-prone zones is critical for decision makers to assure flood risk management.Geographic information systems (GIS) and multi-criteria decision analysis were used to create the flood hazard map. The mapping of flood prone areas is based on a collection of RS and GIS data. The rainfall, distance to the river, digital elevation model (DEM), slope, curve number for surface runoff, drainage density, soils, and lithology were all considered as causative factors for floods in this study. The thematic maps of these factors were examined by the multi-criteria decision analysis technique which comprises of selecting the factors and allocating relative scores on normalised maps. As the continuation of this work, the generated flood hazard map can be confirmed using a map identical to the Assam State Disaster Management Authority’s (ASDMA) ‘Flood hazard map,’ which maps the flood-affected areas using 215 satellite datasets obtained during the 1998-2015 floods. This is critical for demonstrating the model’s effectiveness in representing flood hazards.
Introduction

In order to measure the proneness of an area to flooding, it is necessary to identify the flood controlling factors. In the present work, we selected eight flood causative factors based on comprehensive literature review presented by Allafta, H., & Opp, C. (2021) (https://www.tandfonline.com/doi/full/10.1080/19475705.2021.1955755) is used. The eight flood controlling parameters are rainfall, distance to the river, elevation, slope, LULC, drainage density, soils and lithology. The reason for selecting the controlling factors are listed in the table below.
Factor 	Reason
Rainfall 	Plays important role in the evolution of flood; Additionally, the severity of a river flood is determined by the duration and intensity (volume) of rainfall in the catchment area of the river (https://www.zurich.com/en/knowledge/topics/flood-and-water-damage/three-common-types-of-flood)
Distance to river 	Secondary data on the study area revealed that the most frequent type of flood in the region to be fluvial floods
Elevation 	Fundamentally demonstrates the topographic characteristics; runoff flows from high to low terrains, therefore flood incidence likelihood in low elevation areas are higher.
Slope 	Influences the velocity of the water flow and concentration of water; the probability of flood increases as the slope of a region decreases.
LULC 	Land cover characteristics influences the surface runoff generation
Drainage Density 	Higher drainage promotes higher surface water flow thereby increasing the flooding susceptibility
Soil 	Soil properties such as layer thickness, permeability, and infiltration rate impose a direct impact on the rainfall-runoff processes (Zhiyu et al. 2013; Rimba et al. 2017)
Lithology 	The infiltration capacity and runoff in a region are affected by the lithology (Shaban et al. 2006; Dash and Sar (2020).

For the work, we have to load the following libraries:

packages <- c("terra", "raster", "sp", "sf", "tidyr", "rgdal", "dplyr", "tidyverse","ncdf4","ggplot2")

Method
Study Area

The study boundary is prepared by taking a buffer of 10 km from the state boundary. The ‘Rasterise’ function in qGIS is used to convert the vector file to raster format. The dimension of the raster file is 2000x2903 with resolution or pixel size of 250m and CRF as WGS 84 / Pseudo-Mercator (EPSG:3857).

assam_bound <- terra::rast("assam_stdy_area.tif")

Data

The section details about the data used to map the flood-prone areas of Assam. First, we load the study area.

assam_bound <- terra::rast("assam_stdy_area.tif")

Data Sources

The data sources for the eight controlling factors are as follows.
Data 	Source
Rainfall 	from 2015 to 2022 from https://www.imdpune.gov.in/Clim_Pred_LRF_New/Grided_Data_Download.html
Distance from river as line shapefile 	https://indiawris.gov.in/wris/#/
Curve number 	as a proxy for land use https://www.nature.com/articles/s41597-019-0155-x
Elevation map and slope map 	Digital Elevation Satellite images(STRM 1 Arc-Second Global)
Stream channels (3rd order and above) for drainage density as line shapefile 	https://indiawris.gov.in/wris/#/
Soil 	https://arc.indiawris.gov.in/server/rest/services/SubInfoSysLCC in layer soil - texture
Lithology 	https://pubs.er.usgs.gov/publication/ofr97470C
Preparing the data

The daily rainfall of the study area for the period from 2015 to 2021 is collected from the IMD Pune in NetCDF format. The annual rainfall is averaged over the number of years to get the mean annual rainfall. The code below shows how the data is prepared for the year 2021. The code is repeated for the other years.

#read the netCDF file
nc_data <- nc_open('2021.nc')
nf <- terra::rast('2021.nc')

#sum daily rainfall to get annual rainfall
nf_sum <- sum(nf)

#write the raster
writeRaster(nf_sum,'rainfall_2021.tif', overwrite = T )

Read the rainfall data we have already prepared for the years from 2015 to 2021.

R_15 <- rast('rainfall_2015.tif')
R_16 <- rast('rainfall_2016.tif')
R_17 <- rast('rainfall_2017.tif')
R_18 <- rast('rainfall_2018.tif')
R_19 <- rast('rainfall_2019.tif')
R_20 <- rast('rainfall_2020.tif')
R_21 <- rast('rainfall_2021.tif')

Next, we calculating the mean annual rainfall. Here we have plotted the data for visualisation.

rainfall <- c(R_15, R_16, R_17, R_18, R_19, R_20, R_21)
R_mean <- mean(R_15, R_16, R_17, R_18, R_19, R_20, R_21)
R_mean

## class       : SpatRaster 
## dimensions  : 129, 135, 1  (nrow, ncol, nlyr)
## resolution  : 0.25, 0.25  (x, y)
## extent      : 66.375, 100.125, 6.375, 38.625  (xmin, xmax, ymin, ymax)
## coord. ref. : lon/lat WGS 84 (EPSG:4326) 
## source      : memory 
## name        :      sum 
## min value   : 88.25242 
## max value   : 10288.39

Next we plot the mean annual rainfall.

Next, we can transform the rainfall data to a new data set with another CRS using the project method and crop it to the study area boundary.

R_mean <- terra::project(R_mean , assam_bound, overwrite = T)
R_mean <- terra::crop(R_mean , assam_bound, overwrite = T)
R_mean <- terra::mask(R_mean , assam_bound, overwrite = T)

The line shapefile of major rivers of India is available at ArcGIS Feature Service from India-WRIS.The major rivers are buffered by 2km,5km,10km,15km,20km,25km,50km and 100km. The polygon shapefiles are merged and converted to a raster file in qGIS.

riv_dist <- rast("assam_dist_from_major_rivers.tif") 

Next, we can transform the distance from the river data to a new data set with another CRS using the project method and crop it to the study area boundary.

riv_dist <- terra::project(riv_dist , assam_bound, overwrite = T)
riv_dist <- terra::crop(riv_dist , assam_bound, overwrite = T)
riv_dist <- terra::mask(riv_dist , assam_bound, overwrite = T)

DEM data were aquired from EarthExplorer by searching for Assam and choosing STRM 1 Arc-Second Global in Digital Elevation Satellite images. The ‘fill sinks’ function in qGIS is used to fill the DEM. The filled DEM is used here.

srtm_dem <- rast("srtm_filled_dem.tif")

Next, we can transform the filled DEM data to a new data set with another CRS using the project method and crop it to the study area boundary.

srtm_dem_prj <- terra::project(srtm_dem, assam_bound, overwrite = T)
srtm_dem_prj <- crop(srtm_dem_prj , assam_bound)
srtm_dem_prj <- mask(srtm_dem_prj , assam_bound, overwrite = T)

From the filled DEM, the ‘slope’ function in raster analysis of qGIS can give the slope map.

srtm_slope <- rast("strm_filled_slope_degrees.tif")

Next, we can transform the slope map to a new data set with another CRS using the project method and crop it to the study area boundary.

srtm_slope_prj <- terra::project(srtm_slope, assam_bound, overwrite = T)
srtm_slope_prj <- crop(srtm_slope_prj , assam_bound)
srtm_slope_prj <- mask(srtm_slope_prj , assam_bound, overwrite = T)

The landuse map of Assam was not available for use in this analysis and supervised or unsupervised classification of land cover satellite images was not attempted due to the availability of global gridded curve numbers for hydrologic modeling and design . The runoff curve number (abbreviated CN) is an empirical parameter used in hydrology to estimate direct runoff or infiltration due to excess rainfall. The resulting data product – GCN250 – represents runoff using a combination of the European space agency’s 2015 global land cover dataset (ESA CCI-LC) resampled to 250 metres and geo-registered with the hydrologic soil group’s global data product (HYSOGs250m) released in 2018. The average GCN is taken for the analysis and cropped to Assam study boundary.

gcn_global <- terra::rast("GCN250_ARCIII_average.tif")
assam <- terra::vect("assam_state_buffer.shp")
gcn_assam <- terra::crop(gcn_global, assam)

Next, we can transform the average GCN map to a new data set with another CRS using the project method and crop it to the study area boundary.

gcn_assam <- terra::project(gcn_assam , assam_bound, overwrite = T)
gcn_assam <- terra::crop(gcn_assam , assam_bound, overwrite = T)
gcn_assam <- terra::mask(gcn_assam , assam_bound, overwrite = T)

The drainage density indicates the closeness of spacing between channels and is a measure of the total length of the stream segment of all orders per unit area. In general it has been observed over a wide range of geologic and climatic types, that low drainage density is more likely to occur in regions of highly permeable subsoil material under dense vegetative cover, and where relief is low. In contrast, high drainage density is favored in regions of weak or impermeable subsurface materials, sparse vegetation and mountainous relief (Nag, 1998).

The stream channels derived from the DEM is available as line shape file at India-WRIS for orders three and above. The shape file has to be re-projected to WGS 84 / Pseudo-Mercator (EPSG:3857). In qGIS, the function line density is used to get the drainage density using the stream channels of order three and above, entering the search radius as 10 km and pixel size as 250 m.

drn_den <- terra::rast("drainage_density.tif")

Next, we can transform the drainage density map to a new data set with another CRS using the project method and crop it to the study area boundary.

drn_den_prj <- terra::project(drn_den, assam_bound, overwrite = T)
drn_den_prj <- terra::crop(drn_den_prj , assam_bound)
drn_den_prj <- terra::mask(drn_den_prj , assam_bound, overwrite = T)

The lithology thematic map of Assam consists of seven lithological units viz; Mesozoic intrusive and metamorphic rocks, neogene sedimentary rock, undeveloped precambrian rock, paleozoic rock, quaternary sediments and tertiary sedimentary rocks. The infiltration capacity and runoff in a region are affected by the lithology (Shaban et al. 2006; Dash and Sar (2020). Permeable lithology favors water infiltration, whereas impermeable lithology promotes surface runoff inducing the generation of flooding (Bonacci et al. 2006).

as_lith <- terra::rast("assam_lith.tif") 

Next, we can transform the lithology map to a new data set with another CRS using the project method and crop it to the study area boundary.

as_lith <- terra::project(as_lith , assam_bound, overwrite = T)
as_lith <- terra::crop(as_lith , assam_bound, overwrite = T)
as_lith <- terra::mask(as_lith , assam_bound, overwrite = T)

The soil map of the study area is categories into four major classes : clayey, loamy, rocky and sandy.

as_soil <- terra::rast("assam_soil.tif") 

Next, we can transform the soil map to a new data set with another CRS using the project method and crop it to the study area boundary.

as_soil <- terra::project(as_soil , assam_bound, overwrite = T)
as_soil <- terra::crop(as_soil , assam_bound, overwrite = T)
as_soil <- terra::mask(as_soil , assam_bound, overwrite = T)

Identification of flood hazard zones

During the analysis, weight scores were allocated to the thematic layers and their classes according to their significance in flood vulnerability. Total scores were computed using a simple weighted sum. Each pixel of the output map was calculated using the following equation:

Hi=∑jwj∗Xij

where, Xij denotes the rank score of each class with respect to the j layer, and Wj represents the normalized weight of the j layer.
Result
Classifying the thematic layers and assigning values to the classes

Rainfall (mm/year) : Rainfall is a major triggering factor for flood generation (Subbarayan and Sivaranjani 2020) since it directly relates to river discharge (Das 2018). The ‘cut’ function divides the range of values of the layer into specified number of intervals and codes the values according to which interval they fall. The leftmost interval corresponds to level one, the next leftmost to level two and so on. Thus, the rightmost interval that corresponds to level five also indicates the highest rainfall (mm/year).

#reclassify - RAINFALL
#range(R_mean[], na.rm=T)
rain_levels <- cut(R_mean[], breaks = 5,include.lowest =T, na.rm = T) 
tt <- cut(R_mean[],labels = c(1,2,3,4,5), include.lowest =T,breaks = 5, na.rm = T)
rain <- R_mean
values(rain) <- tt
rain <- rain+1 # to avoid the value '0'
plot(rain, main = "Rainfall (mm/year) reclassified into 5 classes")
mtext("Higher value - higher rainfall",  side = 1, line = 2)

Distance to the river (km): When flooding occurs, the closer the area to the river course are the more vulnerable areas to flooding.

#reclassify - river distance
rivdist_levels <- cut(riv_dist[], breaks = 5,include.lowest =T, na.rm = T)
levels(rivdist_levels)

## [1] "[1.9,21.6]"  "(21.6,41.2]" "(41.2,60.8]" "(60.8,80.4]" "(80.4,100]"

tt <- cut(riv_dist[],labels = c(5,4,3,2,1), breaks = 5,include.lowest =T, na.rm = T)
rivdist <- riv_dist
values(rivdist) <- tt
rivdist <- 6-(rivdist + 1) #to invert the values
plot(rivdist, main = "Distance from river (km) reclassified into 5 classes")
mtext("Higher value - closer to river", side = 1, line = 2)

Elevation : Runoff flows from high to low terrains, therefore the flood incidence likelihood in low-elevated regions is higher.

elev_levels <- cut(srtm_dem_prj[], breaks = 5,include.lowest =T, na.rm = T)
tt <- cut(srtm_dem_prj[],labels = c(5,4,3,2,1), breaks = 5, include.lowest =T,na.rm = T)
ele <- srtm_dem_prj
values(ele) <- tt
ele <- 6-(ele+1)
plot(ele, main = "Elevation reclassified into 5 classes")
mtext("Higher value - lower elevation", side = 1, line = 2)

Slope (degrees) : The surface slope influences the velocities of overland flow and the concentration of flow. The probability of a flood increases as the slope of a region decreases, making it a solid indicator for flood vulnerability evaluation. A high slope supports quick water drainage, whereas low slope results in stagnation of water, and promoting flooding.

slope_levels <- cut(srtm_slope_prj[], breaks = 5,include.lowest =T, na.rm = T)
tt <- cut(srtm_slope_prj[],labels = c(5,4,3,2,1), breaks = 5,include.lowest =T, na.rm = T)
sloper <- srtm_slope_prj 
values(sloper) <- tt
sloper <- 6-(sloper+1)
plot(sloper, main = "Slope reclassified into 5 classes")
mtext("Higher value - lower slope", side = 1, line = 2)

Curve number : Surface runoff has a direct impact on potential flooding of areas in a catchment.

gcn_levels <- cut(gcn_assam[], breaks = 5,include.lowest =T, na.rm = T)
tt <- cut(gcn_assam [],labels = c(5,4,3,2,1), breaks = 5,include.lowest =T, na.rm = T)
gcn <- gcn_assam
values(gcn) <- tt
gcn <- (gcn+1)
plot(gcn, main = "Curve number reclassified into 5 classes")
mtext("Lower value - lower CN", side = 1, line = 2)

Drainage density : Flood hazard is proportionally related to drainage density because higher drainage promotes a higher surface water flow and virtually increases the flooding susceptibility.

drnden_levels <- cut(drn_den_prj[], breaks = 5,include.lowest =T, na.rm = T)
tt <- cut(drn_den_prj [],labels = c(1,2,3,4,5), breaks = 5, include.lowest =T,na.rm = T)
drn_den <- drn_den_prj
values(drn_den) <- tt
drn_den <- drn_den+1
plot(drn_den,  main = "Drainage density reclassified into 5 classes")
mtext("Lower value - lower drainage density", side = 1, line = 2)

Soil features (As extracted from section 4.2.7 of research article) : Soil grain size can remarkably influence infiltration processes, and subsequently flooding susceptibility. The probability of flood risk increases with the decrease in soil infiltration capacity, which results in an enhancement in surface runoff. Sandy soils have a high ratio of macro pores with higher infiltration capacity and lower runoff than loamy soil. Loamy soils which have high ratios of medium-sized pores, possess higher infiltration rates and lower runoff than clayey soil which has the highest ratio of micro pores. Particular ranks were allocated to each class by considering the soil type and its infiltration rates.
Value 	Soil typology
56 	clay, loamy clay, sandy clay, silty clay,
230 	loam, silt loam, silt, sandy loam
254 	rocky, other non-soil categories
255 	loamy sand, sand

y <- classify(as_soil, cbind(id=c(56,230,254,255), v=c(5,3,0,1.5)))
soil <- y
plot(soil,  main = "Soil features reclassified into 4 classes")
mtext("Higher value - higher flooding susceptibility", side = 1, line = 2)

Lithology (As extracted from section 4.2.7 of research article): The infiltration capacity and runoff in a region are affected by the lithology. Permeable lithology favors water infiltration, whereas impermeable lithology promotes surface runoff inducing the generation of flooding. The metamorphic and igneous rocks are associated with low porosity and permeability (Earle 2019) and high runoff potentiality. Such lithologies were assigned high to extremely high ranks in lithology sub-classification (Rekha et al. 2011; Nasir et al. 2018; Kanagaraj et al. 2019).
Value 	Lithology
1 	water
2 	metamorphic, mesozoic and paleozoic intusive
3 	neogene sedimentary rock
4 	undeveloped precambrian rock
5 	paleogene sedementary rock
6 	paleozoic rock
7 	quaternary sediments
8 	tertiary sedimentary rocks

y_lith <- classify(as_lith, cbind(id=c(1,2,3,4,5,6,7,8), v=c(0,5,3.5,2,3.5,2,1,2.5)))
lith <- y_lith
plot(lith, main = "Lithology features reclassified into 6 classes")
mtext("Higher value - higher flooding susceptibility", side = 1, line = 2)

Flood hazard zoning

The selected eight factors produces a flood hazard map. The highest weight of 0.20 was given to ‘distance from the river’ as it is most frequent cause for the flooding in the region. Assam floods are fluvial floods due to the dense network of rivers.

#flood exposure mapper
floo_vul <- .15*rain + (.20)*rivdist + .10*drn_den + (.15)*sloper + 
  (.15)*ele + (.08)*soil + (.05)*lith + (.12)*gcn
plot(floo_vul, main = "Flood hazard zoning - Assam")
mtext("Higher value - higher flooding susceptibility", side = 1, line = 2)

The district-wise mean values of flood hazard can be extracted from the flood hazard zoning map. The assam_district_27 shapefile shows 27 districts. The shapefile can be replaced by updated Assam district shapefile.

district_27 <- terra::vect("assam_district_27.shp")
plot(floo_vul, main = "Flood hazard zoning - Assam")
plot(district_27, add=T)

floo_vul_d <- terra::extract(floo_vul, district_27, fun = mean, na.rm= T, df = T)
district_27$floo_vul <- floo_vul_d$sum
as.data.frame(district_27) %>% arrange(desc(floo_vul)) %>% dplyr::select(dtname, floo_vul)

##                 dtname floo_vul
## 1           Bongaigaon 3.415277
## 2               Dhubri 3.388288
## 3             Goalpara 3.366326
## 4               Cachar 3.323932
## 5             Golaghat 3.320242
## 6            Sivasagar 3.306790
## 7              Barpeta 3.302360
## 8            Lakhimpur 3.293335
## 9             Morigaon 3.282884
## 10           Kokrajhar 3.250396
## 11             Chirang 3.240043
## 12             Darrang 3.210357
## 13           Dibrugarh 3.195389
## 14              Jorhat 3.194957
## 15             Dhemaji 3.189704
## 16 Kamrup Metropolitan 3.182493
## 17              Nagaon 3.179163
## 18            Sonitpur 3.143476
## 19             Nalbari 3.142818
## 20            Tinsukia 3.126327
## 21              Kamrup 3.047574
## 22           Karimganj 3.039930
## 23               Baksa 3.021004
## 24          Hailakandi 2.984741
## 25            Udalguri 2.863783
## 26          Dima Hasao 2.857154
## 27       Karbi Anglong 2.651053

Conclusion

In the following work, the generated ‘flood hazard zoning’ map can be compared with actual flood maps of Assam to validate the work.
