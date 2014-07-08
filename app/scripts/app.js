define([
	"jquery",
    "views/map",
    "views/extent",
    "views/list",
    "views/downloader",
    "util/bbox"
    ],function($,Map, Extent, ListView, Downloader, createBbox){

    var startApp = function(data){
    	$(".loading").hide();
        window.App = {
            state: {}
        };

        App.data = {
            raw: createBbox(data),
            getSelected: function(){
                return App.map.data.features.filter(function(d){return d.selected});
            }
        };

        App.extent = new Extent({el: "#extent"})
        App.downloader = new Downloader({el: "#downloader"})
        App.map = new Map({el:"#map"});
        App.list = new ListView({el:"#list"});
        App.map.setupListeners();
        App.list.setupListeners();



        //App.extent = new ExtentControl({el:"#extent"});
    };
    return startApp;
});

