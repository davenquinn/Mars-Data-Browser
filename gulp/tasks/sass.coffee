gulp = require("gulp")
sass = require("gulp-sass")
config = require("../config")

opts =
    errLogToConsole: true
    sourceComments: 'map'

gulp.task "sass", ->
    gulp.src("#{config.dev}/styles/main.scss")
        .pipe sass
            includePaths: ["#{config.root}/node_modules"]
        .pipe gulp.dest("#{config.dist}/styles")
