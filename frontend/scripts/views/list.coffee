d3 = require "d3"
Spine = require "spine"
{compile} = require 'handlebars'

f = d3.format ","

listItem = compile """
<span class="id">{{ name }}</span>
<a target='_blank' href="https://ode.rsl.wustl.edu/mars/indexproductpage.aspx?product_id={{ id }}">
  <span class="glyphicon glyphicon-chevron-right"></span>
</a>
"""

template = """
<h2>Footprints</h2>
<div class="total"></div>
<ul></ul>
<div class="selected">
  <span class="number-selected"></span>
  <button class="clear btn btn-warning btn-xs" style="display:none;">
    Clear Selection
  </button>
</div>
"""

class ListView extends Spine.Controller
  constructor: ->
    super arguments...
    throw "@data required" unless @data
    @el.hide()
    @render()
    @listenTo @data, "updated", @refresh
    @listenTo @data, "selection-updated", @updateSelection
    @listenTo @data, "hovered", @onHovered
    if @data.features.length isnt 0
      @refresh @data.features

  events:
    "click .btn.clear": "clearSelection"

  render: ->
    @el.html template

  refresh: (features) =>
    if features.length > 0
      @el.show 400
    @$(".total").text "#{f(features.length)} of #{f(@data.total)} displayed"
    @features = d3.select(@$("ul")[0])
      .selectAll("li")
        .data features, (d) -> d.id

    @features.enter()
      .append("li")
        .html (d) -> listItem name: d.id.slice(0, 15),id: d.id
        .on "click", @data.updateSelection
        .on "mouseover", @data.toggleHovered
        .on "mouseout", @data.toggleHovered

    @features.exit().remove()
    @updateSelection()

  updateSelection: =>
    @features.classed "selected", (d) -> d.selected

    n = @data.selection.length
    @$(".number-selected").text "#{n} selected"
    if n > 0
      @$(".btn.clear").show 400
    else
      @$(".btn.clear").hide 400

  clearSelection: => @data.clearSelection()
  onHovered: =>
    @features.classed "hovered", (d)->d.hovered

module.exports = ListView
