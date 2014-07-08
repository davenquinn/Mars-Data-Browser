d3 = require "d3"
BaseView = require "./base"

SelectControl = BaseView.extend(
    initialize: (options) ->
        ns = this
        @extent = null
        @active = false
        @selection = null
        @map = options.parent
        @_map = @map._map
        @container = @map.overlay.append("g").attr("class", "selection_container").attr("pointer-events", "all")
        @_map.on "move", (e) ->
            ns.reset()
            return

        d3.select("body").on("keydown", ->
            ns.enable()    if d3.event.shiftKey
            return
        ).on "keyup", ->
            ns.disable()    if d3.event.keyIdentifier is "Shift"
            return

        return

    reset: ->
        return    unless @selection?
        @selection.attr "d", @pathfinder
        return

    enabled: false
    enable: ->
        obj = this
        @onBrush = ->
            f = d3.format(".3f")
            e = obj.control.extent()
            App.extent.onBrush e
            return

        if @selection?
            @selection.remove()
            @selection = null
        @drag = @container.append("g").attr("class", "brush")
        extent = @_map.extent()
        xscale = d3.scale.linear().domain([
            extent[0].lon
            extent[1].lon
        ]).range([
            0
            @map.$el.width()
        ])
        yscale = d3.scale.linear().domain([
            extent[0].lat
            extent[1].lat
        ]).range([
            @map.$el.height()
            0
        ])
        @control = d3.svg.brush().x(xscale).y(yscale).on("brush", @onBrush)
        @control.extent @extent    if @extent?
        @drag.call @control
        @drag.select("rect.background").style "cursor", "crosshair"
        @enabled = true
        return

    disable: ->
        @drag.remove()
        ex = @control.extent()
        @geom =
            type: "Polygon"
            coordinates: [[
                ex[0]
                [
                    ex[0][0]
                    ex[1][1]
                ]
                ex[1]
                [
                    ex[1][0]
                    ex[0][1]
                ]
                ex[0]
            ]]

        @enabled = false
        same = (a, b) ->
            return false    if not a? or not b?
            i = 0

            while i < a.length
                return false    if a[i][0] isnt b[i][0] or a[i][1] isnt b[i][1]
                ++i
            true

        unless same(@extent, ex)
            @extent = ex
            @trigger "area_updated"
        return
)

module.exports = SelectControl
