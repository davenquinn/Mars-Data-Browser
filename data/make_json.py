#!/usr/bin/env python

import os
import json

import fiona
from shapely.geometry import shape, mapping

__dir__ = os.path.dirname(os.path.realpath(__file__))

def import_data():
	data_dir = os.path.join(__dir__,"raw")
	files =  [a for a in os.listdir(data_dir) if os.path.splitext(a)[1] == ".shp"]
	for fname in [files[0]]:
		with fiona.open(os.path.join(data_dir,fname), "r") as f:
			for i,feature in enumerate(f):
				if i%1000==0: print i
				geom = shape(feature["geometry"])
				if not geom.is_valid:
					print "Invalid Geometry"
					continue

				coords = feature["geometry"]["coordinates"][0]

				yield {
					"c": coords[0:-1], # Don't need closure, we can add this after the fact
					"i": feature["properties"]["ProductId"]
				}

collection = list(import_data())

with open(os.path.join(__dir__,"data.json"),"w") as outfile:
	outfile.write(json.dumps(collection, allow_nan=False))
