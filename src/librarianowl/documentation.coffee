class Documentation

  # -----------------------------------------------------------------------------------------------
  # ~ Requirements
  # -----------------------------------------------------------------------------------------------

  _     = require('underscore')
  _.str = require('underscore.string')
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
    template: "templates/documentation.html.hbs"

  # -----------------------------------------------------------------------------------------------
  # ~ Constructor
  # -----------------------------------------------------------------------------------------------

  constructor: (@source, @target, options) ->
    # extend options
    _.extend(@options, @options, options)

  # -----------------------------------------------------------------------------------------------
  # ~ Public methods
  # -----------------------------------------------------------------------------------------------

  compile: (item) ->
    targetDir = path.resolve(@target, item.relPath)
    targetExt = path.basename(@options.template).split(".")
    targetFile = path.resolve(targetDir, "#{item.packageName}.#{targetExt[targetExt.length - 2]}")

    # make directory
    fs.mkdirpSync(targetDir)
    # get builder
    builder = hbs.compile(fs.readFileSync(@options.template, "utf8"))

    # build object
    obj = item.getContents()
    obj.basename = item.basename
    obj.mixinName = item.getMixinName()
    obj.mixinParams = item.getMixinParams()

    # register helper
    hbs.registerHelper key, value for key, value of @options.helper

    # get contents
    contents = builder(obj)

    # write file
    if fs.existsSync(targetFile)
      fs.appendFileSync(targetFile, contents)
    else
      fs.writeFileSync(targetFile, contents)
