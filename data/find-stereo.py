#!/usr/bin/env python

from __future__ import print_function

import os
import json

from shapely.geometry import Point
from pathlib import Path

def coordinates(s):
    lat = int(s[:2])
    if s[2] == "S": lat *= -1
    lon = 360-int(s[3:-1])
    return lon, lat

area = Point(75,15).buffer(10, cap_style=3)

directory = Path(__file__).parent
with (directory/"stereo-pairs.txt").open("r") as f:
    for line in f:
        left = line.split()[0]
        loc = left.split("_")[-1]
        geom = Point(coordinates(loc))
        if geom.within(area):
            print(line.rstrip())
