d3 = require "d3"
Spine = require "spine"

class ExtentControl extends Spine.Controller
  enabled: false
  constructor: ->
    super arguments...
    @_el = d3.select @el[0]
      .attr class: "selection_container"

    @drag = @_el
      .append("g")
      .attr class: "brush disabled"

    @brush = d3.svg.brush()

    xscale = d3.scale.linear()
      .domain [0, @map.el.width()]
      .range [0, @map.el.width()]
    yscale = d3.scale.linear()
      .domain [0,@map.el.height()]
      .range [0,@map.el.height()]

    @brush
      .x(xscale)
      .y(yscale)
      .on "brush", @onBrush

    @drag.call @brush
    @disable()

    @map.poly.on "move", @reset

    d3.select("body")
      .on "keydown", =>
        @enable() if d3.event.shiftKey
      .on "keyup", =>
        @disable() unless d3.event.shiftKey

  reset: (e)=>
    if @extent?
      ex = @extent.map @unproject
      @brush.extent ex
    @drag.call @brush

  onBrush: =>
    ex = @project @brush.extent()
    @log "Updated extent: #{ex}"
    @trigger "changed", ex

  enable: =>
    @drag
      .attr class: "brush enabled"
      .style "pointer-events": "all"
      .selectAll "rect"
        .style "pointer-events": "all"
    @enabled = true
    @reset()

  project: (ex)=>
    ex.map (p)=>
      o = @map.poly.pointLocation x: p[0], y: p[1]
      [o.lon, o.lat]

  unproject: (c)=>
    o = @map.poly.locationPoint lon: c[0], lat: c[1]
    [o.x, o.y]

  disable: =>
    @drag
      .attr class: "brush disabled"
      .style "pointer-events": "none"
      .selectAll "rect"
        .style "pointer-events": "none"

    @enabled = false
    ex = @brush.extent()
    return unless ex?
    if ex[0][0] == ex[1][0]
      @log "No extent selected"
      @extent = null
      #@brush = false
      @trigger "updated", @extent
      return

    same = (a, b) ->
      return false if not a
      i = 0
      while i < a.length
        return false  if a[i][0] isnt b[i][0] or a[i][1] isnt b[i][1]
        ++i
      true

    @log "Updated extent: #{ex}"
    ex = @project ex
    return if same(@extent, ex)
    @extent = ex
    @trigger "updated", @extent

module.exports = ExtentControl
