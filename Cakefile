{read} = prunt = require './index'

concat = prunt.concat {filename: 'index.coffee', dirname: '.'}
coffee = do prunt.coffee
write = do prunt.write

task 'build', 'build prunt', ->
  read('src/*.coffee')
    .then(concat)
    .then(coffee)
    .done(write)
