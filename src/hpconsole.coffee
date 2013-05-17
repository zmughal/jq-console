# Shorthand for jQuery.
$ = jQuery

KEY_N = parseInt 'N'
KEY_P = parseInt 'P'
KEY_T = parseInt 'T'
KEY_W = parseInt 'W'

class HPConsole extends JQConsole
  constructor: (@container, header, prompt_label, prompt_continue_label) ->
    super(@container, "Welcome to HotPie\n", "HP> ", ".")

  # Delete to beginning of line
  BackspaceToBegin: ->
    setTimeout $.proxy(@_ScrollToEnd, @), 0
    text = @$prompt_left.text()
    if text
      @$prompt_left.text ''
    else
      @_Backspace false

  # Delete to end of line
  DeleteToEnd: ->
    text = @$prompt_right.text()
    if text
        @$prompt_right.text ''
    else
      @_Delete false

$.fn.hpconsole = (header, prompt_main, prompt_continue) ->
  new HPConsole this, header, prompt_main, prompt_continue

$.fn.hpconsole.HPConsole = HPConsole
$.fn.hpconsole.Ansi = Ansi
