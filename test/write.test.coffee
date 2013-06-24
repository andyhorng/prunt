fs = require 'fs'

{assert} = require 'chai'
CoffeeScript = require 'coffee-script'

describe 'writer', ->
  {File} = require '../src/prunt'
  file = undefined
  msg = undefined

  exports.util =
    log: ->
      # a spy
      (d) -> msg = d

  exports.File = File

  code = CoffeeScript.compile fs.readFileSync('src/write.coffee', 'utf-8')
  eval code
  {write} = exports

  # prepare test folder
  fs.mkdirSync 'tmp' unless fs.existsSync 'tmp'

  beforeEach ->
    msg = undefined
    file = new File {content: 'foo', filename: 'foo.txt', dirname: 'tmp'}

  afterEach ->
    fs.unlinkSync 'tmp/foo.txt' if fs.existsSync 'tmp/foo.txt'

  it 'should write files', ->
    assert.isFunction write
    [result] = write()([file])
    assert.isTrue fs.existsSync 'tmp/foo.txt'
    content = fs.readFileSync 'tmp/foo.txt', 'utf-8'
    assert.equal content, 'foo'
    assert.isFalse result.isDirty
