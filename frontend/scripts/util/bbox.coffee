d3 = require "d3"

# Calculates minimum axis-aligned bounding box and saves for later use
createBounds = (data) ->
  lat = (c)->c[1]
  lon = (c)->c[0]
  bbox = (a) ->
    a.b = [
      [d3.min(a.c, lon),d3.min(a.c, lat)]
      [d3.max(a.c, lon),d3.max(a.c, lat)]
    ]
    a
  data.map bbox

module.exports = createBounds
