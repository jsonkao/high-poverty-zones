# Unzip NTA shapefile. Use mapshaper to convert to TopoJSON.
school_zones.json: school_zones.geojson Makefile
	mapshaper school_zones.geojson \
		-proj EPSG:2261 \
		-o school_zones.json \
		format=topojson

# Download ES school zones zip from NYC Open Data
school_zones.geojson:
	curl -o school_zones.geojson \
		'https://data.cityofnewyork.us/api/geospatial/xehh-f7pi?method=export&format=GeoJSON'
