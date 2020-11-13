d3 = require "d3"
f3 = d3.format "03f"
f2 = d3.format "02f"

f_east = (num)->
  n = f3(Math.abs(num))
  if num >= 0
    return n
  return "-"+n

f_north = (num)->
  n = f2(Math.abs(num))
  if num >= 0
    return n
  return "-"+n


createCTXMosaicData = ->
  __ = []
  for a in [-45..45]
    for b in [-22...22]
      x0 = a*4
      y0 = b*4
      i = "E#{f_east(x0)}_N#{f_north(y0)}_data.zip"
      c = [[x0,y0],[x0+4,y0],[x0+4,y0+4],[x0,y0+4]]
      __.push({i,c})
  return __

module.exports = {createCTXMosaicData}
