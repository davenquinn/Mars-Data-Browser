d3 = require "d3"
BaseView = require "../base"
template = require "./template.html"

class ExtentControl extends BaseView
    initialize: ->
        self = this
        @compile template
        @render()
        @expanded = false
        @f = d3.format(".3f")
        @onBrush = (e) ->
            self.expand()    unless self.expanded
            self.formatExtent e
            return

        return

    render: ->
        @$el.html @template()
        return

    formatExtent: (e) ->
        @$(".lonmin").text @f(e[0][0])
        @$(".lonmax").text @f(e[1][0]) + "º"
        @$(".latmin").text @f(e[0][1])
        @$(".latmax").text @f(e[1][1]) + "º"
        return

    expand: ->
        @expanded = true
        @$("h2").text "Map area"
        @$(".information").hide 400
        @$(".extent").show 400
        @$(".info2").show 400

module.exports = ExtentControl
