define([
    "jquery",
    ],function($){

var poTileUrl = function(c) {
  var zoom = c.zoom
  var baseUrl = "http://mw1.google.com/mw-planetary/mars/visible/";
  var bound = Math.pow(2, zoom);
  var y = c.row;
  var x = c.column;
  var quads = ['t'];

  // tile range in one direction range is dependent on zoom level
  // 0 = 1 tile, 1 = 2 tiles, 2 = 4 tiles, 3 = 8 tiles, etc
  var tileRange = 1 << zoom;

  // don't repeat across y-axis (vertically)
  if (y < 0 || y >= tileRange) return null;
  // don't repeat across x-axis
  if (x < 0 || x >= tileRange) return null;

  for (var z = 0; z < zoom; z++) {
    bound = bound / 2;
    if (y < bound) {
      if (x < bound) {
        quads.push('q');
      } else {
        quads.push('r');
        x -= bound;
      }
    } else {
      if (x < bound) {
        quads.push('t');
        y -= bound;
      } else {
        quads.push('s');
        x -= bound;
        y -= bound;
      }
    }
  }

  url = baseUrl + quads.join('') + ".jpg";
  return url
};

var marsTileUrl = function(d) {
  var zoom = d[2]
  var baseUrl = "http://mw1.google.com/mw-planetary/mars/visible/";
  var bound = Math.pow(2, zoom);
  var y = d[1];
  var x = d[0];
  var quads = ['t'];

  // tile range in one direction range is dependent on zoom level
  // 0 = 1 tile, 1 = 2 tiles, 2 = 4 tiles, 3 = 8 tiles, etc
  var tileRange = 1 << zoom;

  // don't repeat across y-axis (vertically)
  if (y < 0 || y >= tileRange) return null;
  // don't repeat across x-axis
  if (x < 0 || x >= tileRange) return null;

  for (var z = 0; z < zoom; z++) {
    bound = bound / 2;
    if (y < bound) {
      if (x < bound) {
        quads.push('q');
      } else {
        quads.push('r');
        x -= bound;
      }
    } else {
      if (x < bound) {
        quads.push('t');
        y -= bound;
      } else {
        quads.push('s');
        x -= bound;
        y -= bound;
      }
    }
  }

  url = baseUrl + quads.join('') + ".jpg";
  return url
};

return poTileUrl;

});
