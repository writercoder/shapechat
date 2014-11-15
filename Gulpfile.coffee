gulp   = require 'gulp'
gutil  = require 'gulp-util'

coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
sass    = require 'gulp-sass'
injectLiveReload = require 'connect-livereload'
livereload = require 'gulp-livereload'

express = require 'express'
serveStatic = require 'serve-static'

http    = require 'http'
path    = require 'path'

# Starts the webserver (http://localhost:3000)
gulp.task 'webserver', ->
  livereload.listen()

  port = 3000
  hostname = null # allow to connect from anywhere
  base = path.resolve __dirname + '/public'

  app = express()
  app.use injectLiveReload()
  app.use serveStatic base
  app.listen port, hostname


# Compiles CoffeeScript files into js file
# and reloads the page
gulp.task 'scripts', ->
  gulp.src('src/coffee/**/*.coffee')
  .pipe(concat 'shapechat.coffee')
  .pipe(do coffee)
  .pipe(gulp.dest 'public/js')
  .pipe livereload auto: no

# Compiles Sass files into css file
# and reloads the styles
gulp.task 'styles', ->
  gulp.src('src/scss/init.scss')
  .pipe sass includePaths: require('node-neat').includePaths
  .pipe concat 'styles.css'
  .pipe gulp.dest 'public/css'
  .pipe livereload auto: no

# Reloads the page
gulp.task 'html', ->
  gulp.src('public/**/*.html')
  .pipe livereload auto: no

# The default task
gulp.task 'default', ->
  gutil.log 'grrrunt'
  gulp.run 'webserver', 'scripts', 'styles', 'html'

  # Watches files for changes
  gulp.watch 'src/coffee/**', ->
    gulp.run 'scripts'

  gulp.watch 'src/scss/**', ->
    gulp.run 'styles'

  gulp.watch 'public/**/*.html', ->
    gutil.log 'bang! html!'
    gulp.run 'html'

