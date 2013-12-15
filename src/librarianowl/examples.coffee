class Examples

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

  ###
  @param {String} source
  @param {String} target
  @param {Object} options
  ###
  constructor: (@source, @target, options) ->
    defaults =
      helpers: {}
      imports: false
      filename: false
      template: "#{path.dirname(__dirname)}/templates/examples.hbs"

    # extend options
    _.extend(@options = {}, defaults, options)

  # -----------------------------------------------------------------------------------------------
  # ~ Public methods
  # -----------------------------------------------------------------------------------------------

  ###
  @param {Item} item
  @param {String} syntax
  ###
  compile: (item, syntax) ->
    targetDir = path.resolve(@target)
    targetFilename = if @options.filename then @options.filename.apply(@, [item, syntax]) else "examples.#{syntax}"
    targetFile = path.resolve(targetDir, targetFilename)

    # get stream
    if fs.existsSync(targetFile)
      stream = fs.readFileSync(targetFile)
    else
      stream = if @options.imports then @options.imports.apply(@, [syntax]) else ""

    # make directory
    fs.mkdirpSync(targetDir)
    # build object
    obj = item.getContents()

    # handle imports
    if obj.imports? and obj.imports[syntax]?
      # do nothing
    else
      # build object
      obj.examples.syntax = obj.examples[syntax]
      # get contents
      stream += Util.render(obj, @options.template, @options.helpers)

    # write file
    fs.writeFileSync(targetFile, stream)
