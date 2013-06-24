'use strict'
fs = require 'fs'
path = require 'path'

exports.clean = ->
  print = exports.util.log 'clean'
  (files) ->
    files.forEach (file) ->
      {filename, dirname} = file
      filename = path.normalize path.join dirname, filename
      print "deleting #{filename}"
      stat = fs.statSync filename
      if stat.isFile()
        fs.unlinkSync filename
      else if stat.isDirectory()
        fs.rmdirSync filename
    []
