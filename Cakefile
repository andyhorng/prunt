{read} = prunt = require './index'

concat = prunt.concat {filename: 'index.coffee', dirname: '.'}
coffee = do prunt.coffee
write = do prunt.write
header = prunt.header "'use strict'"

task 'build', 'build prunt', ->
  read('src/*.coffee')
    .then(concat)
    .then(header)
    .then(coffee)
    .done(write)
