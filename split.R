# list files in data directory
list.files('../data/bio_enviromental/bio_para entrega/Terceira/Normal_Observado')

# set path to bio1 of Terceira
ter_bio <- '../data/bio_enviromental/bio_para entrega/Terceira/Normal_Observado/bio1.tif'

# Load packages
library(raster)
library(dplyr)

# Attempt to clear all plots (suppress error if not plots exist)
try(dev.off(dev.list()["RStudioGD"]), silent=TRUE)

# Read in raster file
r <- raster(ter_bio)

print(paste("Height (in kilometres):", nrow(r) * xres(r) / 1000))
print(paste("Width (in kilometres):", ncol(r) * yres(r) / 1000))

# Set tile size to 1000 meters x 1000 meters
spatial_dimension <- 10000

# Calculate number of rows and columns of tiles
nrow_tiles <- ceiling((nrow(r) * xres(r)) / spatial_dimension)
ncol_tiles <- ceiling((ncol(r) * yres(r)) / spatial_dimension)

print(nrow_tiles)
print(ncol_tiles)

# Calculate tile size
tile_size <- spatial_dimension * xres(r)

# Initialize list to store tile rasters
tile_rasters <- vector("list", nrow_tiles * ncol_tiles)

# Result values
tile_df_colnames <- c("tile_no", "xmin", "xmax", "ymin", "ymax", "mean", "min", "max", "median")
tile_df <- data.frame(matrix(nrow = 0, ncol = length(tile_df_colnames)))
colnames(tile_df) <- tile_df_colnames

# Get raster extent
r_ext <- extent(r)

# Create counter
counter <- 0

# Loop through rows and columns of tiles
for (i in 0:(ncol_tiles - 1)) {
  for (j in 0:(nrow_tiles - 1)) {
    # Increment counter
    counter <- counter + 1
    print(paste("Iteration no.:", counter))
    
    # Calculate min. x coordinates
    xmin <- extent(r)[1] + (spatial_dimension * i)
    xmax <- xmin + spatial_dimension
    
    # If tile extends extent, set to extent
    if (xmax > extent(r)[2]) {
      xmax <- extent(r)[2]
    }
    
    ymin <- extent(r)[3] + (spatial_dimension * j)
    ymax <- ymin + spatial_dimension
    
    if (ymax > extent(r)[4]) {
      ymax <- extent(r)[4]
    }
    
    # Create extent
    ext <- extent(xmin, xmax, ymin, ymax)
    
    # Create tile by cropping with extent
    tile <- crop(r, ext)
    
    # Skip tile if all values are NA
    if (all(is.na(tile[]))) next
    
    # Calculate cell statistics
    tile_mean <- cellStats(tile, mean)
    tile_min <- cellStats(tile, min)
    tile_max <- cellStats(tile, max)
    tile_median <- cellStats(tile, median)
    
    # Display tile
    plot(tile, main = paste("Tile:", counter)) 
    
    # Append tile to Data Frame
    tile_row <- as.list(c(counter, ext[1:4], tile_mean, tile_min, tile_max, tile_median))
    tile_df[nrow(tile_df)+1, ] <- tile_row
  }
}
