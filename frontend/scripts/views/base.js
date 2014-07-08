define([
	"jquery",
	"backbone",
	"handlebars"
	],function($,Backbone, Handlebars){
    BaseView = Backbone.View.extend({
    	assign : function (view, selector) {
    		//http://ianstormtaylor.com/rendering-views-in-backbonejs-isnt-always-simple/
		    view.setElement(this.$(selector)).render();
		},
		remove: function() {
			// Empty the element and remove it from the DOM while preserving events
			$(this.el).empty().detach();
			return this;
		},
		compile: function(template){
			this.template = Handlebars.compile(template);
			return this.template;
		},
		destroy_view: function() {
		    //COMPLETELY UNBIND THE VIEW
		    this.undelegateEvents();
		    this.$el.removeData().unbind(); 
		    //Remove view from DOM
		    this.remove();  
		    Backbone.View.prototype.remove.call(this);
		},
		hide: function(duration){this.$el.hide(duration); this.hidden=true;},
		show: function(duration){this.$el.show(duration); this.hidden=false;}
    });
    return BaseView;
});

