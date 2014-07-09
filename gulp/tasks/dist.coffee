gulp = require("gulp")

gulp.task 'setDist', ->
    global.isDist = true

gulp.task "dist", [
    "setDist"
    "copy"
    "browserify"
    "sass"
]
