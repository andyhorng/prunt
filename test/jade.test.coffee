{assert} = require 'chai'

{jade} = require '../src/jade'

describe 'jade compiler', ->
  it 'should compile jade files', ->
    content = '''
    doctype 5
    html(lang="en")
      head
        title= pageTitle
      body
        h1 Hello
    '''
    file = {content: content, filename: 'foo.jade', dirname: '.'}
    file.isDirty = false
    [html] = jade()([file])
    assert.equal file.filename, 'foo.html'
    assert.include file.content, '<!DOCTYPE html>'
    assert.include file.content, '<body>'
    assert.include file.content, '</body>'
    assert.include file.content, 'Hello'

  it 'should compile jade files with local variables', ()->
    content = '''
    doctype 5
    html(lang="en")
      head
        title= pageTitle
      body
        h1
          = 'Hello, ' + name
    '''
    file = {content: content, filename: 'foo.jade', dirname: '.'}
    file.isDirty = false
    [html] = jade(locals={name: 'andy'})([file])
    assert.equal file.filename, 'foo.html'
    assert.include file.content, 'Hello, andy'


