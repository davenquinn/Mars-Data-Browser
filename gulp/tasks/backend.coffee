spawn = require('child_process').spawn
gulp = require('gulp')
chalk = require('chalk')

prefix = "[#{chalk.blue("Flask")}] "

print = (data)->
    data = data.toString('utf8')
    console.log prefix+data.slice(0,data.length-1)

gulp.task 'backend', ->
    child = spawn(
        "python"
        ["-m","CRISM","serve"]
        cwd: process.cwd()
    )

    child.on 'exit',(code, signal) ->
        print "Process quit unexpectedly "

    on_exit = ->
        child.kill("SIGINT")
        process.exit(0)

    child.stdout.on "data", print
    child.stderr.on "data", print
    process.on('SIGINT',on_exit)
    process.on('exit',on_exit)
