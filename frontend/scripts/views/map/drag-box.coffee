d3 = require "d3"
Spine = require "spine"

enable = 

class ExtentControl extends Spine.Controller
  enabled: false
  constructor: ->
    super
    @_el = d3.select @el[0]

    @extent = null
    @poly = @map.poly


    @_el.attr
      class: "selection_container"
      "pointer-events": "all"

    @drag = @_el
      .append("g")
      .attr class: "brush disabled"

    @brush = false
    @poly.on "move", @reset

    d3.select("body")
      .on "keydown", => @enable() if d3.event.shiftKey
      .on "keyup", => @disable() if d3.event.keyIdentifier is "Shift"

  reset: (e)=>
    unless @brush
      return
    @log "Refreshing bounding box"
    ex = @poly.extent()

    xscale = d3.scale.linear()
      .domain [ex[0].lon, ex[1].lon]
      .range [0, @map.$el.width()]
    yscale = d3.scale.linear()
      .domain [ex[0].lat,ex[1].lat]
      .range [@map.$el.height(), 0]

    @brush
      .x(xscale)
      .y(yscale)
    @brush.extent(@extent) if @extent?
    @drag.call @brush

  onBrush: =>
    @trigger "changed", @brush.extent()

  enable: =>
    @log "Brush Enabled"
    @brush = d3.svg.brush() unless @brush

    @drag.attr "pointer-events": "all"
    @drag.selectAll("rect")
      .style "pointer-events": "all"

    @brush.on "brush", @onBrush

    @reset()

  disable: =>
    return unless @brush
    @log "Disabled"
    @drag.on "brush", null
    @drag.style "pointer-events": "none"
      .selectAll "rect"
        .style "pointer-events": "none"

    ex = @brush.extent()

    return unless ex
    if ex[0] == ex[1]
      @brush = false
      @trigger "updated", false

    same = (a, b) ->
      return false if not a
      i = 0
      while i < a.length
        return false  if a[i][0] isnt b[i][0] or a[i][1] isnt b[i][1]
        ++i
      true

    @log ex

    return if same(@extent, ex)


    @extent = ex
    @trigger "updated", ex

module.exports = ExtentControl
