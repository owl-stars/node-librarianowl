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
    "#library":
      "with default options": (done) ->
        librarianowl.library("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp")
        new ndd.Dir_Diff([
            "#{baseDir}/test/tmp"
            "#{baseDir}/test/expected/lib-default"
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
        librarianowl.library("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp", options)
        new ndd.Dir_Diff([
            "#{baseDir}/test/tmp"
            "#{baseDir}/test/expected/lib-template"
          ],
          "full"
        ).compare (err, result) ->
          throw err if err
          assert.equal result.deviation, 0
          done()
      "with template & helpers object options": (done) ->
        options =
          helpers:
            "test": (val) ->
              return "---#{val}----"
          template: "#{baseDir}/test/fixtures/helper-template.hbs"
        librarianowl.library("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp", options)
        new ndd.Dir_Diff([
            "#{baseDir}/test/tmp"
            "#{baseDir}/test/expected/lib-template"
          ],
          "full"
        ).compare (err, result) ->
          throw err if err
          assert.equal result.deviation, 0
          done()
    "#documentation":
      "with default options": (done) ->
        librarianowl.documentation("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp")
        new ndd.Dir_Diff([
            "#{baseDir}/test/tmp"
            "#{baseDir}/test/expected/docs-default"
          ],
          "full"
        ).compare (err, result) ->
          throw err if err
          assert.equal result.deviation, 0
          done()
      "with filename option": (done) ->
        options =
          filename: (item) ->
            return "_#{item.basename}.haml"
        librarianowl.documentation("#{baseDir}/test/fixtures", "#{baseDir}/test/tmp", options)
        new ndd.Dir_Diff([
            "#{baseDir}/test/tmp"
            "#{baseDir}/test/expected/docs-filename"
          ],
          "full"
        ).compare (err, result) ->
          throw err if err
          assert.equal result.deviation, 0
          done()
