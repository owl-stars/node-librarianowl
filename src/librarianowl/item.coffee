class Item

  # -----------------------------------------------------------------------------------------------
  # ~ Requirements
  # -----------------------------------------------------------------------------------------------

  yaml  = require('js-yaml')
  path  = require("path")
  fs    = require("fs-extra")
  _str  = require("underscore.string")

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
  module: null
  ###
  @var {String}
  ###
  package: null
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
    @basename = path.basename(@file, '.yml')
    @relPath = path.relative(@source, @dirname)
    @contents = yaml.load(fs.readFileSync(@file, 'utf8'))
    @package = path.dirname(@relPath)
    @module = path.basename(@relPath)

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
    return "#{@relPath.split('/').join('-')}-#{@basename}"

  ###
  @return {Array} Parameter names as array
  ###
  getMixinParams: ->
    ret = []
    ret.push(key) for key, value of @getContents().mixin.parameters
    return ret