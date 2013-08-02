exports.footer = (string) ->
  (files) ->
    files.forEach (file) ->
      file.content = "#{file.content}\n#{string}"
    files
