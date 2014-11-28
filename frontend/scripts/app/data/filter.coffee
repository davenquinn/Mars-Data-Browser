createFeature = (array) ->
  type: "Feature"
  id: array.i
  selected: false
  hovered: false
  geometry:
    type: "Polygon"
    coordinates: [array.c.concat(array.c.slice(0, 1))]

module.exports = (data, bounds) ->
  testWithin = (point) ->
    return false if point[1] < bounds[1][1] # Lat less than min. lat
    return false if point[1] > bounds[0][1] # Lat greater than max. lat
    return false if point[0] < bounds[0][0] # Lon less than min. lon
    return false if point[0] > bounds[1][0] # Lon greater than max. lon
    return true
  spatialFilter = (d) ->
    for coord in d.c
      return true if testWithin coord
    return false

  data.filter(spatialFilter).map(createFeature)
