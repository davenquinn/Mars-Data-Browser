$ = require "jquery"
Spine = require "spine"

Map = require "../views/map"
DataManager = require "./data"
ExtentControl = require "../views/extent"
DataBrowser = require "../views/browser"
{compile} = require 'handlebars'

options = require "./options"

loading = compile """
<div id="loading">
  <h4>Loading {{name}} data</h4>
  <div id="preloader-bars">
      <span></span>
      <span></span>
      <span></span>
      <span></span>
      <span></span>
  </div>
</div>
"""

class TitleControl extends Spine.Controller
  constructor: ->
    super arguments...
    @normal = @$el.text()
  set: (name)=>
    name = if name? then "<a href='#/'>Mars data</a>: <b>#{name}</b>" else @normal
    @$el.html name

class App extends Spine.Controller
  data: {}
  constructor: ->
    super el: "#main"
    @title = new TitleControl el: @$("h1")
    @map = new Map(el: "#map")
    @_browser = @$ "#browser"
    @routes
      "/": => @setupOrigin()
      "/hirise": => @prepareDataset options.datasets.HiRISE
      "/ctx": => @prepareDataset options.datasets.CTX

    @extent = new ExtentControl
      el: @$ "#extent"
      map: @map

  setupOrigin: ->
    @title.set()
    @_browser.empty()
    @map.clearFeatures()
    @$("#info").show 300

  prepareDataset: (ds)=>

    @$("#info").hide 300
    @title.set ds.name
    if ds.id of @data
      @viewDataset ds
    else
      @_browser.html loading
        name: ds.name
      $.ajax
        url: "data/#{ds.id}.json"
        dataType: "json"
        success: (rawData)=>
          @data[ds.id] = new DataManager ds, rawData
          @_browser.empty()
          @viewDataset ds
        error: (request, textStatus, errorThrown) ->
          @$("#preloader-bars").remove()
          @_browser.append "<p class='error'>There
            was an error: #{textStatus}</p>"

  viewDataset: (ds)=>
    @log "Preparing dataset for viewing"
    @map.addData @data[ds.id]
    @browser = new DataBrowser
      el: @_browser
      data: @data[ds.id]
      dataset: ds





module.exports = App
