# Shorthand for jQuery.
$ = jQuery

class HPConsole extends JQConsole
  constructor: (@container, header, prompt_label, prompt_continue_label) ->
    super(@container, "Welcome to HotPie\n", "HP>", ".")

$.fn.hpconsole = (header, prompt_main, prompt_continue) ->
  new HPConsole this, header, prompt_main, prompt_continue

$.fn.hpconsole.HPConsole = HPConsole
$.fn.hpconsole.Ansi = Ansi
