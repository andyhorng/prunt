_ = require 'underscore'
UglifyJS = require 'uglify-js'

exports.uglify = (options = {}) ->
  print = exports.util.log 'uglifyJS'
  (files) ->
    maps = []
    files.forEach (file) ->
      print "minifying #{file.filename}"
      {code, map} = UglifyJS.minify file.content,
        fromString: true
        outSourceMap: file.filename or ''
      file.content = code
      maps.push new exports.File
        content: map
        dirname: file.dirname
        filename: "#{file.filename}.map"
    unless options.sourceMap
      files
    else
      _.flatten [files, maps]
