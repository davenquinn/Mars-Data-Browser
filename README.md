# Mars Data browser

A Javascript-based map frontend to explore Mars data on a global map, and build
download links to individual tiles. It was created by
[Daven Quinn](https://davenquinn.com)
(then a graduate student in [Bethany Ehlmann's group](http://ehlmann.caltech.edu) at Caltech) in 2013-14.
The original design was focused on collecting
CTX (Context Camera) imagery for building mosaics.
It is now housed at the Caltech Murray Lab.

The frontend is written in `coffeescript` and uses the `Spine` UI library and `polymaps`.

## Generating JSON files

*HiRISE* and *CTX* footprints are translated to a JSON format customized
for small size. This enables all footprints globally to be transferred
at once, greatly simplifying the web frontend.

The `data` directory contains a *Python* script that downloads footprint
shapefiles from the PDS Mars data node and encodes them to JSON. As of
Nov. 2018, the Shapefiles weigh ~1.2 GB, and the encoded data weigh
22 MB for ~200,000 CTX and ~115,000 HiRISE images.

This pipeline can be run as follows:

```sh
> ./make-json.py create # Downloads shapefiles first and then creates JSON
> ./make-json.py update # Updates JSON from already-downloaded shapefiles.
```
