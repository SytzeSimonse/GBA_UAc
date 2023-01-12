# set working directory
setwd("P:/Universidade dos Açores/code")

# list files in data directory
list.files('../data/bio_enviromental/bio_para entrega/Terceira/Normal_Observado')

# set path to bio1 of Terceira
ter_bio <- '../data/bio_enviromental/bio_para entrega/Terceira/Normal_Observado/bio1.tif'

library(raster)

#attempt to clear all plots (suppress error if not plots exist)
try(dev.off(dev.list()["RStudioGD"]), silent=TRUE)

# Function to create 1 km x 1 km tiles from a raster
create_tiles <- function(raster, tile_size, fun) {
  # Convert tile size to pixels
  nrows <- ceiling(tile_size/res(raster)[1])
  ncols <- ceiling(tile_size/res(raster)[2])
  
  # Create tiles
  tiles <- calc(raster, fun=function(x) {
    # Aggregate values in tile using input function
    x <- fun(x)
    
    # Return aggregated value
    x
  }, nrows=nrows, ncols=ncols)
  
  # Set resolution of tiles
  res(tiles) <- tile_size
  
  return(tiles)
}


# Read in raster
raster <- raster(ter_bio)

# Create 1 km x 1 km tiles and calculate mean for each tile
tiles <- create_tiles(raster, 1000, mean)

plot(raster)
plot(tiles)
