# List files in data directory (on cloud)
data_dir <- 'P:/Universidade dos Açores/data'
list.files(data_dir)

# Set paths to trap data
## LOCATIONS
trap_site_locations_fpath <- file.path(data_dir, 'species/site_locations.csv')
trap_site_locations <- read.csv(trap_site_locations_fpath, sep = ';')
## DIVERSITY DATA
trap_site_diversities_fpath <- file.path(data_dir, 'species/site_diversities.csv')
trap_site_diversities <- read.csv(trap_site_diversities_fpath, sep = ',')

# Combine trap data
trap_data <- merge(trap_site_locations, trap_site_diversities, by.x = "Site_code", by.y = "site")

# Subset data from Terceira
trap_data_ter <- subset(trap_data, grepl("^TER-", trap_data$Site_code))

# Create SpatialPointsDataFrame from DataFrame
## Prepare coordinates, data, and proj4string
coords <- trap_data_ter[ , c("X_coord", "Y_coord")]   # coordinates
data   <- trap_data_ter[ , 4:ncol(trap_data_ter)]          # data
crs    <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") # proj4string of coords

## Make the SpatialPointsDataFrame object
spdf <- SpatialPointsDataFrame(coords      = coords,
                               data        = data, 
                               proj4string = crs)

# Convert CRS of SPDF to local projection (EPSG:32626)
## Reproject the coordinates
spdf_reprojected <- spTransform(spdf, CRS("+init=epsg:32626"))

# Check the CRS of the reprojected data
st_crs(spdf_reprojected)
