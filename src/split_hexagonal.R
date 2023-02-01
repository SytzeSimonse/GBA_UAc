# get sample data from package
nc = st_read(terceira_boundary_fpath)
# convert from lat-long to a cartesian - use a better CRS for your data
nc = st_transform(nc, 32626)

# make a hex grid
g = st_make_grid(nc, square=F)

# test if hex grid intersects any polygons. st_intersects
# returns a list, and the element list is zero if there's no intersection
ig = lengths(st_intersects(g, nc)) > 0

# plot the map, and add the intersected hexagons:
plot(st_geometry(nc))
plot(g[ig], col=adjustcolor("red", alpha.f=0.2) , add=TRUE)

