{assert} = require 'chai'

describe 'rename helper', ->
  {File} = require '../src/prunt'
  {rename} = require '../src/rename'
  file = undefined
  code = undefined
  literate = undefined
  filename = 'bar.txt'

  beforeEach ->
    file = new File {content: code, filename: 'foo.coffee', dirname: '.'}
    file.isDirty = false

  it 'should take a string as input', ->
    [result] = rename(filename)([file])
    assert.equal result.filename, filename

  it 'should take an array as input', ->
    [result] = rename([filename])([file])
    assert.equal result.filename, filename

  it 'should take a function as input', ->
    f = -> filename
    [result] = rename(f)([file])
    assert.equal result.filename, filename
