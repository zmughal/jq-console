{spawn, exec} = require 'child_process'

task 'watch', 'Build and watch the CoffeeScript source files', ->
  #coffee = spawn 'coffee', ['-cw', '-o', 'lib', 'src']
  coffee = spawn 'coffee', ['-cw', '-j', 'lib/grimconsole.js', 'src/jqconsole.coffee', 'src/grimconsole.coffee']
  test   = spawn 'coffee', ['-cw', 'test']
  log = (d)-> console.log d.toString()
  coffee.stdout.on 'data', log
  test.stdout.on 'data', log

task 'build', 'Build minified file with uglify', ->
  console.log 'building...'
  ###
  exec 'uglifyjs -o jqconsole.min.js lib/jqconsole.js', (err, res)->
    if err
      console.error 'failed with', err
    else
      console.log 'build complete'
  ###
  exec 'uglifyjs -o grimconsole.min.js lib/grimconsole.js', (err, res)->
    if err
      console.error 'failed with', err
    else
      console.log 'build complete'
