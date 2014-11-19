gulp = require("gulp")
plumber = require("gulp-plumber")
compass = require("gulp-compass")
autoprefixer = require("gulp-autoprefixer")
notify = require("gulp-notify")
handleErrors = require("../util/handleErrors")
config = require("../config")
cssmin = require("gulp-cssmin")

gulp.task "compass", ->
    debug = if global.dist then false else true
    console.log "Debug is",debug
    pipeline = gulp.src("./#{config.dev}/styles/*.scss")
        .pipe plumber()
        .pipe compass
            css: "#{config.dist}/styles"
            sass: "#{config.dev}/styles"
            image: "#{config.dist}/images"
            require: []
            sourcemap: debug
            debug: debug
            import_path: "node_modules"
        .pipe autoprefixer("last 1 version")
        .on "error", handleErrors

    if not debug
        pipeline = pipeline.pipe(cssmin())

    pipeline.pipe gulp.dest("#{config.dist}/styles")

