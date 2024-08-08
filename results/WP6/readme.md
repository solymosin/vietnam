
Using WorldClim projections (https://www.worldclim.org/data/cmip6/cmip6_clim10m.html#google_vignette)
for 10 GCM and four SSP combination the mean of the predicted bioclimatic variables for Vietnamian provinces were estimated and saved in ESRI shape files. The ESRI shape file name contains the following structure:
the projected climate for ACCESS-CM2 GCM and ssp126 emission scenario between 2041 and 2060 is save in folder wc2.1_10m_bioc_ACCESS-CM2_ssp126_2041-2060.


###Bioclimatic variables

Bioclimatic variables are derived from the monthly temperature and rainfall values in order to generate more biologically meaningful variables. These are often used in species distribution modeling and related ecological modeling techniques. The bioclimatic variables represent annual trends (e.g., mean annual temperature, annual precipitation) seasonality (e.g., annual range in temperature and precipitation) and extreme or limiting environmental factors (e.g., temperature of the coldest and warmest month, and precipitation of the wet and dry quarters). A quarter is a period of three months (1/4 of the year).

They are coded as follows:

bio01 = Annual Mean Temperature

bio02 = Mean Diurnal Range (Mean of monthly (max temp - min temp))

bio03 = Isothermality (bio02/bio07) (×100)

bio04 = Temperature Seasonality (standard deviation ×100)

bio05 = Max Temperature of Warmest Month

bio06 = Min Temperature of Coldest Month

bio07 = Temperature Annual Range (bio05-bio06)

bio08 = Mean Temperature of Wettest Quarter

bio09 = Mean Temperature of Driest Quarter

bio10 = Mean Temperature of Warmest Quarter

bio11 = Mean Temperature of Coldest Quarter

bio12 = Annual Precipitation

bio13 = Precipitation of Wettest Month

bio14 = Precipitation of Driest Month

bio15 = Precipitation Seasonality (Coefficient of Variation)

bio16 = Precipitation of Wettest Quarter

bio17 = Precipitation of Driest Quarter

bio18 = Precipitation of Warmest Quarter

bio19 = Precipitation of Coldest Quarter






