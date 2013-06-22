(function() {
  var CoffeeScript, Q, fs, glob, path, util, _;

  CoffeeScript = require('coffee-script');

  exports.coffee = function(options) {
    var print;
    if (options == null) {
      options = {};
    }
    print = exports.util.log('coffee');
    return function(files) {
      return files.map(function(d) {
        var content, dirname, filename;
        content = d.content, filename = d.filename, dirname = d.dirname;
        print("compiling " + filename);
        if (filename.match(/.litcoffee/)) {
          if (options.literate == null) {
            options.literate = true;
          }
        }
        d.content = CoffeeScript.compile(content, options);
        d.filename = filename.replace('.coffee', '.js');
        return d;
      });
    };
  };

  _ = require('underscore');

  exports.join = function(options) {
    var print, rename;
    print = exports.util.log('join');
    rename = {
      exports: exports
    };
    return function(files) {
      var content, dirname, filename;
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

  fs = require('fs');

  path = require('path');

  util = require('util');

  exports.util = {};

  exports.util.log = function(moduleName) {
    return function(msg) {
      return util.format('%s: %s', moduleName, msg);
    };
  };

  exports.File = (function() {
    function File(_arg) {
      this.content = _arg.content, this.dirname = _arg.dirname, this.filename = _arg.filename;
    }

    return File;

  })();

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
        dirname = path.dirname(file);
        return new exports.File({
          content: content,
          dirname: dirname,
          filename: filename
        });
      });
    })));
  };

  _ = require('underscore');

  exports.rename = function(options) {
    var print;
    print = exports.util.log('rename');
    if (_.isString(options)) {
      return function(files) {
        return files.map(function(d) {
          return d.filename = options;
        });
      };
    } else if (_.isArray(options)) {
      return function(files) {
        files.forEach(function(d, i) {
          var name;
          name = options[i];
          if ((name != null) && _.isString(name)) {
            return d.filename = options[i];
          }
        });
        return files;
      };
    } else if (_.isFunction(options)) {
      return function(files) {
        return files.map(options);
      };
    } else {
      return d;
    }
  };

  fs = require('fs');

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
        return fs.writeFileSync(filename, content, 'utf-8', function(error) {
          if (error) {
            throw error;
          }
        });
      });
      return files;
    };
  };

}).call(this);
