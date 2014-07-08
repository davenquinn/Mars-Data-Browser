d3 = require "d3"
BaseView = require "../base"
moment = require "moment"
template = require "./template.html"
pds_template = require "./pds_file.hbs"

window.jQuery = require "jquery"
require "bootstrap-sass/assets/javascripts/bootstrap/dropdown"

class Downloader extends BaseView
    initialize: (options) ->
        @template = template
        @pds_template = pds_template
        @render()

    render: ->
        @$el.html @template()
        @button = @$(".btn-group")
        @button.hide()
        @hide()

    enable: ->
        @$(".information").hide 400
        @button.show 400

    disable: ->
        @$(".information").show 400
        @button.hide 400

    events:
        "click a.simple_list": "simpleList"
        "click a.requirements": "requirements"

    requirements: ->
        selected = App.data.getSelected()
        d = new Date()
        text = @pds_template(
            features: selected
            date: moment().format("YYYY-MM-DDTHH:mm:ss.SSS")
        )
        @download "pds_requirements.txt", text

    simpleList: ->
        selected = App.data.getSelected()
        text = selected.reduce((prev, curr) ->
            prev + curr.id + "\n"
        , "")
        @download "ctx_footprints.txt", text

    download: (filename, text) ->
        pom = document.createElement("a")
        pom.setAttribute "href", "data:text/plain;charset=utf-8," + encodeURIComponent(text)
        pom.setAttribute "download", filename
        pom.click()

module.exports = Downloader
