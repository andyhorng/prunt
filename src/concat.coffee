'use strict'
_ = require 'underscore'

exports.concat = (options = {}) ->
  # print = exports.util?.log?('concat')
  print = exports.util.log 'concat'
  (files) ->
    print "joining #{files?.length} files"
    content = _.chain(files)
      .pluck('content')
      .reduce (a, b) ->
        '' + a + b
      .value()
    dirname = options.dirname or files[0].dirname
    filename = options.filename or files[0].filename
    [new exports.File {content, dirname, filename}]
