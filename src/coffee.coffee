'use strict'

{exec} = require 'child_process'
path = require 'path'

print = exports.util?.log?('coffee') or (->) # no-op during unit test
Q = require 'q'

compile = (file, options) ->
  deferred = Q.defer()

  {content, filename, dirname} = file

  options.literate ?= true if path.extname(filename) is '.litcoffee'

  print "compiling #{filename}"

  cp = undefined

  if options.literate
    file.filename = filename.replace '.litcoffee', '.js'
    cp = exec 'coffee --literate --stdio --compile'
  else
    file.filename = filename.replace '.coffee', '.js'
    cp = exec 'coffee --stdio --compile'


  out = ''
  cp.stdout.on 'data', (chunk) ->
    out += chunk.toString()

  err = ''
  cp.stderr.on 'data', (chunk) ->
    err += chunk.toString()

  cp.on 'exit', ->
    # throw new Error 'WAT'
    if err isnt ''
      deferred.reject new Error err
    else
      file.content = out

    deferred.resolve file

  cp.stdin.end content

  deferred.promise

exports.coffee = (options = {}) ->
  (files) ->
    queue = files.map (file) ->
      compile file, options
    Q.all(queue)
