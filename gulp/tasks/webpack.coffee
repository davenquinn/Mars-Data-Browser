## This is incomplete

gulp = require("gulp")
gutil = require("gulp-util")
webpack = require("webpack")
config = require("../config")

config =
    entry: "#{config.dev}/scripts/main.coffee"
    output:
        path: "#{config.dist}/scripts/"
        filename: "app.js"
    module:
        loaders: [
            { test: /\.coffee$/, loader: "coffee-loader" }
        ]



gulp.task "webpack:dist", (callback) ->

    # modify some webpack config options
    myConfig = Object.create(config)
    myConfig.plugins = myConfig.plugins.concat(new webpack.DefinePlugin("process.env":

        # This has effect on the react lib size
        NODE_ENV: JSON.stringify("production")
    ), new webpack.optimize.DedupePlugin(), new webpack.optimize.UglifyJsPlugin())

    # run webpack
    webpack myConfig, (err, stats) ->
        throw new gutil.PluginError("webpack:build", err)    if err
        gutil.log "[webpack:build]", stats.toString(colors: true)
        callback()
        return

    return


# modify some webpack config options
dev_config = Object.create(config)
dev_config.devtool = "sourcemap"
dev_config.debug = true

# create a single instance of the compiler to allow caching
dev_compiler = webpack(dev_config)
gulp.task "webpack:dev", (callback) ->

    # run webpack
    dev_compiler.run (err, stats) ->
        throw new gutil.PluginError("webpack:build-dev", err)    if err
        gutil.log "[webpack:build-dev]", stats.toString(colors: true)
        callback()
        return

    return
