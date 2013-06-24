'use strict'
cleanCSS = require 'clean-css'

exports.cssmin = (options) ->
  print = exports.util?.log?('cssmin') or (->) # no-op during unit test
  (files) ->
    files.forEach (file) ->
      print "minifying #{file.filename}"
      file.content = cleanCSS.process file.content, options
    files
