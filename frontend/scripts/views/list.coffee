d3 = require "d3"
BaseView = require "./base"

class ListView extends BaseView
    initialize: ->
        self = this
        @hide()
        @render()

    events:
        "click .btn.clear": "clearSelection"

    render: ->
        obj = this
        el = d3.select(@el)
        el.html "<h2>Footprints</h2>"
        @_ul = el.append("ul")
        @total = el.append("div").attr("class", "total")
        @sel = el.append("div").attr("class", "selected").append("span")
        @$("div.selected").append "<button class=\"clear btn btn-warning btn-xs\" style=\"display:none;\">Clear Selection</button>"
        @refresh()
        return

    setupListeners: ->
        @listenTo App.map.selection, "area_updated", @refresh
        @listenTo App.map, "selection_updated", @updateSelection
        return

    refresh: ->
        self = this
        data = App.map.data.features
        if data.length > 0
            @show 400
            App.downloader.show()
        @total.text data.length + " displayed"
        @footprints = @_ul.selectAll("li").data(data, (d) ->
            d.id
        )
        @footprints.enter().append("li").html((d) ->
            d.id.slice(0, 15) + "<a target='_blank' href='http://ode.rsl.wustl.edu/mars/indexproductpage.aspx?product_id=" + d.id + "'><span class='glyphicon glyphicon-share'></span></a>"
        ).on "click", (d) ->
            return false    if d3.event.toElement isnt this
            d.selected = (if d.selected then false else true)
            self.updateSelection()
            self.trigger "selection_updated"
            return

        @footprints.exit().remove()
        @updateSelection()
        return

    updateSelection: ->
        @footprints.attr "class", (d) ->
            if d.selected
                "selected"
            else
                null

        n = App.map.data.features.filter((d) ->
            d.selected
        ).length

        #s = (n === 1) ? "":"s";
        @sel.text n + " selected"
        if n > 0
            App.downloader.enable()
            @$(".btn.clear").show 400
        else
            App.downloader.disable()
            @$(".btn.clear").hide 400
        return

    clearSelection: ->
        App.map.data.features = App.map.data.features.map((d) ->
            d.selected = false
            d
        )
        @trigger "selection_updated"
        @refresh()
        return

module.exports = ListView
