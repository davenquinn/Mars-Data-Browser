gulp = require 'gulp'
config = require "../config"
mkdirp = require "mkdirp"
browserSync = require "browser-sync"

gulp.task "browserSync", ->
	browserSync.init [
		"#{config.dist}/scripts/*"
		"#{config.dist}/styles/*"
	],
	server:
		baseDir: config.dist

gulp.task "copy", ->
  gulp.src config.root+"/node_modules/bootstrap-sass/assets/fonts/bootstrap/*"
    .pipe gulp.dest(config.dist+"/styles/fonts")

gulp.task "watch", ["watchify","browserSync"], ->
	gulp.watch "#{config.dev}/styles/**", ["compass"]

gulp.task 'setDist', ->
    global.isDist = true
    global.dist = true

gulp.task "build", [
  "copy"
  "browserify"
  "compass"
]

gulp.task 'default', [
  'build'
  'watch'
]

gulp.task 'preflight', [
  'setDist'
  'default'
]

gulp.task "dist", [
    "setDist"
    "copy"
    "browserify"
    "compass"
]
