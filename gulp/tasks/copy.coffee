gulp = require("gulp")
config = require("../config")
gulp.task "copy", ->
    gulp.src("#{config.root}/node_modules/bootstrap-sass/assets/fonts/bootstrap/*")
        .pipe gulp.dest("#{config.dist}/styles/fonts")
