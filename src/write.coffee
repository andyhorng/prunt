'use strict'
fs = require 'fs'
path = require 'path'

exports.write = (options = {}) ->
  print = exports.util.log 'write'
  (files) ->
    files.forEach (file) ->
      {content, filename, dirname} = file
      print "writing #{filename}"
      filename = path.normalize path.join dirname, filename
      fs.writeFileSync filename, content, 'utf-8', (error) ->
        throw error if error
      file.isDirty = false
    files
