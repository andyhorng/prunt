'use strict'
jade = require 'jade'

print = exports.util?.log?('jade') or (->) # no-op during unit test
exports.jade = (locals = {}, options = {}) ->
  (files) ->
    files.forEach (file)->
      print "compiling #{filename}"
      {content, filename, dirname} = file

      file.content = jade.compile(content, options)(locals)
      file.filename = filename.replace '.jade', '.html'
    files
