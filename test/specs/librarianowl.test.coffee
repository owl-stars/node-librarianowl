"use strict"

sys = require('sys')
chai = require('chai')
grunt = require('grunt')
librarianowl = require('../../')
exec = require('child_process').exec

assert = chai.assert
chai.Assertion.includeStack = true

# See http://visionmedia.github.io/mocha/ for Mocha tests.
# See http://chaijs.com/api/assert/ for Chai assertion types.

baseDir = process.cwd()

module.exports =
  "Test":
    "with default options": (done) ->
      librarianowl.compile("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp")
      exec "diff -bur #{baseDir}/test/tmp #{baseDir}/test/expected/default", (error, stdout, stderr) ->
        assert.equal "", stdout
        done()
    "with template & helper file options": (done) ->
      options =
        helpers: "#{baseDir}/test/fixtures/helper.js"
        template: "#{baseDir}/test/fixtures/helper-template.hbs"
      librarianowl.compile("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp", options)
      exec "diff -bur #{baseDir}/test/tmp #{baseDir}/test/expected/options", (error, stdout, stderr) ->
        assert.equal "", stdout
        done()
    "with template & helpers object options": (done) ->
      options =
        helpers:
          "trim": (val) ->
            return val.trim()
        template: "#{baseDir}/test/fixtures/helper-template.hbs"
      librarianowl.compile("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp", options)
      exec "diff -bur #{baseDir}/test/tmp #{baseDir}/test/expected/options", (error, stdout, stderr) ->
        assert.equal "", stdout
        done()
