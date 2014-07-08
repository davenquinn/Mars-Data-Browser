define [], ->
    filterData = (data, bounds) ->

        # convert minimalist arrays into geojson
        createFeature = (array) ->
            type: "Feature"
            id: array.i
            selected: false
            hovered: false
            geometry:
                type: "Polygon"
                coordinates: [array.c.concat(array.c.slice(0, 1))]

        spatialFilter = (a) ->
            return false    if bounds[1][0] < a.b[0][0] or bounds[0][0] > a.b[1][0] # to the left or right
            return false    if bounds[1][1] < a.b[0][1] or bounds[0][1] > a.b[1][1] # above or below
            true

        type: "FeatureCollection"
        features: data.filter(spatialFilter).map(createFeature)

    filterData
