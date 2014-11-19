d3 = require "d3"
Spine = require "spine"
template = require "./template.html"
listItem = require "./list-item.html"

f = d3.format ","

class ListView extends Spine.Controller
  constructor: ->
    super
    throw "@data required" unless @data
    @$el.hide()
    @render()
    @listenTo @data, "updated", @refresh
    @listenTo @data, "selection-updated", @updateSelection
    @listenTo @data, "hovered", @onHovered
    if @data.features.length isnt 0
      @refresh @data.features

  events:
    "click .btn.clear": "clearSelection"

  render: ->
    @$el.html template

  refresh: (features) =>
    if features.length > 0
      @$el.show 400
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
