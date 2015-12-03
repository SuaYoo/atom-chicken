{CompositeDisposable} = require 'atom'

module.exports = Chicken =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'chicken:convert': => @convert()

  deactivate: ->
    @subscriptions.dispose()

  convert: ->
    if editor = atom.workspace.getActiveTextEditor()
      text = editor.getText()
      selection = editor.getSelectedText()

      RE = /\b(?=\w*)\w+\b/g

      matchCase = (text, pattern) ->
        result = ''
        i = 0
        while i < text.length
          c = text.charAt(i)
          p = pattern.charCodeAt(i)
          if p >= 65 and p < 65 + 26
            result += c.toUpperCase()
          else
            result += c.toLowerCase()
          i++
        result

      chickenify = (txt) ->
        text.replace RE, (match) ->
          matchCase 'chicken', match

      if selection
        editor.insertText chickenify(selection)
      else
        editor.setText chickenify(text)
