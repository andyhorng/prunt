fs = require 'fs'
path = require 'path'
util = require 'util'

exports.util = {}
exports.util.log = (moduleName) ->
  (msg) ->
    util.format '%s: %s', moduleName, msg

class exports.File
  constructor: ({@content, @dirname, @filename}) ->
