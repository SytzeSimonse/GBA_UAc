# Set path to root data directory (on cloud, mounted on P drive)
data_dir <- 'P:/Universidade dos Açores/data'

# Set path to folder with raster data
raster_dir <- file.path(data_dir, "bio_enviromental/bio_para entrega/Terceira/Normal_Observado")
raster_fpaths <- list.files(path = raster_dir, pattern = "^.*\\.tif$", full.names = TRUE)

# Set path to bio1 of Terceira
ter_bio1 <- file.path(data_dir, 'bio_enviromental/bio_para entrega/Terceira/Normal_Observado/bio1.tif')

# Set paths to trap data
## LOCATIONS
trap_site_locations_fpath <- file.path(data_dir, 'species/site_locations.csv')
trap_site_locations <- read.csv(trap_site_locations_fpath, sep = ';')
## DIVERSITY DATA
trap_site_diversities_fpath <- file.path(data_dir, 'species/site_locations.csv')
trap_site_diversities <- read.csv(trap_site_diversities_fpath, sep = ';')

# Load boundaries of Azores
terceira_boundary_fpath <- file.path(data_dir, "shapefiles/terceira_boundary.shp")
