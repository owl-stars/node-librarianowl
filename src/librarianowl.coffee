###
librarianowl
https://github.com/franklin/node-librarianowl

Copyright (c) 2013 franklin
Licensed under the MIT license.
###

"use strict"

class Librarianowl

  # -----------------------------------------------------------------------------------------------
  # ~ Requirements
  # -----------------------------------------------------------------------------------------------

  _     = require('underscore')
  dive  = require("diveSync")
  path  = require("path")
  fs    = require("fs-extra")

  # -----------------------------------------------------------------------------------------------
  # ~ Variables
  # -----------------------------------------------------------------------------------------------

  ###
  @var {Object}
  ###
  options: null
  ###
  @var {String}
  ###
  target: null
  ###
  @var {String}
  ###
  source: null

  # -----------------------------------------------------------------------------------------------
  # ~ Public methods
  # -----------------------------------------------------------------------------------------------

  compile: (@source, @target, options={}) ->
    defaults =
      helpers: {}
      filter: false
      filename: @._filename
      syntaxes: ["less", "sass", "scss", "styl"]
      template: "#{path.dirname(__dirname)}/templates/default.hbs"

    # extend options
    _.extend(@options = {}, defaults, options)

    @._cleanTarget()

    @._compileSource()

  # -----------------------------------------------------------------------------------------------
  # ~ Private methods
  # -----------------------------------------------------------------------------------------------

  ###
  @param {Item} item
  @param {String} syntax
  ###
  _filename: (item, syntax) ->
    return "#{item.module}.#{syntax}"

  ###
  Clean the target directory if exists
  ###
  _cleanTarget: ->
    fs.removeSync(@target) if fs.existsSync(@target)

  ###
  Scan the source directory and compile files
  ###
  _compileSource: ->
    dive(@source, (error, file) =>
      throw error if error
      return if path.extname(file) isnt ".yml"
      return if @options.filter and not @options.filter(path.basename(file))
      item = new Item(@source, file)
      @._compileSourceItem(item, syntax) for syntax in @options.syntaxes
    )

  ###
  @param {Item} item
  @param {String} syntax
  ###
  _compileSourceItem: (item, syntax) ->
    targetDir = path.resolve(@target, syntax, item.package)
    targetFilename = @options.filename(item, syntax)
    targetFile = path.resolve(targetDir, targetFilename)

    # get stream
    stream = if fs.existsSync(targetFile) then fs.readFileSync(targetFile) else ""

    # make directory
    fs.mkdirpSync(targetDir)

    # handle imports
    if item.yaml.imports? and item.yaml.imports[syntax]?
      stream = item.yaml.imports[syntax] + "\n" + stream
    else
      item.yaml.syntax = syntax
      item.yaml.styles.syntax = item.yaml.styles[syntax]
      item.yaml.examples.syntax = item.yaml.examples[syntax]
      stream += Util.render(item.yaml, @options.template, @options.helpers)

    # write file
    fs.writeFileSync(targetFile, stream)


module.exports = new Librarianowl