KEY := $(shell cat census_key.txt)

hi.json: Makefile
	# Curl the information
	# Remove newlines between elements of an array
	# Separate the array into multiple lines, removing the header row
	# Reformat each line as a sensible object
	curl 'https://api.census.gov/data/2018/acs/acs5?get=B02001_005E&for=tract:*&in=state:36&key=$(KEY)' | \
		ndjson-cat | \
		ndjson-split 'd.slice(1)' | \
		ndjson-map '{id: d[1] + d[2] + d[3], B02001_005E: +d[0]}' > $@

ny-albers.ndjson: shapefiles/cb_2019_36_tract_500k.shp Makefile
	shp2json $< | \
	geoproject 'd3.geoConicEqualArea().parallels([40, 45]).rotate([75, 0]).fitSize([960, 960], d)' | \
	ndjson-split 'd.features' > $@

ny-albers-mapshaper.json: shapefiles/cb_2014_06_tract_500k.shp Makefile
	mapshaper $< \
		-proj +proj=aea +lat_1=40 +lat_2=45 +lat_0=0 +lon_0=-75 +ellps=GRS80 +datum=NAD83 \
		-o $@ format=geojson

shapefiles/cb_2019_36_tract_500k.shp: cb_2019_36_tract_500k.zip
	unzip -d shapefiles -o $<
	touch $@

cb_2019_36_tract_500k.zip:
	curl -o $@ https://www2.census.gov/geo/tiger/GENZ2019/shp/$@

clean:
	rm -rf shapefiles cb_2019_36_tract_500k.* ny.*
