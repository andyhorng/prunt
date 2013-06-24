(function() {
  var CoffeeScript, Q, UglifyJS, cleanCSS, fs, glob, partial, path, util, _,
    __slice = [].slice;

  path = require('path');

  CoffeeScript = require('coffee-script');

  exports.coffee = function(options) {
    var print, _ref;
    if (options == null) {
      options = {};
    }
    print = ((_ref = exports.util) != null ? typeof _ref.log === "function" ? _ref.log('coffee') : void 0 : void 0) || (function() {});
    return function(files) {
      return files.map(function(d) {
        var content, dirname, filename;
        content = d.content, filename = d.filename, dirname = d.dirname;
        print("compiling " + filename);
        if (path.extname(filename) === '.litcoffee') {
          if (options.literate == null) {
            options.literate = true;
          }
        }
        d.content = CoffeeScript.compile(content, options);
        if (options.literate) {
          d.filename = d.filename.replace('.litcoffee', '.js');
        } else {
          d.filename = filename.replace('.coffee', '.js');
        }
        return d;
      });
    };
  };

  _ = require('underscore');

  exports.concat = function(options) {
    var print;
    if (options == null) {
      options = {};
    }
    print = exports.util.log('concat');
    return function(files) {
      var content, dirname, filename;
      print("joining " + (files != null ? files.length : void 0) + " files");
      content = _.chain(files).pluck('content').reduce(function(a, b) {
        return '' + a + b;
      }).value();
      dirname = options.dirname || files[0].dirname;
      filename = options.filename || files[0].filename;
      return [
        new exports.File({
          content: content,
          dirname: dirname,
          filename: filename
        })
      ];
    };
  };

  cleanCSS = require('clean-css');

  exports.cssmin = function(options) {
    var print, _ref;
    print = ((_ref = exports.util) != null ? typeof _ref.log === "function" ? _ref.log('cssmin') : void 0 : void 0) || (function() {});
    return function(files) {
      files.forEach(function(file) {
        print("minifying " + file.filename);
        return file.content = cleanCSS.process(file.content, options);
      });
      return files;
    };
  };

  path = require('path');

  util = require('util');

  _ = require('underscore');

  exports.util = {};

  exports.util.log = function(moduleName) {
    return function(msg) {
      return util.log("<" + moduleName + "> " + msg);
    };
  };

  exports.File = (function() {
    Object.defineProperty(File.prototype, 'content', {
      get: function() {
        return this._content;
      },
      set: function(_content) {
        this._content = _content;
        return this.isDirty = true;
      }
    });

    function File(_arg) {
      this.content = _arg.content, this.dirname = _arg.dirname, this.filename = _arg.filename;
    }

    File.prototype.rename = function(filename) {
      this.filename = filename;
      return this;
    };

    File.prototype.chdir = function(dir) {
      this.dirname = path.resolve(process.cwd(), dir);
      return this;
    };

    return File;

  })();

  partial = function(f) {
    return function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return function(files) {
        var res;
        args.unshift(files);
        res = f.apply(files, args);
        if (!_.isArray(res)) {
          res = [res];
        }
        return res;
      };
    };
  };

  ['map', 'reduce', 'reduceRight', 'find', 'filter', 'where', 'findWhere', 'reject', 'sortBy'].forEach(function(key) {
    return exports[key] = partial(_[key]);
  });

  ['first', 'initial', 'last', 'rest', 'compact', 'flatten'].forEach(function(key) {
    return exports[key] = partial(_[key]);
  });

  exports.each = function(f) {
    return function(files) {
      files.forEach(f);
      return files;
    };
  };

  exports.invoke = function() {
    var args, method;
    method = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return function(files) {
      files.forEach(function(file) {
        var _ref;
        return (_ref = file[method]) != null ? _ref.apply(file, args) : void 0;
      });
      return files;
    };
  };

  fs = require('fs');

  path = require('path');

  _ = require('underscore');

  Q = require('q');

  glob = require('glob');

  exports.read = function(patterns) {
    var print;
    print = exports.util.log('read');
    if (!_.isArray(patterns)) {
      patterns = [patterns];
    }
    return Q.when(_.flatten(patterns.map(function(pattern) {
      return glob.sync(pattern).map(function(file) {
        var content, dirname, filename;
        print("reading " + file);
        content = fs.readFileSync(file, 'utf-8');
        filename = path.basename(file);
        dirname = path.resolve(path.dirname(file));
        file = new exports.File({
          content: content,
          dirname: dirname,
          filename: filename
        });
        file.isDirty = false;
        return file;
      });
    })));
  };

  _ = require('underscore');

  exports.rename = function(options) {
    var print, _ref;
    print = ((_ref = exports.util) != null ? typeof _ref.log === "function" ? _ref.log('rename') : void 0 : void 0) || (function() {});
    if (_.isString(options)) {
      return function(files) {
        return files.map(function(d) {
          print("renaming " + d.filename + " to " + options);
          return d.rename(options);
        });
      };
    } else if (_.isArray(options)) {
      return function(files) {
        files.forEach(function(d, i) {
          var name;
          name = options[i];
          print("renaming " + d.filename + " to " + name);
          if ((name != null) && _.isString(name)) {
            return d.rename(options[i]);
          }
        });
        return files;
      };
    } else if (_.isFunction(options)) {
      return function(files) {
        return files.map(function(d) {
          var name;
          name = options(d.filename);
          print("renaming " + d.filename + " to " + name);
          return d.rename(name);
        });
      };
    } else {
      return d;
    }
  };

  _ = require('underscore');

  UglifyJS = require('uglify-js');

  exports.uglify = function(options) {
    var print;
    if (options == null) {
      options = {};
    }
    print = exports.util.log('uglifyJS');
    return function(files) {
      var maps;
      maps = [];
      files.forEach(function(file) {
        var code, map, _ref;
        print("minifying " + file.filename);
        _ref = UglifyJS.minify(file.content, {
          fromString: true,
          outSourceMap: file.filename || ''
        }), code = _ref.code, map = _ref.map;
        file.content = code;
        return maps.push(new exports.File({
          content: map,
          dirname: file.dirname,
          filename: "" + file.filename + ".map"
        }));
      });
      if (!options.sourceMap) {
        return files;
      } else {
        return _.flatten([files, maps]);
      }
    };
  };

  fs = require('fs');

  path = require('path');

  exports.write = function(options) {
    var print;
    if (options == null) {
      options = {};
    }
    print = exports.util.log('write');
    return function(files) {
      files.forEach(function(file) {
        var content, dirname, filename;
        content = file.content, filename = file.filename, dirname = file.dirname;
        print("writing " + filename);
        filename = path.normalize(path.join(dirname, filename));
        fs.writeFileSync(filename, content, 'utf-8', function(error) {
          if (error) {
            throw error;
          }
        });
        return file.isDirty = false;
      });
      return files;
    };
  };

}).call(this);
