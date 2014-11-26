d3 = require "d3"
Spine = require "spine"
template = require "./template.html"

class ExtentControl extends Spine.Controller
  constructor: ->
    super
    throw "@map required" unless @map
    @render()
    @expanded = false
    @f = d3.format(".3f")

    @listenTo @map.bbox, "changed updated", @updateExtent
    if @map.bbox.extent isnt null
      @updateExtent @map.bbox.extent

  render: ->
    @$el.html template
    return

  updateExtent: (e) =>
    @expand() unless @expanded
    @formatExtent e

  formatExtent: (e) ->
    @$(".lonmin").text @f(e[0][0])
    @$(".lonmax").text @f(e[1][0]) + "º"
    @$(".latmin").text @f(e[0][1])
    @$(".latmax").text @f(e[1][1]) + "º"

  expand: ->
    @expanded = true
    @$("h2").html "Selected area"# <button class='btn btn-small btn-default zoom-to'>Fit</button>"
    @$(".information").hide 400
    @$(".extent").show 400
    @$(".info2").show 400

module.exports = ExtentControl
