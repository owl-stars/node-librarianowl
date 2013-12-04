class Library

  # -----------------------------------------------------------------------------------------------
  # ~ Requirements
  # -----------------------------------------------------------------------------------------------

  _     = require('underscore')
  _.str = require('underscore.string')
  dive  = require("diveSync")
  path  = require("path")
  fs    = require("fs-extra")
  hbs   = require("handlebars")

  # -----------------------------------------------------------------------------------------------
  # ~ Variables
  # -----------------------------------------------------------------------------------------------

  ###
  @var {String}
  ###
  source: null
  ###
  @var {String}
  ###
  target: null
  ###
  @var {Object}
  ###
  options: null

  # -----------------------------------------------------------------------------------------------
  # ~ Constructor
  # -----------------------------------------------------------------------------------------------

  constructor: (@source, @target, options) ->
    defaults =
      helpers: {}
      template: "#{path.dirname(__dirname)}/templates/library.hbs"

    # extend options
    _.extend(@options = {}, defaults, options)

  # -----------------------------------------------------------------------------------------------
  # ~ Public methods
  # -----------------------------------------------------------------------------------------------

  compile: (item, syntax) ->
    targetDir = path.resolve(@target, syntax, item.relPath)
    targetFile = path.resolve(targetDir, "#{item.packageName}.#{syntax}")

    # get stream
    stream = if fs.existsSync(targetFile) then fs.readFileSync(targetFile) else ""

    # make directory
    fs.mkdirpSync(targetDir)
    # build object
    obj = item.getContents()

    # handle imports
    if obj.imports? and obj.imports[syntax]?
      stream = obj.imports[syntax] + "\n" + stream
    else
      # get builder
      builder = hbs.compile(fs.readFileSync(@options.template, "utf8"))

      # build object
      obj.mixin.syntax = obj.mixin[syntax]

      # register helper
      hbs.registerHelper key, value for key, value of @options.helper

      # get contents
      stream += builder(obj)

    # write file
    fs.writeFileSync(targetFile, stream)


