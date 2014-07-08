gulp = require("gulp")
compass = require("gulp-compass")
autoprefixer = require("gulp-autoprefixer")
notify = require("gulp-notify")
handleErrors = require("../util/handleErrors")
config = require("../config")
gulp.task "compass", ->
    compassTask = compass
        css: "#{config.dist}/styles"
        sass: "#{config.dev}/styles"
        image: "#{config.dist}/images"
        require: ['susy', 'breakpoint']

    gulp.src("#{config.dev}/styles/main.scss")
        .pipe compassTask
        .on "error", handleErrors
        .pipe autoprefixer("last 1 version")
        .pipe gulp.dest("#{config.dist}/styles")
