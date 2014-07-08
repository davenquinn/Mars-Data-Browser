define [
	"jquery"
	"views/map"
	"views/extent"
	"views/list"
	"views/downloader"
	"util/bbox"
], ($, Map, Extent, ListView, Downloader, createBbox) ->
	startApp = (data) ->
		$(".loading").hide()
		window.App = state: {}
		App.data =
			raw: createBbox(data)
			getSelected: ->
				App.map.data.features.filter (d) ->
					d.selected


		App.extent = new Extent(el: "#extent")
		App.downloader = new Downloader(el: "#downloader")
		App.map = new Map(el: "#map")
		App.list = new ListView(el: "#list")
		App.map.setupListeners()
		App.list.setupListeners()
		return


	#App.extent = new ExtentControl({el:"#extent"});
	startApp
