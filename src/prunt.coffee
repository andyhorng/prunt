'use strict'
path = require 'path'
util = require 'util'

_ = require 'underscore'

exports.util = {}
exports.util.log = (moduleName) ->
  (msg) ->
    util.log "<#{moduleName}> #{msg}"

class exports.File
  Object.defineProperty @::, 'content',
    get: ->
      @_content
    set: (@_content) ->
      @isDirty = true
  constructor: ({@content, @dirname, @filename}) ->
  rename: (@filename) ->
    @
  chdir: (dir) ->
    @dirname = path.resolve process.cwd(), dir
    @

partial = (f) ->
  (args...) ->
    (files) ->
      args.unshift files
      res = f.apply(files, args)
      res = [res] unless _.isArray res
      res

# _ collection mathods
['map', 'reduce', 'reduceRight', 'find', 'filter', 'where', 'findWhere', 'reject', 'sortBy'].forEach (key) ->
  exports[key] = partial _[key]

# _ array methods
['first', 'initial', 'last', 'rest', 'compact', 'flatten'].forEach (key) ->
  exports[key] = partial _[key]

exports.each = (f) ->
  (files) ->
    files.forEach f
    files

exports.invoke = (method, args...) ->
  (files) ->
    files.forEach (file) ->
      file[method]?.apply file, args
    files
