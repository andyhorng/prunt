CoffeeScript = require 'coffee-script'

exports.coffee = (options = {}) ->
  print = exports.util.log 'coffee'
  (files) ->
    files.map (d) ->
      {content, filename, dirname} = d
      print "compiling #{filename}"
      options.literate ?= true if filename.match /.litcoffee/
      d.content = CoffeeScript.compile content, options
      d.filename = filename.replace '.coffee', '.js'
      d
