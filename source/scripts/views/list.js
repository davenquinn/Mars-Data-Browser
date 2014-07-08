define([
    "d3",
    "views/base",
    "text!templates/list.html" 
    ],function(d3, BaseView, template){

    ListView = BaseView.extend({
        initialize: function(){
            self = this;
            this.hide();
            this.render();
        },
        "events": {
            "click .btn.clear": "clearSelection"
        },
        render: function(){
            obj = this;
            el = d3.select(this.el)
            el.html("<h2>Footprints</h2>")
            this._ul = el.append("ul")
            this.total = el.append("div").attr("class","total")
            this.sel = el.append("div")
                .attr("class","selected")
                .append("span")

            this.$("div.selected").append('<button class="clear btn btn-warning btn-xs" style="display:none;">Clear Selection</button>')
            this.refresh();    
        },
        setupListeners: function(){
            this.listenTo(App.map.selection,"area_updated",this.refresh)
            this.listenTo(App.map,"selection_updated",this.updateSelection)
        },
        refresh: function(){
            self = this;
            var data = App.map.data.features;
            if (data.length > 0) {
                this.show(400);
                App.downloader.show();
            }
            this.total.text(data.length+" displayed")
            this.footprints = this._ul.selectAll("li")
                .data(data, function(d){return d.id})
            this.footprints.enter()
                .append("li")
                .html(function(d){
                    return d.id.slice(0,15)+
                    "<a target='_blank' href='http://ode.rsl.wustl.edu/mars/indexproductpage.aspx?product_id="
                    +d.id+"'><span class='glyphicon glyphicon-share'></span></a>";
                })
                .on("click",function(d){
                    if (d3.event.toElement !== this) return false;
                    d.selected = d.selected ? false:true;
                    self.updateSelection();
                    self.trigger("selection_updated")
                });
            this.footprints.exit().remove();
            this.updateSelection();
        },
        updateSelection: function(){
            this.footprints.attr("class", function(d){
                if (d.selected) return "selected";
                else return null;
            });
            n = App.map.data.features.filter(function(d){return d.selected}).length;
            //s = (n === 1) ? "":"s";
            this.sel.text(n +" selected");
            if (n > 0) {
                App.downloader.enable();
                this.$(".btn.clear").show(400);
            } else {
                App.downloader.disable();
                this.$(".btn.clear").hide(400);
            }
        },
        clearSelection: function(){
            App.map.data.features = App.map.data.features.map(function(d){
                d.selected = false;
                return d
            });
            this.trigger("selection_updated")
            this.refresh();
        }
    });
    return ListView;
});
