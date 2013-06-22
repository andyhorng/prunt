_ = require 'underscore'

exports.rename = (options) ->
  print = exports.util.log 'rename'
  if _.isString options
    (files) ->
      files.map (d) ->
        d.filename = options
  else if _.isArray options
    (files) ->
      files.forEach (d, i) ->
        name = options[i]
        d.filename = options[i] if name? and _.isString name
      files
  else if _.isFunction options
    (files) ->
      files.map options
  else
    # no-op
    d
