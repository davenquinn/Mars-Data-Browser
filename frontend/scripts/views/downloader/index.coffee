d3 = require "d3"
Spine = require "spine"
moment = require "moment"
template = require "./template.html"
pds_template = require "./pds_file.hbs"

window.jQuery = require "jquery"
require "bootstrap-sass/assets/javascripts/bootstrap/dropdown"

class Downloader extends Spine.Controller
  constructor: ->
    super
    throw "@data required" unless @data
    @pds_template = pds_template
    @render()
    @listenTo @data, "updated selection-updated", @update

  render: ->
    @$el.html template
    @button = @$(".btn-group")
    @button.hide()
    @$el.hide()

  enable: ->
    @$(".information").hide 400
    @button.show 400

  disable: ->
    @$(".information").show 400
    @button.hide 400

  update: =>
    @$el.show()
    if @data.selection.length > 0
      @enable()
    else
      @disable()

  events:
    "click a.simple_list": "simpleList"
    "click a.requirements": "requirements"

  requirements: =>
    d = new Date()
    text = @pds_template
      features: @data.selection
      date: moment().format("YYYY-MM-DDTHH:mm:ss.SSS")
    @download "pds_requirements.txt", text

  simpleList: =>
    fn = (prev, curr) -> prev + curr.id + "\n"
    text = @data.selection.reduce(fn, "")
    @download "#{@data.dataset.id}_footprints.txt", text

  download: (filename, text) ->
    pom = document.createElement("a")
    pom.setAttribute "href", "data:text/plain;charset=utf-8," + encodeURIComponent(text)
    pom.setAttribute "download", filename
    pom.click()

module.exports = Downloader
