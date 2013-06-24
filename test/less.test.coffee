fs = require 'fs'

{assert} = require 'chai'
CoffeeScript = require 'coffee-script'

describe 'less', ->
  {File} = require '../src/prunt'
  file = undefined
  msg = undefined

  exports.util =
    log: ->
      # a spy
      (d) -> msg = d

  exports.File = File

  code = CoffeeScript.compile fs.readFileSync('src/less.coffee', 'utf-8')
  eval code
  {less} = exports

  beforeEach ->
    msg = undefined
    file = new File {content: '.class { width: (1 + 1) }', dirname: '.', filename: 'foo.less'}
    file.isDirty = false

  it 'should compile less', (done) ->
    assert.isFunction less
    less()([file])
      .fail(done)
      .done ([result]) ->
        assert.equal result.content, '''
        .class {
          width: 2;
        }\n
        '''
        assert.equal result.filename, 'foo.css'
        assert.isTrue result.isDirty
        do done
