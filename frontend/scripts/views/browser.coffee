$ = require "jquery"
Spine = require "spine"

ListControl = require "./list"
DownloadControl = require "./downloader"

template = """
<div id="list"></div>
<div id="downloader"></div>
"""

class DataBrowser extends Spine.Controller
  constructor: ->
    super arguments...
    throw "@data required" unless @data
    @el.html template
    @list = new ListControl
      el: "#list"
      data: @data
    @downloader = new DownloadControl
      el: "#downloader"
      data: @data

module.exports = DataBrowser
