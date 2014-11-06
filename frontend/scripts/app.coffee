$ = require "jquery"
Views = require "./views"
createBbox = require "./util/bbox"

startApp = (data) ->
  $("#preloader").hide()
  window.App =
    state: {}


  App.data =
    raw: createBbox(data)
    getSelected: ->
      App.map.data.features.filter (d) ->
        d.selected
  App.extent = new Views.Extent(el: "#extent")
  App.downloader = new Views.Downloader(el: "#downloader")
  App.map = new Views.Map(el: "#map")
  App.list = new Views.List(el: "#list")

  App.map.setupListeners()
  App.list.setupListeners()

module.exports = startApp
