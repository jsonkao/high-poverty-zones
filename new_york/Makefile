main: ny.svg

ny-.json: cb_2014_06_tract_500k.shp Makefile
	mapshaper shapefiles/*.shp \
		-proj +proj=aea +lat_1=40 +lat_2=45 +lat_0=0 +lon_0=-75 +ellps=GRS80 +datum=NAD83 \
		-o $@ format=geojson

ny.svg: cb_2019_36_tract_500k.shp Makefile
	shp2json shapefiles/$< | \
	geoproject 'd3.geoConicEqualArea().parallels([40, 45]).rotate([75, 0]).fitSize([960, 960], d)' | \
	geo2svg -w 960 -h 960 > $@

cb_2019_36_tract_500k.shp: cb_2019_36_tract_500k.zip
	unzip -d shapefiles -o $<

cb_2019_36_tract_500k.zip:
	curl -o $@ https://www2.census.gov/geo/tiger/GENZ2019/shp/$@

clean:
	rm -rf shapefiles cb_2019_36_tract_500k.* ny.*
