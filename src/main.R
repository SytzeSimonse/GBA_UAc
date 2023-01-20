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
statistics <- c("mean")
diversity_ind_stats <- outer(diversity_indices, statistics, sep = "_", paste)

## Add columns with empty values
tile_df[, diversity_ind_stats] <- NA

# Tally number of traps (to verify if all traps are within a tile)
total_num_of_traps <- 0

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
  trap_data_ter_sp <- SpatialPoints(trap_data_ter_spdf, proj4string = crs)
  
  ## Extract points
  extracted_points <- intersect(trap_data_ter_sp, tile)
  
  ## Count number of traps within tile extent
  num_of_traps <- length(extracted_points)
  
  ## Add number of traps within tile to total number (for later verification)
  total_num_of_traps <<- total_num_of_traps + num_of_traps
  
  ## Set CRS of extracted points to local projection
  crs(extracted_points) <- CRS("+init=epsg:32626")
  
  ## Check if there is more than 0 points within raster
  if (!(length(extracted_points)) == 0) {
    ## Select data by points
    result <- over(extracted_points, trap_data_ter_spdf)
    
    return(c(
      num_of_traps, 
      ## Calculate mean for each column
      round(colMeans(result), 1))
      )
  }
})

# Check if all traps are 'found' within tiles
if (nrow(trap_data_ter) == total_num_of_traps) {
  print("All traps in the DataFrame are within the tiles.")
} else {
  stop("Error: Not all traps in the DataFrame are identified in a tile.")
}

# Add results of aggregating points to the tile DataFrame
for (i in 1:nrow(tile_df)) {
  # Check if no values were found
  if (!(is.null(result_list[[i]]))) {
    tile_df[i,10:ncol(tile_df)] <- result_list[i][[1]]
  }
}

# Remove empty rows from DataFrame
tile_df <- na.omit(tile_df)

# Plot raster and overlay points
# plot(r)
# plot(trap_data_ter_sp, add = TRUE, col = "purple", pch = 16, cex = 0.8)
