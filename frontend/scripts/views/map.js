define([
    "d3",
    "views/base",
    "polymaps",
    "views/select",
    "util/data"
    ],function(d3, BaseView, po, SelectControl,filterData){

    var Map = BaseView.extend({
        initialize: function(){
            var self = this;
            this.data = {"features":[]};
            this.render();
            this._focused = null;
            this.selectionActive = false;
        },
        render: function(){
            var self = this;
            this.createMap();
            attr = '<div class="attribution">Tiles: <a href="https://www.mapbox.com/blog/2012-08-26-mapping-mars/">Mapbox</a> | <a href="astrogeology.usgs.gov">USGS</a></div>'
            this.$el.append(attr)
            this.setupLayer();
            this.selection = new SelectControl({parent: this});
            this.listenTo(this.selection,"area_updated", function(){
                this.data = filterData(App.data.raw,this.selection.extent);
                this.refresh(this.data);
            });
        },
        setupListeners: function(){
            this.listenTo(App.list,"selection_updated", this.updateSelection);
        },
        createMap: function(){
            
            this._map = po.map()
                .container(this.el.appendChild(po.svg("svg")))
                .center({lat: 0,lon: 0})
                .zoom(5)
                .zoomRange([4, 8])
                .add(po.interact());

            url = po.url("http://{S}.tiles.mapbox.com/v3/herwig.map-tly29w1z/{Z}/{X}/{Y}.png")
                .hosts(["a", "b", "c", "d"])

              // http://a.tiles.mapbox.com/v3/herwig.map-tly29w1z.html#5/19.808/440.332

            this._map.add(po.image().url(url))

            svg = d3.select("#map svg");
            this.overlay = svg.insert("svg:g").attr("class", "overlay")

        },
        pathfinder: function(){
            ns = this;
            var projectPoint = function(x,y) {
                d = ns._map.locationPoint({lon: x, lat: y});
                this.stream.point(d.x, d.y);
            };
            return d3.geo.path().projection(d3.geo.transform({point: projectPoint}))
        }(),
        refresh: function(data){
            self = this;
            this.features = this.footprints.selectAll("path")
                .data(data.features, function(d){return d.id});
            this.features.enter()
                .append("path")
                .attr("d", this.pathfinder)
                .on("click",function(d){
                    d.selected = d.selected ? false:true
                    self.updateSelection()
                    self.trigger("selection_updated")
                });
            this.features.exit().remove();
            this.updateSelection()
        },
        setupLayer: function(){
            var self = this;
            //bounds = this.pathfinder.bounds(data);
            this.footprints = this.overlay.append("g").attr("class","footprints")
            this.refresh(this.data);

            function reset() {
                self.features.attr("d", self.pathfinder);
            }

            reset();

            this._map.on("move", function() {
                reset();
            });
        },
        updateSelection: function(){
            this.features.attr("class", function(d){
                if (d.selected) return "selected";
                else return null;
            });
        }        
    });
    return Map;
});
