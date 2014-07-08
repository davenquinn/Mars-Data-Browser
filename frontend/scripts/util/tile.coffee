define ["jquery"], ($) ->
    poTileUrl = (c) ->
        zoom = c.zoom
        baseUrl = "http://mw1.google.com/mw-planetary/mars/visible/"
        bound = Math.pow(2, zoom)
        y = c.row
        x = c.column
        quads = ["t"]

        # tile range in one direction range is dependent on zoom level
        # 0 = 1 tile, 1 = 2 tiles, 2 = 4 tiles, 3 = 8 tiles, etc
        tileRange = 1 << zoom

        # don't repeat across y-axis (vertically)
        return null    if y < 0 or y >= tileRange

        # don't repeat across x-axis
        return null    if x < 0 or x >= tileRange
        z = 0

        while z < zoom
            bound = bound / 2
            if y < bound
                if x < bound
                    quads.push "q"
                else
                    quads.push "r"
                    x -= bound
            else
                if x < bound
                    quads.push "t"
                    y -= bound
                else
                    quads.push "s"
                    x -= bound
                    y -= bound
            z++
        url = baseUrl + quads.join("") + ".jpg"
        url

    marsTileUrl = (d) ->
        zoom = d[2]
        baseUrl = "http://mw1.google.com/mw-planetary/mars/visible/"
        bound = Math.pow(2, zoom)
        y = d[1]
        x = d[0]
        quads = ["t"]

        # tile range in one direction range is dependent on zoom level
        # 0 = 1 tile, 1 = 2 tiles, 2 = 4 tiles, 3 = 8 tiles, etc
        tileRange = 1 << zoom

        # don't repeat across y-axis (vertically)
        return null    if y < 0 or y >= tileRange

        # don't repeat across x-axis
        return null    if x < 0 or x >= tileRange
        z = 0

        while z < zoom
            bound = bound / 2
            if y < bound
                if x < bound
                    quads.push "q"
                else
                    quads.push "r"
                    x -= bound
            else
                if x < bound
                    quads.push "t"
                    y -= bound
                else
                    quads.push "s"
                    x -= bound
                    y -= bound
            z++
        url = baseUrl + quads.join("") + ".jpg"
        url

    poTileUrl
