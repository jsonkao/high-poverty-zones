school_districts.json: school_districts.geojson Makefile
	# Import GeoJSON and set projection to NY Central.
	# Import high_poverty.csv with District as string.
	# Retarget districts and join it with the CSV
	# Output as TopoJSON
	mapshaper $< name=districts \
		-proj EPSG:32116 \
		-i high_poverty.csv name=poverty string-fields=District \
		-target districts \
		-join poverty keys=school_dist,District \
		-o $@ format=topojson

school_districts.geojson:
	curl -o $@ \
		'https://data.cityofnewyork.us/api/geospatial/r8nu-ymqj?method=export&format=GeoJSON'

# Unzip NTA shapefile. Use mapshaper to convert to TopoJSON.
school_zones.json: school_zones.geojson Makefile
	mapshaper $< \
		-proj EPSG:2261 \
		-o $@ \
		format=topojson

# Download ES school zones zip from NYC Open Data
school_zones.geojson:
	curl -o $@ \
		'https://data.cityofnewyork.us/api/geospatial/xehh-f7pi?method=export&format=GeoJSON'
