$ = require "jquery"
startApp = require "./app"

window.jQuery = $

$("body").append "<div id='preloader'></div>"
$.ajax
    url: "data/ctx.json"
    dataType: "json"
    success: startApp
    error: (request, textStatus, errorThrown) ->
        console.log textStatus
        console.log errorThrown
