#!/usr/bin/env python
"""
Downloads and imports coverage data for CTX and HiRISE
"""

# Standard library imports
import os
import json
from subprocess import call
from itertools import chain, product
# External modules
import click
import fiona
from shapely.geometry import shape, mapping


coverages = dict(
    ctx=["edr"],
    hirise=["rdr","rdrv11"])#,
    #crism=["trdr"])
baseurl = "https://ode.rsl.wustl.edu/mars/coverageshapefiles/mars/mro/{inst}/{dsid}/{file}.tar.gz"
basename = "mars_mro_{inst}_{dsid}_c{lon}a"

__dir__ = os.path.dirname(os.path.realpath(__file__))
datadir = os.path.join(__dir__,"raw-data")

echo = lambda x: click.secho(x, fg="cyan")

def mkdirp(*args):
    directory = os.path.join(*args)
    if not os.path.isdir(directory):
        os.makedirs(directory)

def run(command):
    click.secho(command, fg="cyan")
    call(command, shell=True)

def urls():
    """ Generates URLs for PDS coverage files
    """
    for inst,types in coverages.items():
        for dsid, lon in product(types, [0,180]):
            info = dict(inst=inst,dsid=dsid,lon=lon)
            yield baseurl.format(
                file=basename.format(**info),
                **info)

def download_files():
    click.secho("Downloading data", fg="green")
    mkdirp(datadir)
    run("rm -f {}*".format(datadir))
    for url in urls():
        c = "curl {url} | tar -xz -C {d}"
        run(c.format(url=url,d=datadir))

def import_data(inst,dsid):
    """
    Export footprints into a custom format built for small size
    """
    files = [basename.format(inst=inst,dsid=dsid,lon=lon)+".shp" for lon in [0,180]]
    for fname in files:
        with fiona.open(os.path.join(datadir,fname), "r") as f:
            click.secho(fname,fg='green')
            for i,feature in enumerate(f):
                if i%10000==0:
                    click.echo("{0}...".format(i),nl=False)
                fid = feature["properties"]["ProductId"]

                if inst == "hirise" and not fid.endswith("RED"):
                    continue

                geom = shape(feature["geometry"])
                if not geom.is_valid:
                    click.secho("Invalid Geometry",fg="red")
                    continue

                # Should use shapely simplification here

                coords = feature["geometry"]["coordinates"][0]

                yield dict(
                    c=coords[0:-1], # Don't need polygon closure, we can add this on client-side
                    i=fid)
            click.echo(i)

@click.group()
def cli():
    pass

@cli.command()
def update():
    """Regenerate data files"""
    for inst, types in coverages.items():
        echo("Importing {} data".format(inst))

        iterators = (import_data(inst,d) for d in types)
        collection = list(chain(*iterators))

        mkdirp(__dir__, "build")
        fn = os.path.join(__dir__,"build",inst+".json")

        with open(fn,"w") as outfile:
            json.dump(collection, outfile, allow_nan=False)
        echo("{0} features written\n".format(len(collection)))

@cli.command()
def create():
    """Downloads and generates data files"""
    download_files()
    update()

if __name__ == "__main__":
    cli()
