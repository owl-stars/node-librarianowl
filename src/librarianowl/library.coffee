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
  options:
    helpers: {}
    template: "templates/library.hbs"

  # -----------------------------------------------------------------------------------------------
  # ~ Constructor
  # -----------------------------------------------------------------------------------------------

  constructor: (@source, @target, options) ->
    # extend options
    _.extend(@options, @options, options)

  # -----------------------------------------------------------------------------------------------
  # ~ Public methods
  # -----------------------------------------------------------------------------------------------

  compile: (item, syntax) ->
    targetDir = path.resolve(@target, syntax, item.relPath)
    targetFile = path.resolve(targetDir, "#{item.packageName}.#{syntax}")

    # make directory
    fs.mkdirpSync(targetDir)
    # get builder
    builder = hbs.compile(fs.readFileSync(@options.template, "utf8"))

    # build object
    obj = item.getContents()
    obj.mixin.syntax = obj.mixin[syntax]

    # register helper
    hbs.registerHelper key, value for key, value of @options.helper

    # get contents
    contents = builder(obj)

    # get contents & write file
    if fs.existsSync(targetFile)
      fs.appendFileSync(targetFile, contents)
    else
      fs.writeFileSync(targetFile, contents)
