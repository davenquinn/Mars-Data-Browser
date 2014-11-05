#!/usr/bin/env python

from __future__ import print_function

import os
import json

import fiona
from pathlib import Path
from pandas import read_table

directory = Path(".")
df = read_table(str(directory/"stereo-pairs.txt"), sep=r"\s*")

import IPython; IPython.embed()

def stereo_geometry(fid):
	d = df[df.Left == fid]
	a = len(d)
	if a > 0:
		assert a == 1

	return True




def import_data():

	data_dir = directory/"raw"
	for fname in data_dir.glob("*.shp"):
		with fiona.open(str(fname), "r") as f:
			for i,feature in enumerate(f):
				fid = feature["properties"]["ProductId"]
				if i%1000==0: print(fid)
				stereo = stereo_geometry(fid)
				coords = feature["geometry"]["coordinates"][0]
				yield dict(
					c=coords[0:-1], # Don't need closure, we can add this after the fact
					i=fid)

collection = list(import_data())

with open(str(directory/"data.json"),"w") as f:
	json.dump(collection, f, allow_nan=False)
