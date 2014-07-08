#!/usr/bin/env python

import os
import json

import fiona
from shapely.geometry import shape, mapping

__dir__ = os.path.dirname(os.path.realpath(__file__))

def ensure_spherical(geometry):
	def process_coords(coords):
		for coord in coords:
			try:
				if coord[0] > 180:
					yield (coord[0] - 180, coord[1])
				else:
					yield coord
			except TypeError:
				yield list(process_coords(coord))

	return {
		"type": geometry["type"],
		"coordinates": list(process_coords(geometry["coordinates"]))
	}


def import_data():
	data_dir = os.path.join(__dir__,"raw")
	for fname in os.listdir(data_dir):
		if os.path.splitext(fname)[1] != ".shp":
			continue
		with fiona.open(os.path.join(data_dir,fname), "r") as f:
			for feature in f:
				geom = shape(feature["geometry"])
				if not geom.is_valid:
					print "Invalid Geometry"

				yield {
					"type": "Feature",
					"geometry": ensure_spherical(feature["geometry"]),
					"id": feature["properties"]["ProductId"]
				}

collection = {
	"type": "FeatureCollection",
	"features": list(import_data())
}

string = json.dumps(collection)

with open(os.path.join(__dir__,"data.json"),"w") as outfile:
	outfile.write(string)
