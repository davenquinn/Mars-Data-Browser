d3 = require "d3"
Spine = require "spine"
moment = require "moment"
{compile} = require 'handlebars'
download = require 'downloadjs'

template = """
<div class="information" style="display:none;"><strong>Select some footprints in order to download data!</strong> You can do this by clicking footprints either in the list above or on the map.</div>
<div class="btn-group">
  <button type="button" class="btn btn-success dropdown-toggle btn-block btn-lg" data-toggle="dropdown">
    Get Data<span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">
    <li><a href="#" class="simple_list">List of image IDs</a></li>
    <li><a href="#" class="requirements">PDS Requirements File</a></li>
  </ul>
</div>
"""

pds_template = compile """
#Date Report Generated: {{date}}
#INSTRUMENT,	TYPE,	PRODUCT ID,	OBSERVATION TIME,	CENTER LATITUDE (IF AVAILABLE),	CENTER LONGITUDE (IF AVAILABLE),	ORBITAL DATA EXPLORER PRODUCT LINK,	ORBITAL DATA EXPLORER PRODUCT FILES LINK
{{#each features}}
MRO CTX,	EDR,	{{id}},	,	,	,	http://ode.rsl.wustl.edu/mars/indexproductpage.aspx?product_id={{id}},	http://ode.rsl.wustl.edu/mars/productfiles.aspx?product_id={{id}}
{{/each}}
"""

window.jQuery = require "jquery"
require "bootstrap-sass/assets/javascripts/bootstrap/dropdown"

class Downloader extends Spine.Controller
  constructor: ->
    super arguments...
    throw "@data required" unless @data
    @pds_template = pds_template
    @render()
    @listenTo @data, "updated selection-updated", @update

  render: ->
    @el.html template
    @button = @$(".btn-group")
    @button.hide()
    @el.hide()

  enable: ->
    @$(".information").hide 400
    @button.show 400

  disable: ->
    @$(".information").show 400
    @button.hide 400

  update: =>
    @el.show()
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
    console.log "Downloading #{filename}"
    download(text, filename, 'text/plain')

module.exports = Downloader
