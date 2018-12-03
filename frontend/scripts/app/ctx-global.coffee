
createCTXMosaicData = ->
  __ = []
  for a in [-90..90]
    for b in [-44...44]
      x0 = a*2
      y0 = b*2
      i = "E#{x0}_N#{y0}.zip"
      c = [[x0,y0],[x0+2,y0],[x0+2,y0+2],[x0,y0+2]]
      __.push({i,c})
  return __

module.exports = {createCTXMosaicData}
