/*
librarianowl
https://github.com/franklin/node-librarianowl

Copyright (c) 2013 franklin
Licensed under the MIT license.
*/


(function() {
  "use strict";
  var Documentation, Item, Librarianowl, Library;

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
      return dive(source, function(err, file) {
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
    var fs, hbs, path, _;

    _ = require('underscore');

    _.str = require('underscore.string');

    path = require("path");

    fs = require("fs-extra");

    hbs = require("handlebars");

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

    function Documentation(source, target, options) {
      var defaults;
      this.source = source;
      this.target = target;
      defaults = {
        helpers: {},
        template: "" + (path.dirname(__dirname)) + "/templates/documentation.html.hbs"
      };
      _.extend(this.options = {}, defaults, options);
    }

    Documentation.prototype.compile = function(item) {
      var builder, key, obj, stream, targetDir, targetExt, targetFile, value, _ref;
      targetDir = path.resolve(this.target, item.relPath);
      targetExt = path.basename(this.options.template).split(".");
      targetFile = path.resolve(targetDir, "" + item.packageName + "." + targetExt[targetExt.length - 2]);
      stream = fs.existsSync(targetFile) ? fs.readFileSync(targetFile) : "";
      fs.mkdirpSync(targetDir);
      builder = hbs.compile(fs.readFileSync(this.options.template, "utf8"));
      obj = item.getContents();
      obj.basename = item.basename;
      obj.mixinName = item.getMixinName();
      obj.mixinParams = item.getMixinParams();
      _ref = this.options.helper;
      for (key in _ref) {
        value = _ref[key];
        hbs.registerHelper(key, value);
      }
      stream += builder(obj);
      return fs.writeFileSync(targetFile, stream);
    };

    return Documentation;

  })();

  Item = (function() {
    var fs, path, yaml;

    yaml = require('js-yaml');

    path = require("path");

    fs = require("fs-extra");

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


    Item.prototype.packageName = null;

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
      this.relPath = path.relative(this.source, path.dirname(this.dirname));
      this.packageName = path.basename(this.dirname);
      this.contents = yaml.load(fs.readFileSync(this.file, 'utf8'));
      this.basename = path.basename(this.file, '.yml');
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
      return "" + (this.relPath.split("/").join("-")) + "-" + this.basename;
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
    var dive, fs, hbs, path, _;

    _ = require('underscore');

    _.str = require('underscore.string');

    dive = require("diveSync");

    path = require("path");

    fs = require("fs-extra");

    hbs = require("handlebars");

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

    function Library(source, target, options) {
      var defaults;
      this.source = source;
      this.target = target;
      defaults = {
        helpers: {},
        template: "" + (path.dirname(__dirname)) + "/templates/library.hbs"
      };
      _.extend(this.options = {}, defaults, options);
    }

    Library.prototype.compile = function(item, syntax) {
      var builder, key, obj, stream, targetDir, targetFile, value, _ref;
      targetDir = path.resolve(this.target, syntax, item.relPath);
      targetFile = path.resolve(targetDir, "" + item.packageName + "." + syntax);
      stream = fs.existsSync(targetFile) ? fs.readFileSync(targetFile) : "";
      fs.mkdirpSync(targetDir);
      obj = item.getContents();
      if ((obj.imports != null) && (obj.imports[syntax] != null)) {
        stream = obj.imports[syntax] + "\n" + stream;
      } else {
        builder = hbs.compile(fs.readFileSync(this.options.template, "utf8"));
        obj.mixin.syntax = obj.mixin[syntax];
        _ref = this.options.helper;
        for (key in _ref) {
          value = _ref[key];
          hbs.registerHelper(key, value);
        }
        stream += builder(obj);
      }
      return fs.writeFileSync(targetFile, stream);
    };

    return Library;

  })();

}).call(this);
