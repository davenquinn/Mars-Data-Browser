createFeature = (array) ->
  type: "Feature"
  id: array.i
  selected: false
  hovered: false
  geometry:
    type: "Polygon"
    coordinates: [array.c.concat(array.c.slice(0, 1))]

module.exports = (data, bounds) ->
  # convert minimalist arrays into geojson
  spatialFilter = (a) ->
    return false if bounds[1][0] < a.c[0][0] or bounds[0][0] > a.c[1][0] # to the left or right
    return false if bounds[1][1] < a.c[0][1] or bounds[0][1] > a.c[1][1] # above or below
    true

  data.filter(spatialFilter).map(createFeature)
