$ = require "jquery"
startApp = require "./app"

window.jQuery = $

$("body").append "<img class='loading' src='images/ajax-loader.gif' />"
$.ajax
    url: "data.json"
    dataType: "json"
    success: startApp
    error: (request, textStatus, errorThrown) ->
        console.log textStatus
        console.log errorThrown
