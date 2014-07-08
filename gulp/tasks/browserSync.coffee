browserSync = require("browser-sync")
config = require("../config")
gulp = require("gulp")
gulp.task "browserSync", ["build"], ->
	browserSync.init [
		"#{config.dist}/scripts/*"
		"#{config.dist}/styles/*"
	],
	server:
		baseDir: config.dist
