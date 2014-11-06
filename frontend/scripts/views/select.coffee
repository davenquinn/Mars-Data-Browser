d3 = require "d3"
BaseView = require "./base"

class SelectControl extends BaseView
  initialize: (options) ->
    @extent = null
    @active = false
    @selection = null
    @map = options.parent
    @_map = @map._map

    @container = @map.overlay
      .append("g")
        .attr
          class: "selection_container"
          "pointer-events": "all"

    @_map.on "move", (e) => @reset()

    d3.select("body")
      .on "keydown", => @enable() if d3.event.shiftKey
      .on "keyup", => @disable() if d3.event.keyIdentifier is "Shift"

  reset: ->
    return unless @selection?
    @selection.attr "d", @pathfinder

  enabled: false
  enable: =>
    console.log "Enabled"
    @onBrush = =>
      f = d3.format(".3f")
      e = @control.extent()
      window.App.extent.onBrush e

    if @selection?
      @selection.remove()
      @selection = null

    @drag = @container.append("g").attr("class", "brush")
    @drag.select("rect.background")
      .style "cursor", "crosshair"


    extent = @_map.extent()

    xscale = d3.scale.linear()
      .domain [extent[0].lon, extent[1].lon]
      .range [0, @map.$el.width()]
    yscale = d3.scale.linear()
      .domain [extent[0].lat,extent[1].lat]
      .range [@map.$el.height(), 0]

    @control = d3.svg.brush()
      .x(xscale)
      .y(yscale)
      .on("brush", @onBrush)

    @control.extent(@extent) if @extent?
    @drag.call @control

    @enabled = true

  disable: =>
    @drag.remove()
    ex = @control.extent()
    @geom =
      type: "Polygon"
      coordinates: [[
        ex[0]
        [ex[0][0],ex[1][1]]
        ex[1]
        [ex[1][0],ex[0][1]]
        ex[0]
      ]]

    @enabled = false
    same = (a, b) ->
      return false if not a
      i = 0
      while i < a.length
        return false  if a[i][0] isnt b[i][0] or a[i][1] isnt b[i][1]
        ++i
      true

    unless same(@extent, ex)
      @extent = ex
      @trigger "area_updated"
    return

module.exports = SelectControl
