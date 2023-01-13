# Load libraries
library(sp)
library(raster)

# Create trap data
source("src/trap_data.R")

# Split raster data
source("src/split.R")

# Plot points
library(ggplot2)
ggplot(trap_data_ter, aes(x = X_coord, y = Y_coord)) + 
  geom_point()

# Loop through tiles in DataFrame
result_list <- lapply(1:nrow(tile_df), function(i) {
  # Show iteration
  print(i)
  
  # Select row
  row <- tile_df[i,]
  
  # Create extent from row
  tile_ext <- extent(row$xmin, row$xmax, row$ymin, row$ymax)
  
  # Create tile by cropping with extent
  tile <- crop(r, tile_ext)
  plot(tile)
  
  # Check if the points are within the RasterLayer extent
  extracted_values <- extract(tile, spdf)
})