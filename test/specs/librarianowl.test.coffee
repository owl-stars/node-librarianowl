"use strict"

chai = require('chai')
grunt = require('grunt')
ndd = require("node-dir-diff")
librarianowl = require('../../')

assert = chai.assert
chai.Assertion.includeStack = true

# See http://visionmedia.github.io/mocha/ for Mocha tests.
# See http://chaijs.com/api/assert/ for Chai assertion types.

baseDir = process.cwd()

module.exports =
  "Test":
    "with default options": (done) ->
      librarianowl.compile("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp")
      new ndd.Dir_Diff([
          "#{baseDir}/test/tmp"
          "#{baseDir}/test/expected/default"
        ],
        "full"
      ).compare (err, result) ->
        throw err if err
        assert.equal result.deviation, 0
        done()

    "with template & helper file options": (done) ->
      options =
        helpers: "#{baseDir}/test/fixtures/helper.js"
        template: "#{baseDir}/test/fixtures/helper-template.hbs"
      librarianowl.compile("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp", options)
      new ndd.Dir_Diff([
          "#{baseDir}/test/tmp"
          "#{baseDir}/test/expected/options"
        ],
        "full"
      ).compare (err, result) ->
        throw err if err
        assert.equal result.deviation, 0
        done()
    "with template & helpers object options": (done) ->
      options =
        helpers:
          "trim": (val) ->
            return val.trim()
        template: "#{baseDir}/test/fixtures/helper-template.hbs"
      librarianowl.compile("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp", options)
      new ndd.Dir_Diff([
          "#{baseDir}/test/tmp"
          "#{baseDir}/test/expected/options"
        ],
        "full"
      ).compare (err, result) ->
        throw err if err
        assert.equal result.deviation, 0
        done()
