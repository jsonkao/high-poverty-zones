main: school_districts_geo2topo.json school_districts_mstopo.json

# The next two targets just for understanding differences b.t. toposimplify and
# topoquantize and mapshaper
school_districts_geo2topo.json: school_districts.geojson Makefile
	geo2topo districts=$< | \
		toposimplify -p 1 | \
		topoquantize 1e6 \
		> $@

school_districts_mstopo.json: school_districts.geojson Makefile
	mapshaper $< name=districts \
		-o $@ format=topojson quantization=1e6

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
		-clean \
		-o $@ format=topojson

# Retrieve GeoJSON for school districts
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

clean:
	rm -f {school_districts,school_zones}*.{json,geojson}
