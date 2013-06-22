fs = require 'fs'

exports.write = (options = {}) ->
  print = exports.util.log 'write'
  (files) ->
    files.forEach (file) ->
      {content, filename, dirname} = file
      print "writing #{filename}"
      fs.writeFileSync filename, content, 'utf-8', (error) ->
        throw error if error
    files
