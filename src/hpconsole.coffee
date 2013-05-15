class HPConsole extends JQConsole
  
$.fn.hpconsole = (header, prompt_main, prompt_continue) ->
  new HPConsole this, header, prompt_main, prompt_continue

$.fn.jqconsole.HPConsole = HPConsole
$.fn.jqconsole.Ansi = Ansi
