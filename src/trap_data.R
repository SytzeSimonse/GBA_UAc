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
