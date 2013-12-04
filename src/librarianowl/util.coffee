class Util

  # -----------------------------------------------------------------------------------------------
  # ~ Requirements
  # -----------------------------------------------------------------------------------------------

  _     = require('underscore')
  fs    = require("fs-extra")
  path  = require("path")
  hbs   = require("handlebars")

  # -----------------------------------------------------------------------------------------------
  # ~ Public static methods
  # -----------------------------------------------------------------------------------------------

  ###
  @param {Object} obj
  @param {String} template
  @param {Object} helpers
  @return {String}
  ###
  @render: (obj, template, helpers=null) ->
    # get builder
    builder = hbs.compile(fs.readFileSync(path.resolve(template), "utf8"))
    # register helpers
    if _.isString(helpers) and fs.existsSync(helpers)
      GLOBAL.hbs = hbs
      require(path.resolve(helpers))
    else if _.isObject(helpers)
      hbs.registerHelper key, value for key, value of helpers
    # get contents
    return builder(obj)
