class Documentation

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
      filename: false
      template: "#{path.dirname(__dirname)}/templates/documentation.hbs"

    # extend options
    _.extend(@options = {}, defaults, options)

  # -----------------------------------------------------------------------------------------------
  # ~ Public methods
  # -----------------------------------------------------------------------------------------------

  ###
  @param {Item} item
  ###
  compile: (item) ->
    targetDir = path.resolve(@target, item.package, item.module)
    targetFilename = if @options.filename then @options.filename.apply(@, [item]) else "#{item.basename}.html"
    targetFile = path.resolve(targetDir, targetFilename)

    # get stream
    stream = if fs.existsSync(targetFile) then fs.readFileSync(targetFile) else ""

    # make directory
    fs.mkdirpSync(targetDir)

    # build object
    obj = item.getContents()
    obj.basename = item.basename
    obj.mixinName = item.getMixinName()
    obj.mixinParams = item.getMixinParams()

    # get contents
    stream += Util.render(obj, @options.template, @options.helpers)

    # write file
    fs.writeFileSync(targetFile, stream)
