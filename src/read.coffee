fs = require 'fs'
path = require 'path'

_ = require 'underscore'
Q = require 'q'
glob = require 'glob'

exports.read = (patterns) ->
  print = exports.util.log 'read'
  patterns = [patterns] unless _.isArray patterns
  Q.when _.flatten patterns
    .map (pattern) ->
      glob
        .sync(pattern)
        .map (file) ->
          print "reading #{file}"
          content = fs.readFileSync file, 'utf-8'
          filename = path.basename file
          dirname = path.dirname file
          new exports.File {content, dirname, filename}
