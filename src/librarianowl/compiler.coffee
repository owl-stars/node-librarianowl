class Compiler

  # -----------------------------------------------------------------------------------------------
  # ~ Requirements
  # -----------------------------------------------------------------------------------------------

  _     = require('underscore')
  _.str = require('underscore.string')
  path  = require("path")
  fs    = require("fs-extra")

  # -----------------------------------------------------------------------------------------------
  # ~ Variables
  # -----------------------------------------------------------------------------------------------
  ###
  @var {Object}
  ###
  options: null

  # -----------------------------------------------------------------------------------------------
  # ~ Constructor
  # -----------------------------------------------------------------------------------------------

  ###
  @param {String} target
  ###
  constructor: (@target) ->

  # -----------------------------------------------------------------------------------------------
  # ~ Public methods
  # -----------------------------------------------------------------------------------------------

  ###
  @param {Item} item
  @param {String} syntax
  ###
  compile: (item, syntax) ->
    targetDir = path.resolve(@target, syntax, item.package)
    targetFilename = if @options.filename then @options.filename.apply(@, [item, syntax]) else "#{item.module}.#{syntax}"
    targetFile = path.resolve(targetDir, targetFilename)

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
      # build object
      obj.mixin.syntax = obj.mixin[syntax]
      # get contents
      stream += Util.render(obj, @options.template, @options.helpers)

    # write file
    fs.writeFileSync(targetFile, stream)
