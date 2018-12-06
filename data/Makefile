all: geojson topojson copy

geojson:
	mkdir -p raw-data build
	./make-json.py create

topojson:
	geo2topo -q 1e5 -o ctx.json -- data.json
	./test-quantization.py 1e5

copy:
	cp ctx.json ../app/data/ctx.json
