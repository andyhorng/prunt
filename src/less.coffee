'use strict'
less = require 'less'
Q = require 'q'

exports.less = (options = {}) ->
  (files) ->
    Q.all files.map (file) ->
      Q.nfcall(less.render, file.content)
        .then (css) ->
          file.content = css
          file.rename file.filename.replace '.less', '.css'
