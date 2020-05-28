# Unzip NTA shapefile. Use mapshaper to convert to TopoJSON.
neighborhood_tabulation_areas.json: neighborhood_tabulation_areas.zip Makefile
	rm -rf tmp
	unzip neighborhood_tabulation_areas.zip -d tmp
	mapshaper tmp/geo_export_*.shp \
		-proj EPSG:2261 \
		-o neighborhood_tabulation_areas.json \
		format=topojson

# Download NTA zip from NYC Open Data
neighborhood_tabulation_areas.zip:
	curl -o neighborhood_tabulation_areas.zip \
		'https://data.cityofnewyork.us/api/geospatial/cpf4-rkhq?method=export&format=Shapefile'
