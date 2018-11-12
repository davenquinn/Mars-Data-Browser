#!/usr/bin/env python
# -- coding:utf8 -*-
"""
This script supports the usage of topojson on Mars by testing the
accuracy implied by quantizations of different levels using a different
planetary radius.
https://github.com/mbostock/topojson/wiki/Command-Line-Reference#quantization

Usage: quantization.py [LEVEL]

Arguments:
	LEVEL        The level of quantization to test [default: 1e4]

Options:
	-h --help    Show this message
"""

from __future__ import division
import numpy as N
import docopt

args = docopt.docopt(__doc__)

level = float(args["LEVEL"])
if level == None:
	level = 1e4


Mars_radius = 3.39e6 #meters

def degree_to_meters(d):
	return 2*N.pi*Mars_radius/360*d

q = [360/level, 180/level]
d = [degree_to_meters(i) for i in q]

def printer():
	for i in zip(d,q):
		yield "{0:.0f}m ({1:.5f}º)".format(*i)

print "quantization (adjusted with radius of {0:.0f}m): {1} {2}".format(Mars_radius,*tuple(printer()))

