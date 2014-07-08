define([
    'jquery',
	'backbone',
	'app'
	],function($,Backbone,startApp){
        $("body").append("<img class='loading' src='images/ajax-loader.gif' />");
        $.ajax({
            url: "data/data.json",
            dataType:"json",
            success: startApp,
            error: function(request, textStatus, errorThrown) {
                console.log(textStatus);
                console.log(errorThrown);
            }
        });

});
