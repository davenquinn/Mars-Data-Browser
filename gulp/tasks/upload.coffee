gulp = require("gulp")
exec = require('child_process').exec
config = require("../config")
chalk = require("chalk")

prefix = "[#{chalk.blue('Upload')}]"

print = (data)->
    data = data
        .toString('utf8')
        .trim()
        .replace("\n", "\n"+prefix)
    console.log prefix+" "+data

gulp.task "upload", ["dist"], ->
    child = exec "rsync -av --delete #{config.dist}/ lewis:www/ctx", (e,stdout) ->
        print stdout
