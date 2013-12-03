###
node-librarianowl
https://github.com/owl-stars/node-librarianowl

Copyright (c) 2013 Owl-Stars
Licensed under the MIT license.
###

"use strict"

module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"

    coffeelint:
      files: ["Gruntfile.coffee", "src/**/*.coffee", "test/**/*.coffee"]
      options:
        max_line_length:
          value: 200
          level: "error"

    coffee:
      lib:
        options:
          join: true
        files:
          "lib/<%= pkg.name %>.js": ["src/**/*.coffee"]

    clean:
      test:
        src: ["test/tmp"]

    # Unit tests.
    mochacov:
      options:
        bail: true
        ui: "exports"
        require: "coffee-script"
        compilers: ["coffee:coffee-script"]
        files: "test/specs/**/*.coffee"
      all:
        options:
          reporter: "spec"
      coverage:
        options:
          coveralls:
            serviceName: "travis-ci"
      htmlcoverage:
        options:
          reporter: "html-cov"
          output: "test/coverage.html"

    # Deployment
    bumper:
      options:
        tasks: ["default"]
        files: ["package.json"]
        updateConfigs: ["pkg"]

  # Load npm tasks.
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-mocha-cov"
  grunt.loadNpmTasks "grunt-bumper"

  # Tasks
  grunt.registerTask "default", ["coffeelint", "coffee"]
  grunt.registerTask "test", ["default", "clean", "mochacov:all", "mochacov:htmlcoverage"]
  grunt.registerTask "test:travis", ["default", "clean", "mochacov:all", "mochacov:coverage"]
