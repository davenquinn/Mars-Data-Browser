d3 = require "d3"
Spine = require "spine"
$ = require "jquery"
po = require "../../lib/polymaps"
ExtentControl = require "./drag-box"
attribution = require "./attribution.html"

class Map extends Spine.Controller
  constructor: ->
    super arguments...
    @render()
    @_focused = null
    @bboxActive = false

  render: ->
    self = this
    @createMap()
    @$el.append attribution

    @footprints = @overlay.append("g").attr("class", "footprints")

    i = @overlay.append("g")
    @bbox = new ExtentControl
      map: @
      el: $(i[0])

  addData: (@data)=>
    throw "@data required" unless @data
    @log "Adding data to map"
    @setupLayer()
    @listenTo @bbox, "updated", @data.updateExtent
    @listenTo @data, "updated", @refresh
    @listenTo @data, "selection-updated", @updateSelection
    @listenTo @data, "hovered", @onHovered

    if @bbox.extent isnt null
      @data.updateExtent @bbox.extent

    @poly.on "move", @resetView

  setupLayer: =>
    @refresh []

  createMap: ->
    @poly = po.map()
      .container @el[0].appendChild(po.svg("svg"))
        .center lat: 0, lon: 0
        .zoom 5
        .zoomRange [4,9]
        .add po.interact()

    url = po.url("http://{S}.tiles.mapbox.com/v3/herwig.map-tly29w1z/{Z}/{X}/{Y}.png")
      .hosts ["a","b","c","d"]

    dz = Math.log(window.devicePixelRatio or 1)/Math.LN2


    img_layer = po.image()
      .url url
      .zoom (z)->z+dz
    svg = d3.select("#map svg")

    @poly.add img_layer

    @overlay = svg.insert("svg:g").attr("class", "overlay")

    ns = this
    projectPoint = (x, y) ->
      d = ns.poly.locationPoint
        lon: x
        lat: y
      @stream.point d.x, d.y

    @path = d3.geo.path()
      .projection d3.geo.transform(point: projectPoint)

  refresh: (features=[]) =>
    @log "Refreshing Map"
    @features = @footprints.selectAll("path")
      .data features, (d) -> d.id

    @features.enter()
      .append("path")
        .attr("d", @path)
        .on "click", @data.updateSelection
        .on "mouseover", @data.toggleHovered
        .on "mouseout", @data.toggleHovered
    @features.exit().remove()
    @updateSelection()

  resetView: => @features.attr "d", @path

  updateSelection: =>
    @features.classed "selected", (d)->d.selected

  clearFeatures: =>
    @log "Clearing features"
    @refresh []

  onHovered: =>
    @features.classed "hovered", (d)->d.hovered

  zoomTo: (e)=>
    @log "Setting zoom level"
    e = e.map (d)=>{lon:d[0],lat: d[1]}
    @poly.extent e

module.exports = Map
