#!/usr/bin/env python
"""
Downloads and imports coverage data for CTX and HiRISE
"""

import os
import json
import click
import fiona
from shapely.geometry import shape, mapping
from subprocess import call
from itertools import chain

coverages = dict(ctx=["edr"],hirise=["rdr","rdrv11"])
baseurl = "http://ode.rsl.wustl.edu/mars/coverageshapefiles/mars/mro/{inst}/{dsid}/{file}.tar.gz"
basename = "mars_mro_{inst}_{dsid}_c{lon}a"

__dir__ = os.path.dirname(os.path.realpath(__file__))
datadir = os.path.join(__dir__,"raw")

echo = lambda x: click.secho(x, fg="cyan")

def run(command):
    click.echo(command)
    call(command, shell=True)

def urls():
    for inst,types in coverages.items():
        for dsid in types:
            for lon in [0,180]:
                info = dict(inst=inst,dsid=dsid,lon=lon)
                yield baseurl.format(
                    file=basename.format(**info),
                    **info)

def download_files():
    run("rm -f {}*".format(datadir))
    for url in urls():
        c = "curl {url} | tar -xz -C {d}"
        run(c.format(url=url,d=datadir))

def import_data(inst,dsid):
    files = [basename.format(inst=inst,dsid=dsid,lon=lon)+".shp" for lon in [0,180]]
    for fname in files:
        with fiona.open(os.path.join(datadir,fname), "r") as f:
            for i,feature in enumerate(f):
                if i%10000==0:
                    click.echo("{0}...".format(i),nl=False)
                geom = shape(feature["geometry"])
                if not geom.is_valid:
                    click.secho("Invalid Geometry",fg="red")
                    continue

                coords = feature["geometry"]["coordinates"][0]

                yield dict(
                    c=coords[0:-1], # Don't need closure, we can add this after the fact
                    i=feature["properties"]["ProductId"])
            click.echo(i)

@click.group()
def cli():
    pass

@cli.command()
def regenerate():
    """Regenerate data files"""
    for inst, types in coverages.items():
        echo("Importing {} data".format(inst))
        iterators = (import_data(inst,d) for d in types)
        collection = list(chain(*iterators))
        fn = os.path.join(__dir__,"build",inst+".json")
        with open(fn,"w") as outfile:
            json.dump(collection, outfile, allow_nan=False)
        echo("{0} features written".format(len(collection)))

@cli.command()
def update():
    """Downloads and generates data files"""
    download_files()
    regenerate()

if __name__ == "__main__":
    cli()
