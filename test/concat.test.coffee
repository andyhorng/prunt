fs = require 'fs'

{assert} = require 'chai'
CoffeeScript = require 'coffee-script'

describe 'concat helper', ->
  {File} = require '../src/prunt'
  file = undefined
  msg = undefined

  exports.util =
    log: ->
      # a spy
      (d) -> msg = d

  exports.File = File

  code = CoffeeScript.compile fs.readFileSync('src/concat.coffee', 'utf-8')
  eval code
  {concat} = exports

  beforeEach ->
    file = new File {content: 'foo', filename: 'foo.coffee', dirname: '.'}
    file.isDirty = false
    msg = undefined

  it 'should concat multiple files', ->
    [result] = concat()([file, file])
    assert.equal result.content, 'foofoo'
    assert.equal msg, 'joining 2 files'

  it 'should be able to specify filename and dirname', ->
    [result] = concat({filename: 'bar', dirname: 'baz'})([file, file])
    assert.equal result.filename, 'bar'
    assert.equal result.dirname, 'baz'
