browserify = require("browserify")
watchify = require("watchify")
bundleLogger = require("../util/bundleLogger")
gulp = require("gulp")
handleErrors = require("../util/handleErrors")
source = require("vinyl-source-stream")
coffeeify = require("coffeeify")
hbsfy = require("hbsfy").configure
	extensions: ["html", "hbs"]
config = require('../config')
chalk = require "chalk"

setupEndpoint = (name,location,watching=false) ->
	console.log "[#{chalk.blue("Browserify")}] #{location} ➔ #{config.dist}/scripts/#{name}.min.js"

	bundler = browserify
		entries: [location]
		extensions: [".coffee"]
		debug: (if global.dist then false else true)
    #cache: {}
    #packageCache: {}
    #fullPaths: true

	if watching
		bundler = watchify(bundler)

	bundler.transform coffeeify
	bundler.transform hbsfy

	if global.dist
		bundler.transform {global: true}, 'uglifyify'

	bundle = ->
		bundleLogger.start()
		bundler.bundle()
			.on("error", handleErrors)
			.on "end", bundleLogger.end
			.pipe(source("#{name}.min.js"))
			.pipe(gulp.dest("#{config.dist}/scripts/"))

	# Rebundle with watchify on changes
	if watching
		bundler.on "update", bundle
	bundle()

gulp.task "browserify", ->
	setupEndpoint("main", config.dev+"/scripts/main", false)

gulp.task "watchify", ->
	setupEndpoint("main", config.dev+"/scripts/main", true)
