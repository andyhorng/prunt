{assert} = require 'chai'

Q = require 'q'

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
    # A markdown

    > This is interesting

        bar = (prop) =>
          @[prop]
    '''
    file = {content: code, filename: 'foo.coffee', dirname: '.'}
    file.isDirty = false

  it 'should be exported', ->
    assert.isFunction coffee
    assert.isFunction do coffee

  it 'should compile regular coffee-script', (done) ->
    promise = Q.when coffee()([file])
    promise.done ([result]) ->
      {content} = result
      assert.equal result.filename, 'foo.js'
      assert.isString content
      assert.notEqual content, code
      assert.include content, 'function'
      do done
    promise.fail done

  it.skip 'should compile literate coffee-script', (done) ->
    file.content = literate
    file.filename = 'foo.litcoffee'
    file.isDirty = false

    promise = Q.when coffee()([file])
    promise.done ([result]) ->
      {content} = result
      assert.equal result.filename, 'foo.js'
      assert.isString content
      assert.notEqual content, literate
      assert.include content, 'function'
      do done
    promise.fail done

  it 'should use jshint to detect javascript instead of guessing'
