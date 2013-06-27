(function() {
  'use strict';
  var CoffeeScript, Q, UglifyJS, cleanCSS, fs, glob, less, mkdirp, partial, path, rimraf, util, _,
    __slice = [].slice;

  fs = require('fs');

  path = require('path');

  rimraf = require('rimraf');

  exports.clean = function() {
    var print;
    print = exports.util.log('clean');
    return function(files) {
      files.forEach(function(file) {
        var dirname, filename;
        filename = file.filename, dirname = file.dirname;
        filename = path.normalize(path.join(dirname, filename));
        print("deleting " + filename);
        return rimraf.sync(filename);
      });
      return [];
    };
  };

  'use strict';

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

  'use strict';

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

  'use strict';

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

  'use strict';

  less = require('less');

  Q = require('q');

  exports.less = function(options) {
    if (options == null) {
      options = {};
    }
    return function(files) {
      return Q.all(files.map(function(file) {
        return Q.nfcall(less.render, file.content).then(function(css) {
          file.content = css;
          return file.rename(file.filename.replace('.less', '.css'));
        });
      }));
    };
  };

  'use strict';

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

  'use strict';

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

  'use strict';

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

  'use strict';

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

  'use strict';

  fs = require('fs');

  path = require('path');

  _ = require('underscore');

  Q = require('q');

  exports.usemin = function(options) {
    var Info, print, regbuild, regend, regsrc;
    if (options == null) {
      options = {};
    }
    print = exports.util.log('usemin');
    regbuild = /<!--\s*build:(\w+)(?:\(([^\)]+)\))?\s*([^\s]+)\s*-->/;
    regend = /<!--\s*endbuild\s*-->/;
    regsrc = /(?<=src=").+(?=">)/;
    Info = (function() {
      function Info() {
        this.isBuilding = false;
        this.src = [];
        this.template = '';
      }

      Info.prototype.start = function(_arg) {
        this.type = _arg.type, this.alternatePath = _arg.alternatePath, this.output = _arg.output;
        this.isBuilding = true;
        return this;
      };

      Info.prototype.compile = function() {
        var File, coffee, concat, cssmin, dirname, filename, noop, read, uglify;
        noop = Q.when('');
        if (!this.isBuilding) {
          return noop;
        }
        filename = path.basename(this.output);
        dirname = path.dirname(this.output);
        read = exports.read, concat = exports.concat, cssmin = exports.cssmin, uglify = exports.uglify, coffee = exports.coffee, File = exports.File;
        switch (this.type) {
          case 'js':
            return read(this.src).then(concat()).then(uglify());
          case 'css':
            return read(this.src).then(concat()).then(cssmin());
          case 'coffee':
            return read(this.src).then(concat()).then(coffee()).then(uglify);
          default:
            return noop;
        }
      };

      return Info;

    })();
    return function(files) {
      files.forEach(function(file, i) {
        var content, f, info, lines, queue;
        content = file.content;
        lines = content.split('\n');
        info = new Info();
        queue = [];
        f = function(line) {
          var alternatePath, footer, header, output, src, type, _ref;
          header = line.match(regbuild);
          if (header) {
            _ref = header, header = _ref[0], type = _ref[1], alternatePath = _ref[2], output = _ref[3];
            info.start({
              type: type,
              alternatePath: alternatePath,
              output: output
            });
            return null;
          }
          footer = line.match(regend);
          if (footer) {
            queue.push(info.compile());
            info = new Info();
            return info.template.replace(regsrc, info.output);
          }
          if (info.isBuilding) {
            src = line.match(regsrc)[0];
            if (src) {
              info.src.push(src);
              if (info.template == null) {
                info.template = line;
              }
            }
            return null;
          }
          return line;
        };
        file.content = _.chain(lines).map(f).compact().join('\n').value();
        return queue.push(Q.when(file));
      });
      return Q.all(_.flatten(queue));
    };
  };

  'use strict';

  fs = require('fs');

  path = require('path');

  mkdirp = require('mkdirp');

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
        if (!fs.existsSync(dirname)) {
          mkdirp.sync(dirname);
        }
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
