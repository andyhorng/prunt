Like grunt, but simpler
=====

> A prunt is a small blob of glass fused to another piece of glass to help provide a firm grip in the absence of a handle.
> -- modified from [Wikipedia](http://en.wikipedia.org/wiki/Prunt).

Prunt is a small build utility similar to grunt. It have several aims.

* Promise/A-based workflow
* Declarative deta transformation
* Abstraction of files
* Use your favorite CLI

Current features:

* Concatenate files
* Clean files and folders
* Compile coffee-script
* Compile LESS
* Minify JavaScript
* Minify CSS

Additional features:

* Since it is based on [kriskowal/q](https://github.com/kriskowal/q), all the [methods](https://github.com/kriskowal/q/wiki/API-Reference) provided by Q are available.
* Most of the helper functions from [underscore](http://underscorejs.org) such as `map`, `reduce` and `filter` are also available at your disposal.

Install
-----

`npm install prunt`

`.then` - promise/A-based workflow
-----

Usually our source code went through several steps. Prunt use Primise/A-based API to make this simpler.

    read('src/*.coffee')
      .then(step1)
      .then(step2)
      .done(write)

For example, we might concat, compile, and minify source codes

    read('src/*.coffee')
      .then(concat)
      .then(compile)
      .then(uglify)
      .done(write)

We can even go further with this concept

    prunt = require 'prunt'

    coffeeFilter = prunt.filter (file) ->
      file.filename.match /.coffee/
    compileCoffee = do prunt.coffee

    lessFilter = prunt.filter (file) ->
      file.filename.match /.less/
    compileLESS = do prunt.less
    minifyCSS = do prunt.cssmin

    sourceCodes = prunt.read 'src/*'

    # Coffee-script workflow
    sourceCodes
      .then(coffeeFilter)
      .then(compileCoffee)

    # LESS workflow
    sourceCodes
      .then(lessFilter)
      .then(compileLESS)
      .then(minifyCSS)

Declarative deta transformation
-----

Every plug-in for prunt is

* a) a function that accept an array of file instances
* b) a factory function that returns (a)

Example:
Let's write a plugin that appends licence info to the end of source codes.

    addLicence = (files) ->
      files.forEach (file) ->
        file.content += '''\n
        Copyright (C) 2013 Hao-kang Den
        Permission is hereby granted, free of charge, to any person bla bla bla...
        '''
      files

    read('src/*.coffee')
      .then(addLicence)
      .done(write)

We can also write a factory method to accept several kind of licence declaration.

    addLicenceFactory = (type = 'MIT') ->
      licence = undefined
      switch type
        when 'MIT'
          licence = 'bla bla bla'
        when 'GPL'
          licence = 'bla bla bla'
      (files) ->
        files.forEach (file) ->
          file.content += licence
        files

    addMITLicence = addLicenceFactory 'MIT'

    read('src/*.coffee')
      .then(addMITLicence)
      .done(write)

Abstraction of files
-----

Rather than constantly reading/writing to disk, prunt use a very simple abstraction layer to represent a file - the File class.

    content = fs.readFileSync './foo.txt', 'utf-8'
    file = new File({content: content, filename: 'foo.txt', dirname: '.'})
    # It havn't been modified yet
    file.isDirty = false

A instance of File have 4 properties: `isDirty`, `content`, `filename`, `dirname`. `isDirty` is a binary flag that explains whether the content have been modified, and will be automatically flagged as true upon modification.

    file.content = 'foo'
    file.isDirty == true # true

A instance of File have two self-explanatory methods: `rename` and `chdir`. Use them at your convenience.

Use your favorite CLI
-----

Prunt does not come with a CLI. Use anything you like instead.
For coffee-script users, `Cakefile` is a very good place it.

    # Cakefile
    {read} = prunt = require './index'

    concat = prunt.concat {filename: 'index.coffee'}
    compile = do prunt.coffee
    write = do prunt.write

    task 'build', 'concat, compile, and write them back to disk', ->
      read('src/*.coffee')
        .then(concat)
        .then(compile)
        .done(write)

Development
-----

build `cake build`
test `npm test` or `mocha`

Coming soon:

* [useminPrepare](https://github.com/yeoman/grunt-usemin)
* Compile Sass
* Please vote for new features at issue pages

Pending for requests:

* jshint
* csslint
* coffeelint
* handlebar
* htmlmin
* imagemin
* Stylus
* jade

Licence (MIT)
-----

Copyright (C) 2013 Hao-kang Den

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
