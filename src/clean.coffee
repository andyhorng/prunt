'use strict'
fs = require 'fs'
path = require 'path'

rimraf = require 'rimraf'

exports.clean = ->
  print = exports.util.log 'clean'
  (files) ->
    files.forEach (file) ->
      {filename, dirname} = file
      filename = path.normalize path.join dirname, filename
      print "deleting #{filename}"
      rimraf.sync filename
    []
