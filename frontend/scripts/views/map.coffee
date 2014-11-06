d3 = require "d3"
BaseView = require "./base"
po = require "../lib/polymaps"
SelectControl = require "./select"
filterData = require "../util/data"

class Map extends BaseView
  initialize: ->
    self = this
    @data = features: []
    @render()
    @_focused = null
    @selectionActive = false
    return

  render: ->
    self = this
    @createMap()
    attr = "<div class=\"attribution\">Tiles: <a href=\"https://www.mapbox.com/blog/2012-08-26-mapping-mars/\">Mapbox</a> | <a href=\"astrogeology.usgs.gov\">USGS</a></div>"
    @$el.append attr
    @setupLayer()
    @selection = new SelectControl(parent: this)
    @listenTo @selection, "area_updated", =>
      @data = filterData(App.data.raw, @selection.extent)
      @refresh @data
      return

    return

  setupListeners: ->
    @listenTo App.list, "selection_updated", @updateSelection
    return

  createMap: ->
    @_map = po.map().container(@el.appendChild(po.svg("svg"))).center(
      lat: 0
      lon: 0
    ).zoom(5).zoomRange([
      4
      8
    ]).add(po.interact())
    url = po.url("http://{S}.tiles.mapbox.com/v3/herwig.map-tly29w1z/{Z}/{X}/{Y}.png").hosts([
      "a"
      "b"
      "c"
      "d"
    ])

    # http://a.tiles.mapbox.com/v3/herwig.map-tly29w1z.html#5/19.808/440.332
    @_map.add po.image().url(url)
    svg = d3.select("#map svg")
    @overlay = svg.insert("svg:g").attr("class", "overlay")

    ns = this
    projectPoint = (x, y) ->
      d = ns._map.locationPoint
        lon: x
        lat: y
      @stream.point d.x, d.y

    @pathfinder = d3.geo.path()
      .projection d3.geo.transform(point: projectPoint)

  refresh: (data) =>
    self = this
    @features = @footprints.selectAll("path")
      .data data.features, (d) -> d.id

    @features.enter()
      .append("path")
        .attr("d", @pathfinder)
        .on "click", (d) =>
          d.selected = (if d.selected then false else true)
          @updateSelection()
          @trigger "selection_updated"

    @features.exit().remove()
    @updateSelection()

  setupLayer: ->

    reset = -> self.features.attr "d", self.pathfinder
    self = this
    @footprints = @overlay.append("g").attr("class", "footprints")
    @refresh @data
    reset()
    @_map.on "move", -> reset()

  updateSelection: ->
    @features.attr "class", (d) ->
      if d.selected
        "selected"
      else
        null

module.exports = Map
