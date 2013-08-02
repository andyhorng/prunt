exports.header = (string) ->
  (files) ->
    files.forEach (file) ->
      file.content = "#{string}\n#{file.content}"
    files
