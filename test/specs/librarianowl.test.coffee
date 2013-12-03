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
  before: (done) ->
    # setup here if necessary
    done()
  "Test":
    "#library": (done) ->
      librarianowl.library("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp")
      new ndd.Dir_Diff([
          "#{baseDir}/test/tmp"
          "#{baseDir}/test/expected/lib"
        ],
        "full"
      ).compare (err, result) ->
        assert.equal result.deviation, 0
        done()
    "#documentation": (done) ->
      librarianowl.documentation("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp")
      new ndd.Dir_Diff([
          "#{baseDir}/test/tmp"
          "#{baseDir}/test/expected/docs"
        ],
        "full"
      ).compare (err, result) ->
        assert.equal result.deviation, 0
        done()
