gulp = require("gulp")
config = require("../config")
gulp.task "copy", ->
    gulp.src("#{config.dev}/htdocs").pipe gulp.dest(config.dist)
