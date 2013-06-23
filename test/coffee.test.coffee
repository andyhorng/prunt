{assert} = require 'chai'

describe 'coffee-script compiler', ->
  {coffee} = require '../src/coffee'
  file = undefined
  code = undefined
  literate = undefined

  beforeEach ->
    code = '''
    foo = (string) ->
      "#{string}, bar"
    '''
    literate = '''
    * This is a sample markdown

        bar = (prop) =>
          @[prop]
    '''
    file = {content: code, filename: 'foo.coffee', dirname: '.'}
    file.isDirty = false

  it 'should be exported', ->
    assert.isFunction coffee
    assert.isFunction do coffee

  it 'should compile regular coffee-script', ->
    [result] = coffee()([file])
    {content} = result
    assert.equal result.filename, 'foo.js'
    assert.isString content
    assert.notEqual content, code
    assert.include content, 'function'

  it 'should compile literate coffee-script', ->
    file.content = literate
    file.filename = 'foo.litcoffee'
    file.isDirty = false

    [result] = coffee()([file])
    {content} = result
    assert.equal result.filename, 'foo.js'
    assert.isString content
    assert.notEqual content, literate
    assert.include content, 'function'

  it 'should use jshint to detect javascript instead of guessing'
