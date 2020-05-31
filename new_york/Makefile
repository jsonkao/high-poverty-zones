ny.svg: cb_2014_06_tract_500k.shp Makefile
	mapshaper shapefiles/*.shp -o - format=geojson | \
		geoproject 'd3.geoConicEqualArea().parallels([40, 45]).rotate([75, 0]).fitSize([960, 960], d)' \
		> ny.json
		# geo2svg > $@

cb_2014_06_tract_500k.shp: cb_2019_36_place_500k.zip
	unzip -d shapefiles -o $<

cb_2019_36_place_500k.zip:
	curl -o $@ https://www2.census.gov/geo/tiger/GENZ2019/shp/$@

clean:
	rm -rf shapefiles cb_2019_36_place_500k.*
