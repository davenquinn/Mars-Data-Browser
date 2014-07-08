fs = require('fs')
onlyScripts = require('./util/onlyScripts')

tasksDir = "#{__dirname}/tasks/"
tasks = fs.readdirSync(tasksDir).filter onlyScripts
require('./tasks/' + task) for task in tasks
