d3 = require "d3"
Spine = require "spine"

class ExtentControl extends Spine.Controller
  enabled: false
  constructor: ->
    super
    @extent = null
    @active = false
    @selection = null
    @poly = @map.poly

    @container = @map.overlay
      .append("g")
        .attr
          class: "selection_container"
          "pointer-events": "all"

    @poly.on "move", (e) => @reset()

    d3.select("body")
      .on "keydown", => @enable() if d3.event.shiftKey
      .on "keyup", => @disable() if d3.event.keyIdentifier is "Shift"

  reset: ->
    return unless @selection?
    @selection.attr "d", @pathfinder

  onBrush: =>
    @trigger "changed", @brush.extent()

  enable: =>
    @log "Enabled"
      #window.App.extent.onBrush e

    if @selection?
      @selection.remove()
      @selection = null

    @drag = @container
      .append("g")
      .attr("class", "brush")
    @drag.select("rect.background")
      .style "cursor", "crosshair"


    extent = @poly.extent()

    xscale = d3.scale.linear()
      .domain [extent[0].lon, extent[1].lon]
      .range [0, @map.$el.width()]
    yscale = d3.scale.linear()
      .domain [extent[0].lat,extent[1].lat]
      .range [@map.$el.height(), 0]

    @brush = d3.svg.brush()
      .x(xscale)
      .y(yscale)
      .on("brush", @onBrush)

    @brush.extent(@extent) if @extent?
    @drag.call @brush

    @enabled = true

  disable: =>
    @drag.remove()
    ex = @brush.extent()
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
      @trigger "updated", ex
    return

module.exports = ExtentControl
