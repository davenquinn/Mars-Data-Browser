define [
  "d3"
  "views/base"
  "handlebars"
  "moment"
  "text!templates/downloader.html"
  "text!templates/pds_file.txt"
  "bootstrap.dropdown"
], (d3, BaseView, Handlebars, moment, template, pds_template) ->
  Downloader = BaseView.extend(
    initialize: (options) ->
      @compile template
      @pds_template = Handlebars.compile(pds_template)
      @render()
      return

    render: ->
      @$el.html @template()
      @button = @$(".btn-group")
      @button.hide()
      @hide()
      return

    enable: ->
      @$(".information").hide 400
      @button.show 400
      return

    disable: ->
      @$(".information").show 400
      @button.hide 400
      return

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
      return

    simpleList: ->
      selected = App.data.getSelected()
      text = selected.reduce((prev, curr) ->
        prev + curr.id + "\n"
      , "")
      @download "ctx_footprints.txt", text
      return

    download: (filename, text) ->
      pom = document.createElement("a")
      pom.setAttribute "href", "data:text/plain;charset=utf-8," + encodeURIComponent(text)
      pom.setAttribute "download", filename
      pom.click()
      return
  )
  Downloader
