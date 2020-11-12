d3 = require "d3"
Spine = require "spine"

template = """
<h2>Select a Map Area</h2>
<p class="information">Click/drag the map to navigate. <strong>Shift+click/drag the map</strong> to select an area in which to display footprints. You can always update your selected area.</p>
<div class="extent" style="display:none">
	<ul>
        <li><span class='l'>Longitude</span><span class="lonmin"></span><span class="lonmax"></span></li>
        <li><span class='l'>Latitude</span><span class="latmin"></span><span class="latmax"></span></li>
    </ul>
</div>
<p style="display:none" class="info2">
  <strong>Shift+click/drag the map</strong> to modify the bounding box.
  Any footprints you select will be retained.
  To begin a new selection, click "Clear Selection.
</p>
"""

class ExtentControl extends Spine.Controller
  constructor: ->
    super arguments...
    throw "@map required" unless @map
    @render()
    @expanded = false
    @f = d3.format(".3f")

    @listenTo @map.bbox, "changed updated", @updateExtent
    if @map.bbox.extent isnt null
      @updateExtent @map.bbox.extent

  events:
    "click a.zoom-to": "zoomToExtent"

  render: ->
    @el.html template
    return

  updateExtent: (e) =>
    if e
      @expand()
      @extent = e
      @formatExtent e
    else
      @contract()

  formatExtent: (e) ->
    @$(".lonmin").text @f(e[0][0])
    @$(".lonmax").text @f(e[1][0]) + "º"
    @$(".latmin").text @f(e[1][1])
    @$(".latmax").text @f(e[0][1]) + "º"

  expand: ->
    return if @expanded
    @expanded = true
    @$("h2").html "Selected area <a class='btn btn-sm zoom-to'>Fit <span class='glyphicon glyphicon-chevron-right'></span></a>"
    @$(".information").hide 400
    @$(".extent").show 400
    @$(".info2").show 400

  contract: ->
    return unless @expanded
    @expanded = false
    @$("h2").html "Select a map area"
    @$(".information").show 400
    @$(".extent").hide 400
    @$(".info2").hide 400

  zoomToExtent: (e)->
    e.stopPropagation()
    @map.zoomTo @map.bbox.extent

module.exports = ExtentControl
