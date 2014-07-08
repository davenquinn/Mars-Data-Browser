define([
    "d3",
    "views/base",
    "text!templates/extent.html"
    ],function(d3, BaseView, template){

    ExtentControl = BaseView.extend({
        initialize: function(){
            var self = this;
            this.compile(template);
            this.render();
            this.expanded = false;
            this.f = d3.format(".3f");

            this.onBrush = function(e){
                if (!self.expanded) self.expand();
                self.formatExtent(e);
            };
        },
        render: function(){
            this.$el.html(this.template());
        },
        formatExtent: function(e){
            this.$(".lonmin").text(this.f(e[0][0]));
            this.$(".lonmax").text(this.f(e[1][0])+"º");
            this.$(".latmin").text(this.f(e[0][1]));
            this.$(".latmax").text(this.f(e[1][1])+"º");
        },
        expand: function(){
            this.expanded = true;
            this.$("h2").text("Map area")
            this.$(".information").hide(400);
            this.$(".extent").show(400)
            this.$(".info2").show(400);
        },
        events: {
        }
    });
    return ExtentControl;
});
