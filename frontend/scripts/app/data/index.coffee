Spine = require "spine"
filter = require "./filter"

createBounds = (data) ->
  lat = (c)->c[1]
  lon = (c)->c[0]
  bbox = (a) ->
    a.b = [
      [d3.min(a.c, lon),d3.min(a.c, lat)]
      [d3.max(a.c, lon),d3.max(a.c, lat)]
    ]
    a
  data.map bbox

class DataManager extends Spine.Module
  @extend Spine.Events
  bind: DataManager.bind
  trigger: DataManager.trigger
  constructor: (@dataset, @footprints)->
    super
    @features = []
    @selection = []
    @total = @footprints.length

  updateExtent: (extent)=>
    console.log "Updating extent for data selection"
    if extent
      @features = filter @footprints, extent
    else
      @features = []
    @trigger "updated", @features

  raw: createBounds
  getSelected: =>
    @features.filter (d) -> d.selected

  updateSelection: (d)=>
    # Either adds or removes depending on presence
    d.selected = not d.selected
    if d.selected
      @selection.push d
    else
      i = @selection.indexOf d
      @selection.splice i,1

    @trigger "selection-updated", @features

  clearSelection: =>
    console.log "Clearing Selection"
    @features.forEach (d)-> d.selected = false
    @selection = []
    @trigger "selection-updated", @features

  toggleHovered: (d)=>
    d.hovered = not d.hovered
    @trigger "hovered", d

module.exports = DataManager
