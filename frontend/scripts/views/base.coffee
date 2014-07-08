$ = require "jquery"
Backbone = require "backbone"
Handlebars = require "handlebars"

BaseView = Backbone.View.extend(
	assign: (view, selector) ->

		#http://ianstormtaylor.com/rendering-views-in-backbonejs-isnt-always-simple/
		view.setElement(@$(selector)).render()
		return

	remove: ->

		# Empty the element and remove it from the DOM while preserving events
		$(@el).empty().detach()
		this

	compile: (template) ->
		@template = Handlebars.compile(template)
		@template

	destroy_view: ->

		#COMPLETELY UNBIND THE VIEW
		@undelegateEvents()
		@$el.removeData().unbind()

		#Remove view from DOM
		@remove()
		Backbone.View::remove.call this
		return

	hide: (duration) ->
		@$el.hide duration
		@hidden = true
		return

	show: (duration) ->
		@$el.show duration
		@hidden = false
		return
)

module.exports = BaseView
