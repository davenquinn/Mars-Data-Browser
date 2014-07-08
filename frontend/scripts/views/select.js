 define([
    "d3",
    "views/base"
    ],function(d3, BaseView){

    SelectControl = BaseView.extend({
        initialize: function(options){
            ns = this;
            this.extent = null;
            this.active = false;
            this.selection = null;
            this.map = options.parent;
            this._map = this.map._map;
            this.container = this.map.overlay.append("g")
                .attr("class", "selection_container")
                .attr("pointer-events", "all");                

            this._map.on("move",function(e){
                ns.reset()
            });
            
            d3.select("body")
                .on("keydown", function(){if (d3.event.shiftKey) ns.enable()})
                .on("keyup",function(){if (d3.event.keyIdentifier === "Shift") ns.disable()});


        },
        reset: function() {
            if (this.selection == null) return;
            this.selection.attr("d", this.pathfinder);               
        },
        enabled: false,
        enable: function(){
            obj = this;

            this.onBrush = function(){
                var f = d3.format(".3f");
                var e = obj.control.extent();
                App.extent.onBrush(e);
            };

            if (this.selection != null) {
                this.selection.remove()
                this.selection = null
            }
            this.drag = this.container.append("g")
                .attr("class", "brush");

            extent = this._map.extent();
            xscale = d3.scale.linear()
                .domain([extent[0].lon, extent[1].lon])
                .range([0, this.map.$el.width()]);
            yscale = d3.scale.linear()
                .domain([extent[0].lat, extent[1].lat])
                .range([this.map.$el.height(), 0]);
            this.control = d3.svg.brush()
                .x(xscale)
                .y(yscale)
                .on("brush", this.onBrush)

            if (this.extent != null) {
                this.control.extent(this.extent)
            }
            this.drag.call(this.control)
            this.drag.select("rect.background").style("cursor","crosshair")
            this.enabled = true


        },
        disable: function(){
            this.drag.remove()

            ex = this.control.extent()
            this.geom = {
                type: "Polygon",
                coordinates: [[ex[0],[ex[0][0],ex[1][1]],ex[1],[ex[1][0],ex[0][1]],ex[0]]]
            }
            this.enabled = false

            var same = function(a,b){
                if (a == null || b == null) return false;
                for (var i = 0; i < a.length; ++i) {
                    if (a[i][0] !== b[i][0] || a[i][1] !== b[i][1]) return false;
                }
                return true;
            };

            if (!same(this.extent,ex)) {
                this.extent = ex;
                this.trigger("area_updated")
            }
        }
    });
    return SelectControl;
});