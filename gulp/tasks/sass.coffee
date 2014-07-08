gulp = require("gulp")
sass = require("gulp-sass")
config = require("../config")
handleErrors = require("../util/handleErrors")

gulp.task "sass", ->
    gulp.src("#{config.dev}/styles/*.scss").pipe sass(
        onError: handleErrors
        sourceComments: 'map'
    ).pipe gulp.dest("#{config.dist}/styles")
