/*var bootstrap_plugins = ["affix","alert","button","carousel","collapse","dropdown","modal","popover","scrollspy","tab","tooltip","transition"];
bootstrap_plugins.map(function(name){
    config.paths["bootstrap."+name] = "../lib/sass-bootstrap/js/"+name;
    config.shim["bootstrap."+name] = ["jquery"];
});*/

require.config({
	"baseUrl": "scripts/",
    "paths": {
    	"templates": "../templates",
        "jquery": "../lib/jquery/jquery",
        "underscore": "../lib/underscore-amd/underscore",
        "backbone": "../lib/backbone-amd/backbone",
        "handlebars": "../lib/handlebars/handlebars",
        "polymaps": "../lib/polymaps/polymaps",
        "d3": "../lib/d3/d3",
        "d3.geo.tile": "../lib/d3-plugins/geo/tile/tile",
        "moment": "../lib/moment/moment",
        "text" : "../lib/requirejs-text/text",
        "bootstrap.dropdown": "../lib/sass-bootstrap/js/dropdown"
    },
    "shim": {
         'handlebars': {
            exports: 'Handlebars'
        },
        "d3": {
            exports: 'd3'
        },
        "polymaps": {
            exports: 'org.polymaps'
        },
        "d3.geo.tile": ["d3"],
        "bootstrap.dropdown": ["jquery"]
    },
    "stubModules": ["text"]
});