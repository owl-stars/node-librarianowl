/*
librarianowl
https://github.com/franklin/node-librarianowl

Copyright (c) 2013 franklin
Licensed under the MIT license.
*/


(function() {
  "use strict";
  var Documentation, Item, Librarianowl, Library, Util;

  Librarianowl = (function() {
    var dive, fs, path, _;

    function Librarianowl() {}

    _ = require('underscore');

    dive = require("diveSync");

    path = require("path");

    fs = require("fs-extra");

    /*
    @var {Array}
    */


    Librarianowl.prototype.syntaxes = ["less", "sass", "scss", "styl"];

    Librarianowl.prototype.library = function(source, target, options) {
      var comp,
        _this = this;
      if (options == null) {
        options = {};
      }
      comp = new Library(source, target, options);
      if (fs.existsSync(target)) {
        fs.removeSync(target);
      }
      return dive(source, function(error, file) {
        var item, syntax, _i, _len, _ref, _results;
        if (error) {
          throw error;
        }
        if (path.extname(file) !== ".yml") {
          return;
        }
        item = new Item(source, file);
        _ref = _this.syntaxes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          syntax = _ref[_i];
          _results.push(comp.compile(item, syntax));
        }
        return _results;
      });
    };

    Librarianowl.prototype.documentation = function(source, target, options) {
      var comp,
        _this = this;
      if (options == null) {
        options = {};
      }
      comp = new Documentation(source, target, options);
      if (fs.existsSync(target)) {
        fs.removeSync(target);
      }
      return dive(source, function(error, file) {
        var item;
        if (error) {
          throw error;
        }
        if (path.extname(file) !== ".yml") {
          return;
        }
        if (path.basename(file).substr(0, 1) === "_") {
          return;
        }
        item = new Item(source, file);
        return comp.compile(item);
      });
    };

    return Librarianowl;

  })();

  module.exports = new Librarianowl;

  Documentation = (function() {
    var fs, path, _;

    _ = require('underscore');

    _.str = require('underscore.string');

    path = require("path");

    fs = require("fs-extra");

    /*
    @var {String}
    */


    Documentation.prototype.source = null;

    /*
    @var {String}
    */


    Documentation.prototype.target = null;

    /*
    @var {Object}
    */


    Documentation.prototype.options = null;

    /*
    @param {String} source
    @param {String} target
    @param {Object} options
    */


    function Documentation(source, target, options) {
      var defaults;
      this.source = source;
      this.target = target;
      defaults = {
        helpers: {},
        filename: false,
        template: "" + (path.dirname(__dirname)) + "/templates/documentation.hbs"
      };
      _.extend(this.options = {}, defaults, options);
    }

    /*
    @param {Item} item
    */


    Documentation.prototype.compile = function(item) {
      var obj, stream, targetDir, targetFile, targetFilename;
      targetDir = path.resolve(this.target, item["package"], item.module);
      targetFilename = this.options.filename ? this.options.filename.apply(this, [item]) : "" + item.basename + ".html";
      targetFile = path.resolve(targetDir, targetFilename);
      stream = fs.existsSync(targetFile) ? fs.readFileSync(targetFile) : "";
      fs.mkdirpSync(targetDir);
      obj = item.getContents();
      obj.basename = item.basename;
      obj.mixinName = item.getMixinName();
      obj.mixinParams = item.getMixinParams();
      stream += Util.render(obj, this.options.template, this.options.helpers);
      return fs.writeFileSync(targetFile, stream);
    };

    return Documentation;

  })();

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


    Item.prototype.contents = null;

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
      this.contents = yaml.load(fs.readFileSync(this.file, 'utf8'));
      this["package"] = path.dirname(this.relPath);
      this.module = path.basename(this.relPath);
    }

    /*
    @return {Object} The YAML data
    */


    Item.prototype.getContents = function() {
      return this.contents;
    };

    /*
    @return {String}
    */


    Item.prototype.getMixinName = function() {
      return "" + (this.relPath.split('/').join('-')) + "-" + this.basename;
    };

    /*
    @return {Array} Parameter names as array
    */


    Item.prototype.getMixinParams = function() {
      var key, ret, value, _ref;
      ret = [];
      _ref = this.getContents().mixin.parameters;
      for (key in _ref) {
        value = _ref[key];
        ret.push(key);
      }
      return ret;
    };

    return Item;

  })();

  Library = (function() {
    var fs, path, _;

    _ = require('underscore');

    _.str = require('underscore.string');

    path = require("path");

    fs = require("fs-extra");

    /*
    @var {String}
    */


    Library.prototype.source = null;

    /*
    @var {String}
    */


    Library.prototype.target = null;

    /*
    @var {Object}
    */


    Library.prototype.options = null;

    /*
    @param {String} source
    @param {String} target
    @param {Object} options
    */


    function Library(source, target, options) {
      var defaults;
      this.source = source;
      this.target = target;
      defaults = {
        helpers: {},
        filename: false,
        template: "" + (path.dirname(__dirname)) + "/templates/library.hbs"
      };
      _.extend(this.options = {}, defaults, options);
    }

    /*
    @param {Item} item
    @param {String} syntax
    */


    Library.prototype.compile = function(item, syntax) {
      var obj, stream, targetDir, targetFile, targetFilename;
      targetDir = path.resolve(this.target, syntax, item["package"]);
      targetFilename = this.options.filename ? this.options.filename.apply(this, [item, syntax]) : "" + item.module + "." + syntax;
      targetFile = path.resolve(targetDir, targetFilename);
      stream = fs.existsSync(targetFile) ? fs.readFileSync(targetFile) : "";
      fs.mkdirpSync(targetDir);
      obj = item.getContents();
      if ((obj.imports != null) && (obj.imports[syntax] != null)) {
        stream = obj.imports[syntax] + "\n" + stream;
      } else {
        obj.mixin.syntax = obj.mixin[syntax];
        stream += Util.render(obj, this.options.template, this.options.helpers);
      }
      return fs.writeFileSync(targetFile, stream);
    };

    return Library;

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
