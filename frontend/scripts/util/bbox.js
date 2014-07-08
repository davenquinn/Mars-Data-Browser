define(["d3"],function(d3){
    // Calculates minimum axis-aligned bounding box and saves for later use
    var createBounds = function(data){
        var lat = function(coord){return coord[1]};
        var lon = function(coord){return coord[0]};
        var bbox = function(a){
            a.b = [[d3.min(a.c, lon), d3.min(a.c,lat)],[d3.max(a.c, lon), d3.max(a.c,lat)]];
            return a
        };
        return data.map(bbox)
    };
    return createBounds;
});