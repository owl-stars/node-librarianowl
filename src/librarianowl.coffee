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
  @var {Array}
  ###
  syntaxes: ["less", "sass", "scss", "styl"]

  # -----------------------------------------------------------------------------------------------
  # ~ Public methods
  # -----------------------------------------------------------------------------------------------

  library: (source, target, options={}) ->
    # create comp
    comp = new Library(source, target, options)

    # clean target
    fs.removeSync(target) if fs.existsSync(target)

    # iterate through files
    dive(source, (error, file) =>
      throw error if error
      return if path.extname(file) isnt ".yml"
      item = new Item(source, file)
      comp.compile(item, syntax) for syntax in @syntaxes
    )

  documentation: (source, target, options={}) ->
    # create comp
    comp = new Documentation(source, target, options)

    # clean target
    fs.removeSync(target) if fs.existsSync(target)

    # iterate through files
    dive(source, (error, file) =>
      throw error if error
      return if path.extname(file) isnt ".yml"
      return if path.basename(file).substr(0, 1) is "_"
      item = new Item(source, file)
      comp.compile(item)
    )

module.exports = new Librarianowl