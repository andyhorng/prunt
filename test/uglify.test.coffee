fs = require 'fs'

{assert} = require 'chai'
CoffeeScript = require 'coffee-script'

describe 'uglifyJS', ->
  {File} = require '../src/prunt'
  file = undefined
  msg = undefined

  exports.util =
    log: ->
      # a spy
      (d) -> msg = d

  exports.File = File

  code = CoffeeScript.compile fs.readFileSync('src/uglify.coffee', 'utf-8')
  eval code
  {uglify} = exports

  beforeEach ->
    msg = undefined
    content = 'y = [1, , 2, ]'
    file = new File {content: content, filename: 'foo.js', dirname: 'tmp'}

  it 'should uglify files', ->
    assert.isFunction uglify
    [result] = uglify()([file])
    assert.equal result.content, 'y=[1,,2];'

  it 'should uglify/sourcemaps files', ->
    results = uglify({sourceMap: true})([file])
    assert.equal results.length, 2
    [js, map] = results
    assert.equal js.filename, 'foo.js'
    assert.equal map.filename, 'foo.js.map'
    assert.equal map.content, '{"version":3,"file":"foo.js","sources":["?"],"names":["y"],"mappings":"AAAAA,GAAK,EAAG,CAAE"}'
