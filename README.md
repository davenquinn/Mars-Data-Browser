# Mars Data browser

**Mars Data Browser** is a  Javascript-based map frontend to
explore Mars data on a global map and build
download links to individual tiles. It was created by
[Daven Quinn](https://davenquinn.com)
(then a graduate student in [Bethany Ehlmann's group](http://ehlmann.caltech.edu) at Caltech) in 2013-14.
The original design was focused on collecting
CTX (Context Camera) image strips for seamless mosaics.
It has since been expanded to cover HiRISE and CTX global mosaic data.
In 2018, it was refreshed to be housed at the Caltech Murray Lab and used to
link to data from the CTX global mosaic.

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

## Building the frontend

The frontend is primarily build in `coffeescript` and uses the `Spine` MVC library
and `polymaps`. Styles are compiled to `css` from the `sass` preprocesser language.
These components were originally assembled using the `gulp` command line tool and `browserify`. As of 2018, this pipeline is now somewhat out of date, so the `parcel` build tool was substituted.

To build the UI, run the watch script in the `bin` directory:

```
> bin/build --watch
```

This will build a website in the `dist/` directory, and keep a server running
at `http://localhost:1234/` for testing.

To build a compressed version for production, run the `bin/build` script with no arguments.

