_ = require 'underscore'

exports.join = (options) ->
  print = exports.util.log 'join'
  rename = {exports}
  (files) ->
    content = _.chain(files)
      .pluck('content')
      .reduce (a, b) ->
        '' + a + b
      .value()
    dirname = options.dirname or files[0].dirname
    filename = options.filename or files[0].filename
    [new exports.File {content, dirname, filename}]
