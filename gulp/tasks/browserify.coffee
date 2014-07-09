browserify = require("browserify")
watchify = require("watchify")
bundleLogger = require("../util/bundleLogger")
gulp = require("gulp")
handleErrors = require("../util/handleErrors")
source = require("vinyl-source-stream")
coffeeify = require("coffeeify")
handlebars = require('browserify-handlebars')
uglifyify = require('uglifyify')

config = require('../config')

gulp.task "browserify", ->
	debug = true
	bundleMethod = (if global.isWatching then watchify else browserify)
	bundler = bundleMethod
		entries: ["#{config.dev}/scripts/main"]
		extensions: [".coffee"]
	bundler.transform(coffeeify)
	bundler.transform(handlebars)

	if global.isDist
		debug = false
		bundler.transform(uglifyify)

	bundle = ->
		bundleLogger.start()
		bundler
			.bundle({debug:debug})
			.on("error", handleErrors)
			.pipe(source("main.js"))
			.pipe(gulp.dest("#{config.dist}/scripts/"))
			.on "end", bundleLogger.end


	# Rebundle with watchify on changes
	if global.isWatching
		bundler.on "update", bundle
	bundle()
