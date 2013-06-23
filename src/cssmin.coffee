cleanCSS = require 'clean-css'

exports.cssmin = (options) ->
  (files) ->
    files.forEach (file) ->
      file.content = cleanCSS.process file.content, options
    files
