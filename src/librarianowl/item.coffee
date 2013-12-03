class Item

  # -----------------------------------------------------------------------------------------------
  # ~ Requirements
  # -----------------------------------------------------------------------------------------------

  yaml  = require('js-yaml')
  path  = require("path")
  fs    = require("fs-extra")

  # -----------------------------------------------------------------------------------------------
  # ~ Variables
  # -----------------------------------------------------------------------------------------------

  ###
  @var {String}
  ###
  file: null
  ###
  @var {String}
  ###
  source: null
  ###
  @var {String}
  ###
  dirname: null
  ###
  @var {String}
  ###
  basename: null
  ###
  @var {String}
  ###
  relPath: null
  ###
  @var {String}
  ###
  packageName: null
  ###
  @var {Object}
  ###
  contents: null

  # -----------------------------------------------------------------------------------------------
  # ~ Constructor
  # -----------------------------------------------------------------------------------------------

  ###
  @param {String} source
  @param {String} file
  ###
  constructor: (@source, @file) ->
    @dirname = path.dirname(@file)
    @relPath = path.relative(@source, path.dirname(@dirname))
    @packageName = path.basename(@dirname)
    @contents = yaml.load(fs.readFileSync(@file, 'utf8'))
    @basename = path.basename(@file, '.yml')

  # -----------------------------------------------------------------------------------------------
  # ~ Public methods
  # -----------------------------------------------------------------------------------------------

  ###
  @return {Object} The YAML data
  ###
  getContents: ->
    return @contents

  ###
  @return {String}
  ###
  getMixinName: ->
    return "#{@relPath.split("/").join("-")}-#{@basename}"

  ###
  @return {Array} Parameter names as array
  ###
  getMixinParams: ->
    ret = []
    ret.push(key) for key, value of @getContents().mixin.parameters
    return ret