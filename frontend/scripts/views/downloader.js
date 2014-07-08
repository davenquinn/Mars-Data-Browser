define([
    "d3",
    "views/base",
    "handlebars",
    "moment",
    "text!templates/downloader.html",
    "text!templates/pds_file.txt",
    "bootstrap.dropdown"
    ],function(d3, BaseView, Handlebars, moment, template, pds_template){

    Downloader = BaseView.extend({
        initialize: function(options){
            this.compile(template);
            this.pds_template = Handlebars.compile(pds_template);

            this.render();
        },
        render: function(){
            this.$el.html(this.template());
            this.button = this.$(".btn-group");
            this.button.hide();
            this.hide();
        },
        enable: function(){
            this.$(".information").hide(400);
            this.button.show(400);
        },
        disable: function(){
            this.$(".information").show(400);
            this.button.hide(400);
        },
        events: {
            "click a.simple_list": "simpleList",
            "click a.requirements": "requirements"
        },
        requirements: function(){
            selected = App.data.getSelected();
            var d = new Date();
            text = this.pds_template({
                features: selected,
                date: moment().format("YYYY-MM-DDTHH:mm:ss.SSS")
            });
            this.download("pds_requirements.txt", text)
        },
        simpleList: function(){
            selected = App.data.getSelected();
            text = selected.reduce(function(prev,curr){return prev+curr.id+"\n"},"");
            this.download("ctx_footprints.txt", text)
        },
        download: function(filename,text){
            var pom = document.createElement('a');
            pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
            pom.setAttribute('download', filename);
            pom.click();
        }
    });
    return Downloader;
});
