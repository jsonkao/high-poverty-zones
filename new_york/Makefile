KEY := $(shell cat census_key.txt)

ny-albers-B02001.svg: ny-albers-B02001.json Makefile
	( \
		topo2geo tracts=- < $< \
		| ndjson-map -r d3 'z = d3.scaleThreshold().domain([1, 10, 50, 200, 500, 1000, 2000, 4000]).range(d3.schemeOrRd[9]), d.features.forEach(f => f.properties.fill = z(f.properties.density)), d' \
		| ndjson-split 'd.features'; \
		topo2geo counties=- < $< \
		| ndjson-map 'd.properties = {stroke: "#000", "stroke-opacity": 0.3}, d' \
	) \
	| geo2svg --newline-delimited --stroke none -p 1 -w 960 -h 960 \
	> $@

ny-albers-B02001.json: ny-albers.ndjson acs_B02001.ndjson Makefile
	# Join the Albers NDJSON (d₀) and the ACS NDJSON (d₁)
	# Map [d₀, d₁] to just d₀, calculating pop density using ACS data
	# Convert to TopoJSON (6.0M to 3.8M)
	# Simplify using planar area threshold of 1 square px (1.8M)
	# Quantize (0.9M)
	# Merge tracts by state FIPS + county FIPS (workks bc tracts compose
	#   hierarchically into counties)
	# Compute internal border mesh using topomerge, overwriting old polygons
	# Go back to GeoJSON to extract the simplified tracts from the topology
	# Use map to assign fill property for each tract
	# Split features into NDJSON so each one is rendered as one path
	# Run it through geo2svg -n
	ndjson-join 'd.id' ny-albers.ndjson acs_B02001.ndjson \
		| ndjson-map 'd[0].properties = {density: Math.floor(d[1].B02001_005E / d[0].properties.ALAND * 2589975.2356)}, d[0]' \
		| geo2topo --newline-delimited tracts=- \
		| toposimplify -p 1 -f \
		| topoquantize 1e5 \
		| topomerge --key 'd.id.slice(0, 5)' counties=tracts \
		| topomerge --mesh --filter 'a !== b' counties=counties \
		>$@

acs_B02001.ndjson:
	# Curl the information
	# Remove newlines between elements of an array
	# Separate the array into multiple lines, removing the header row
	# Reformat each line as a sensible object
	curl 'https://api.census.gov/data/2018/acs/acs5?get=B02001_005E&for=tract:*&in=state:36&key=$(KEY)' \
		| ndjson-cat \
		| ndjson-split 'd.slice(1)' \
		| ndjson-map '{id: d[1] + d[2] + d[3], B02001_005E: +d[0]}' > $@

ny-albers.ndjson: shapefiles/cb_2019_36_tract_500k.shp
	shp2json $< \
	| geoproject 'd3.geoConicEqualArea().parallels([40, 45]).rotate([75, 0]).fitSize([960, 960], d)' \
	| ndjson-split 'd.features' \
	| ndjson-map 'd.id = d.properties.GEOID, d' > $@

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
	rm -rf shapefiles cb_2019_36_tract_500k.* ny* acs_B02001.*
