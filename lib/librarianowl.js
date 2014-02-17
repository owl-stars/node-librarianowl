/*
librarianowl
https://github.com/franklin/node-librarianowl

Copyright (c) 2013 franklin
Licensed under the MIT license.
*/


(function() {
  "use strict";
  var Item, Librarianowl, Util;

  Librarianowl = (function() {
    var dive, fs, path, _;

    function Librarianowl() {}

    _ = require('underscore');

    dive = require("diveSync");

    path = require("path");

    fs = require("fs-extra");

    /*
    @var {Object}
    */


    Librarianowl.prototype.options = null;

    /*
    @var {String}
    */


    Librarianowl.prototype.target = null;

    /*
    @var {String}
    */


    Librarianowl.prototype.source = null;

    Librarianowl.prototype.compile = function(source, target, options) {
      var defaults;
      this.source = source;
      this.target = target;
      if (options == null) {
        options = {};
      }
      defaults = {
        helpers: {},
        filter: false,
        filename: this._filename,
        syntaxes: ["less", "sass", "scss", "styl"],
        template: "" + (path.dirname(__dirname)) + "/templates/default.hbs"
      };
      _.extend(this.options = {}, defaults, options);
      this._cleanTarget();
      return this._compileSource();
    };

    /*
    @param {Item} item
    @param {String} syntax
    */


    Librarianowl.prototype._filename = function(item, syntax) {
      return "" + item.module + "." + syntax;
    };

    /*
    Clean the target directory if exists
    */


    Librarianowl.prototype._cleanTarget = function() {
      if (fs.existsSync(this.target)) {
        return fs.removeSync(this.target);
      }
    };

    /*
    Scan the source directory and compile files
    */


    Librarianowl.prototype._compileSource = function() {
      var _this = this;
      return dive(this.source, function(error, file) {
        var item, syntax, _i, _len, _ref, _results;
        if (error) {
          throw error;
        }
        if (path.extname(file) !== ".yml") {
          return;
        }
        if (_this.options.filter && !_this.options.filter(path.basename(file))) {
          return;
        }
        item = new Item(_this.source, file);
        _ref = _this.options.syntaxes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          syntax = _ref[_i];
          _results.push(_this._compileSourceItem(item, syntax));
        }
        return _results;
      });
    };

    /*
    @param {Item} item
    @param {String} syntax
    */


    Librarianowl.prototype._compileSourceItem = function(item, syntax) {
      var stream, targetDir, targetFile, targetFilename;
      targetDir = path.resolve(this.target, syntax, item["package"]);
      targetFilename = this.options.filename(item, syntax);
      targetFile = path.resolve(targetDir, targetFilename);
      stream = fs.existsSync(targetFile) ? fs.readFileSync(targetFile) : "";
      fs.mkdirpSync(targetDir);
      if ((item.yaml.imports != null) && (item.yaml.imports[syntax] != null)) {
        stream = item.yaml.imports[syntax] + "\n" + stream;
      } else {
        item.yaml.syntax = syntax;
        item.yaml.styles.syntax = item.yaml.styles[syntax];
        item.yaml.examples.syntax = item.yaml.examples[syntax];
        stream += Util.render(item.yaml, this.options.template, this.options.helpers);
      }
      return fs.writeFileSync(targetFile, stream);
    };

    return Librarianowl;

  })();

  module.exports = new Librarianowl;

  Item = (function() {
    var fs, path, yaml, _str;

    yaml = require('js-yaml');

    path = require("path");

    fs = require("fs-extra");

    _str = require("underscore.string");

    /*
    @var {String}
    */


    Item.prototype.file = null;

    /*
    @var {String}
    */


    Item.prototype.source = null;

    /*
    @var {String}
    */


    Item.prototype.dirname = null;

    /*
    @var {String}
    */


    Item.prototype.basename = null;

    /*
    @var {String}
    */


    Item.prototype.relPath = null;

    /*
    @var {String}
    */


    Item.prototype.module = null;

    /*
    @var {String}
    */


    Item.prototype["package"] = null;

    /*
    @var {Object}
    */


    Item.prototype.yaml = null;

    /*
    @param {String} source
    @param {String} file
    */


    function Item(source, file) {
      this.source = source;
      this.file = file;
      this.dirname = path.dirname(this.file);
      this.basename = path.basename(this.file, '.yml');
      this.relPath = path.relative(this.source, this.dirname);
      this.yaml = yaml.load(fs.readFileSync(this.file, 'utf8'));
      this["package"] = path.dirname(this.relPath);
      this.module = path.basename(this.relPath);
    }

    return Item;

  })();

  Util = (function() {
    var fs, hbs, path, _;

    function Util() {}

    _ = require('underscore');

    fs = require("fs-extra");

    path = require("path");

    hbs = require("handlebars");

    /*
    @param {Object} obj
    @param {String} template
    @param {Object} helpers
    @return {String}
    */


    Util.render = function(obj, template, helpers) {
      var builder, key, value;
      if (helpers == null) {
        helpers = null;
      }
      builder = hbs.compile(fs.readFileSync(path.resolve(template), "utf8"));
      if (_.isString(helpers) && fs.existsSync(helpers)) {
        GLOBAL.hbs = hbs;
        require(path.resolve(helpers));
      } else if (_.isObject(helpers)) {
        for (key in helpers) {
          value = helpers[key];
          hbs.registerHelper(key, value);
        }
      }
      return builder(obj);
    };

    return Util;

  })();

}).call(this);
