{assert} = require 'chai'

{cssmin} = require '../src/cssmin'

describe 'css minifier', ->
  file = undefined

  beforeEach ->
    file = {content: 'a{font-weight:bold;}', filename: 'foo.css', dirname: '.'}
    file.isDirty = false

  it 'should minify css files', ->
    assert.isFunction cssmin
    [result] = cssmin()([file])
    assert.equal result.content, 'a{font-weight:700}'
