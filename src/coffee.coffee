'use strict'
path = require 'path'

CoffeeScript = require 'coffee-script'

exports.coffee = (options = {}) ->
  print = exports.util?.log?('coffee') or (->) # no-op during unit test
  (files) ->
    files.map (d) ->
      {content, filename, dirname} = d
      print "compiling #{filename}"
      options.literate ?= true if path.extname(filename) is '.litcoffee'
      d.content = CoffeeScript.compile content, options
      if options.literate
        d.filename = d.filename.replace '.litcoffee', '.js'
      else
        d.filename = filename.replace '.coffee', '.js'
      d
