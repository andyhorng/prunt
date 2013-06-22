{read, write, coffee, join} = require './index.js'

task 'build', 'build prunt', ->
  read('src/*.coffee')
    .then(join({filename: 'index.coffee'}))
    .then(coffee())
    .then (files) ->
      files.map (d) ->
        d.dirname = '.'
        d
    .done(write())
