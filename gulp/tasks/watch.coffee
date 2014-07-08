gulp = require("gulp")
config = require("../config")
gulp.task "watch", ["setWatch","browserSync"], ->
	gulp.watch "#{config.dev}/styles/**", ["sass"]

# Note: The browserify task handles js recompiling with watchify
