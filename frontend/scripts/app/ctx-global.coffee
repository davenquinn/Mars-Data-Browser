
createCTXMosaicData = ->
  __ = []
  for a in [-45..45]
    for b in [-22...22]
      x0 = a*4
      y0 = b*4
      i = "E#{x0}_N#{y0}.zip"
      c = [[x0,y0],[x0+4,y0],[x0+4,y0+4],[x0,y0+4]]
      __.push({i,c})
  return __

module.exports = {createCTXMosaicData}
