{assert} = require 'chai'
{File, util} = prunt = require '../src/prunt'

describe 'File class', ->
  file = undefined

  beforeEach ->
    file = new File {content: 'foo', filename: 'foo.txt', dirname: '.'}
    file.isDirty = false

  it 'should be exported', ->
    assert.isFunction File

  it 'should be flagged dirty when content changed', ->
    file.content = 'bar'
    assert.isTrue file.isDirty

  it 'should respond to rename method', ->
    filename = 'bar.txt'
    file.rename filename
    assert.equal file.filename, filename

  it 'should respond to chdir method', ->
    file.chdir 'bar'
    assert.equal file.dirname, process.cwd() + '/bar'

describe 'helpers', ->

  it 'should export helper functions', ->
    counter = 0
    f = (d) ->
      counter += 1
      d * 2
    assert.deepEqual prunt.map(f)([1..3]), [2, 4, 6]
    counter = 0
    assert.deepEqual prunt.each(f)([1..3]), [1..3]
    assert.equal counter, 3
    counter = 0
    obj =
      foo: (n) ->
        counter += n
    assert.deepEqual prunt.invoke('foo', 2)([obj]), [obj]
    assert.equal counter, 2
