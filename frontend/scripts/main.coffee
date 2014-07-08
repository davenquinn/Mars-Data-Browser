define [
    "jquery"
    "backbone"
    "app"
], ($, Backbone, startApp) ->
    $("body").append "<img class='loading' src='images/ajax-loader.gif' />"
    $.ajax
        url: "data/data.json"
        dataType: "json"
        success: startApp
        error: (request, textStatus, errorThrown) ->
            console.log textStatus
            console.log errorThrown
            return

    return
