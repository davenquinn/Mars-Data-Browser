all: geojson topojson copy

geojson:
	./make_geojson.py

topojson:
	topojson -q 1e5 -o ctx.json -- data.json
	./test_quantization.py 1e5

json:
	./make_json.py
	cp data.json ../app/data/data.json

copy:
	cp ctx.json ../app/data/ctx.json