fs = require 'fs'

{assert} = require 'chai'
CoffeeScript = require 'coffee-script'

describe 'writer', ->
  {File} = require '../src/prunt'
  file = undefined
  dir = undefined
  msg = undefined

  exports.util =
    log: ->
      # a spy
      (d) -> msg = d

  exports.File = File

  code = CoffeeScript.compile fs.readFileSync('src/clean.coffee', 'utf-8')
  eval code
  {clean} = exports

  # prepare test folder
  fs.mkdirSync 'tmp' unless fs.existsSync 'tmp'

  beforeEach ->
    msg = undefined
    file = new File {content: 'foo', dirname: 'tmp', filename: 'foo.txt'}
    dir = new File {content: '', dirname: 'tmp/bar', filename: ''}
    fs.writeFileSync 'tmp/foo.txt', 'foo', 'utf-8'
    fs.mkdirSync 'tmp/bar' unless fs.existsSync 'tmp/bar'

  afterEach ->
    fs.unlinkSync 'tmp/foo.txt' if fs.existsSync 'tmp/foo.txt'
    fs.rmdirSync 'tmp/bar' if fs.existsSync 'tmp/bar'

  it 'should write files', ->
    assert.isFunction clean
    [result] = clean()([file, dir])
    assert.isFalse fs.existsSync 'tmp/foo.txt'
    assert.isFalse fs.existsSync 'tmp/bar'
