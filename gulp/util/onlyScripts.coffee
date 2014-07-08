path = require('path')

module.exports = (name) ->
    /(\.(js|coffee)$)/i.test(path.extname(name))
