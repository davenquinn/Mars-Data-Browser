gulp = require("gulp")
sass = require("gulp-sass")
config = require("../config")
gulp_if = require("gulp-if")
cssmin = require('gulp-cssmin')

opts =
    errLogToConsole: true
    sourceComments: 'map'

gulp.task "sass", ->
    gulp.src("#{config.dev}/styles/main.scss")
        .pipe sass
            includePaths: ["#{config.root}/node_modules"]
        .pipe gulp_if(global.isDist,cssmin())
        .pipe gulp.dest("#{config.dist}/styles")
