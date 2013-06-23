_ = require 'underscore'

exports.rename = (options) ->
  print = exports.util?.log?('rename') or (->) # no-op during unit test
  if _.isString options
    (files) ->
      files.map (d) ->
        d.rename options
  else if _.isArray options
    (files) ->
      files.forEach (d, i) ->
        name = options[i]
        d.rename options[i] if name? and _.isString name
      files
  else if _.isFunction options
    (files) ->
      files.map (d) ->
        d.rename options d.filename
  else
    # no-op
    d
