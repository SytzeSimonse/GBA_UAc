# Load libraries
library(sp)
library(raster)
library(sf)
library(rgeos)

# Create trap data
source("src/trap_data.R")

# Split raster data
source("src/split.R")

# Add empty (NA) columns for trap data to DataFrame
## Create column names: 29 diversity indices * X no. of statistics
diversity_indices <- colnames(trap_data_ter_spdf@data)
statistics <- c("mean", "min", "max")
diversity_ind_stats <- outer(diversity_indices, statistics, sep = "_", paste)

## Add columns with empty values
tile_df[, diversity_ind_stats] <- NA

# Loop through tiles in DataFrame
result_list <- lapply(1:nrow(tile_df), function(i) {
  # Select row
  row <- tile_df[i,]
  
  # Create extent from row
  tile_ext <- extent(row$xmin, row$xmax, row$ymin, row$ymax)
  
  # Create tile by cropping with extent
  tile <- crop(r, tile_ext)
  
  # Check if the points are within the RasterLayer extent
  ## Convert SPDF to SpatialPoints
  trap_data_ter_sp <- SpatialPoints(trap_data_ter_spdf)
  
  ## Extract points
  extracted_points <- intersect(trap_data_ter_sp, tile)
  if (!(length(extracted_points)) == 0) {
    print(extracted_points)
    print(as.data.frame(extracted_points))
  }
})

# Plot raster and overlay points
plot(r)
plot(trap_data_ter_sp, add = TRUE, col = "purple", pch = 16, cex = 0.8)

