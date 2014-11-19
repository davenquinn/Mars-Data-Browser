$ = require "jquery"
window.jQuery = $
Spine = require "spine"
require "spine/lib/route"
Spine.jQuery = $

App = require "./app"

window.app = new App

Spine.Route.setup()
