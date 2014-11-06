d3 = require "d3"
dragmove = (d) ->
  dragrect.attr "x", d.x = Math.max(0, Math.min(w - width, d3.event.x))
  dragbarleft.attr "x", (d) ->
    d.x - (dragbarw / 2)

  dragbarright.attr "x", (d) ->
    d.x + width - (dragbarw / 2)

  dragbartop.attr "x", (d) ->
    d.x + (dragbarw / 2)

  dragbarbottom.attr "x", (d) ->
    d.x + (dragbarw / 2)

  return
ldragresize = (d) ->
  oldx = d.x

  #Max x on the right is x + width - dragbarw
  #Max x on the left is 0 - (dragbarw/2)
  d.x = Math.max(0, Math.min(d.x + width - (dragbarw / 2), d3.event.x))
  width = width + (oldx - d.x)
  dragbarleft.attr "x", (d) ->
    d.x - (dragbarw / 2)

  dragrect.attr("x", (d) ->
    d.x
  ).attr "width", width
  dragbartop.attr("x", (d) ->
    d.x + (dragbarw / 2)
  ).attr "width", width - dragbarw
  dragbarbottom.attr("x", (d) ->
    d.x + (dragbarw / 2)
  ).attr "width", width - dragbarw
  return
rdragresize = (d) ->

  #Max x on the left is x - width
  #Max x on the right is width of screen + (dragbarw/2)
  dragx = Math.max(d.x + (dragbarw / 2), Math.min(w, d.x + width + d3.event.dx))

  #recalculate width
  width = dragx - d.x

  #move the right drag handle
  dragbarright.attr "x", (d) ->
    dragx - (dragbarw / 2)


  #resize the drag rectangle
  #as we are only resizing from the right, the x coordinate does not need to change
  dragrect.attr "width", width
  dragbartop.attr "width", width - dragbarw
  dragbarbottom.attr "width", width - dragbarw
  return
tdragresize = (d) ->
  oldy = d.y

  #Max x on the right is x + width - dragbarw
  #Max x on the left is 0 - (dragbarw/2)
  d.y = Math.max(0, Math.min(d.y + height - (dragbarw / 2), d3.event.y))
  height = height + (oldy - d.y)
  dragbartop.attr "y", (d) ->
    d.y - (dragbarw / 2)

  dragrect.attr("y", (d) ->
    d.y
  ).attr "height", height
  dragbarleft.attr("y", (d) ->
    d.y + (dragbarw / 2)
  ).attr "height", height - dragbarw
  dragbarright.attr("y", (d) ->
    d.y + (dragbarw / 2)
  ).attr "height", height - dragbarw
  return
bdragresize = (d) ->

  #Max x on the left is x - width
  #Max x on the right is width of screen + (dragbarw/2)
  dragy = Math.max(d.y + (dragbarw / 2), Math.min(h, d.y + height + d3.event.dy))

  #recalculate width
  height = dragy - d.y

  #move the right drag handle
  dragbarbottom.attr "y", (d) ->
    dragy - (dragbarw / 2)


  #resize the drag rectangle
  #as we are only resizing from the right, the x coordinate does not need to change
  dragrect.attr "height", height
  dragbarleft.attr "height", height - dragbarw
  dragbarright.attr "height", height - dragbarw

createRectangle = ->
  w = 750
  h = 450
  r = 120
  width = 300
  height = 200
  dragbarw = 20
  drag = d3.behavior.drag().origin(Object).on("drag", dragmove)
  dragright = d3.behavior.drag().origin(Object).on("drag", rdragresize)
  dragleft = d3.behavior.drag().origin(Object).on("drag", ldragresize)
  dragtop = d3.behavior.drag().origin(Object).on("drag", tdragresize)
  dragbottom = d3.behavior.drag().origin(Object).on("drag", bdragresize)
  svg = d3.select("body").append("svg").attr("width", w).attr("height", h)
  newg = svg.append("g").data([
    x: width / 2
    y: height / 2
  ])
  dragrect = newg.append("rect").attr("id", "active").attr("x", (d) ->
    d.x
  ).attr("y", (d) ->
    d.y
  ).attr("height", height).attr("width", width).attr("fill-opacity", .5).attr("cursor", "move").call(drag)
  dragbarleft = newg.append("rect").attr("x", (d) ->
    d.x - (dragbarw / 2)
  ).attr("y", (d) ->
    d.y + (dragbarw / 2)
  ).attr("height", height - dragbarw).attr("id", "dragleft").attr("width", dragbarw).attr("fill", "lightblue").attr("fill-opacity", .5).attr("cursor", "ew-resize").call(dragleft)
  dragbarright = newg.append("rect").attr("x", (d) ->
    d.x + width - (dragbarw / 2)
  ).attr("y", (d) ->
    d.y + (dragbarw / 2)
  ).attr("id", "dragright").attr("height", height - dragbarw).attr("width", dragbarw).attr("fill", "lightblue").attr("fill-opacity", .5).attr("cursor", "ew-resize").call(dragright)
  dragbartop = newg.append("rect").attr("x", (d) ->
    d.x + (dragbarw / 2)
  ).attr("y", (d) ->
    d.y - (dragbarw / 2)
  ).attr("height", dragbarw).attr("id", "dragleft").attr("width", width - dragbarw).attr("fill", "lightgreen").attr("fill-opacity", .5).attr("cursor", "ns-resize").call(dragtop)
  dragbarbottom = newg.append("rect").attr("x", (d) ->
    d.x + (dragbarw / 2)
  ).attr("y", (d) ->
    d.y + height - (dragbarw / 2)
  ).attr("id", "dragright").attr("height", dragbarw).attr("width", width - dragbarw).attr("fill", "lightgreen").attr("fill-opacity", .5).attr("cursor", "ns-resize").call(dragbottom)
  return

module.exports = createRectangle
