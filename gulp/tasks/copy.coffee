gulp = require("gulp")
config = require("../config")
mkdirp = require("mkdirp")

gulp.task "copy", ->
  data_dir = config.dist+"/data/"
  mkdirp data_dir
  gulp.src "#{config.root}/data/build/*"
    .pipe gulp.dest(data_dir)
  gulp.src config.root+"/node_modules/bootstrap-sass/assets/fonts/bootstrap/*"
    .pipe gulp.dest(config.dist+"/styles/fonts")
