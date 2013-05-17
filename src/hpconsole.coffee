# Shorthand for jQuery.
$ = jQuery

KEY_N = parseInt 'N'
KEY_P = parseInt 'P'
KEY_T = parseInt 'T'
KEY_W = parseInt 'W'

class HPConsole extends JQConsole
  constructor: (@container, header, prompt_label, prompt_continue_label) ->
    super(@container, "Welcome to HotPie\n", "HP> ", ".")
    # callback used to retrieve data for completion
    @completion_callback = null
    # boolean to determine whether completion is currently open
    @is_completion = false

  Reset: ->
    @completion_callback = null
    EndCompletion()
    return super

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

  _HandleKey: (event) =>
    key = event.keyCode or event.which
    if event.ctrlKey
      switch key
        when KEY_T, KEY_W, KEY_N, KEY_P
          # default keys c.f. <http://stackoverflow.com/questions/7295508/javascript-capture-browser-shortcuts-ctrlt-n-w>
          if key of @shortcuts
            event.preventDefault()
    else if key == KEY_TAB
      if event.shiftKey
        if @is_completion
          SelectPreviousCompletion()
      else
        if @is_completion
          SelectNextCompletion()
        else
          Complete()
    super

  SelectPreviousCompletion: ->
    return

  SelectNextCompletion: ->
    return

  # TODO completion callback
  # need to pass in: text to left
  SetCompletionCallback: (completion_callback) ->
    @completion_callback = completion_callback

  Complete: ->
    @is_completion = true
    text = @$prompt_left.text()
    # TODO retrieve results
    @completion_callback text

  # Insert text and end the completion mode
  InsertCompletion: (text) ->
    @_AppendPromptText text
    EndCompletion()

  EndCompletion: ->
    @in_composition = false
    return

$.fn.hpconsole = (header, prompt_main, prompt_continue) ->
  new HPConsole this, header, prompt_main, prompt_continue

$.fn.hpconsole.HPConsole = HPConsole
$.fn.hpconsole.Ansi = Ansi
