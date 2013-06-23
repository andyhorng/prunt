fs = require 'fs'

{assert} = require 'chai'
CoffeeScript = require 'coffee-script'

describe 'reader', ->
  {File} = require '../src/prunt'
  file = undefined
  msg = undefined

  exports.util =
    log: ->
      # a spy
      (d) -> msg = d

  exports.File = File

  code = CoffeeScript.compile fs.readFileSync('src/read.coffee', 'utf-8')
  eval code
  {read} = exports

  beforeEach ->
    msg = undefined

  it 'should read files', (done) ->
    read('Cake*')
      .fail (error) ->
        done error
      .done (files) ->
        assert.isArray files
        assert.equal files.length, 1
        [file] = files
        assert.equal file.filename, 'Cakefile'
        assert.equal msg, 'reading Cakefile'

        do done
