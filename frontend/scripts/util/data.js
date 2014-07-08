define([],function(){
    var filterData = function(data, bounds){
        // convert minimalist arrays into geojson 
        var createFeature = function(array){
            return {
                type: "Feature",
                id: array.i,
                selected: false,
                hovered: false,
                geometry: {
                    type: "Polygon",
                    coordinates: [array.c.concat(array.c.slice(0,1))]
                }
            }
        };

        var spatialFilter = function(a){
            if (bounds[1][0] < a.b[0][0] || bounds[0][0] > a.b[1][0]) return false;  // to the left or right
            if (bounds[1][1] < a.b[0][1] || bounds[0][1] > a.b[1][1]) return false;  // above or below
            return true;
        }

        return {
            type: "FeatureCollection",
            features: data.filter(spatialFilter).map(createFeature)
        }
    }
    return filterData;
});