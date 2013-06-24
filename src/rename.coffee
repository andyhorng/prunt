_ = require 'underscore'

exports.rename = (options) ->
  print = exports.util?.log?('rename') or (->) # no-op during unit test
  if _.isString options
    (files) ->
      files.map (d) ->
        print "renaming #{d.filename} to #{options}"
        d.rename options
  else if _.isArray options
    (files) ->
      files.forEach (d, i) ->
        name = options[i]
        print "renaming #{d.filename} to #{name}"
        d.rename options[i] if name? and _.isString name
      files
  else if _.isFunction options
    (files) ->
      files.map (d) ->
        name = options d.filename
        print "renaming #{d.filename} to #{name}"
        d.rename name
  else
    # no-op
    d
