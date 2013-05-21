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
    if key == KEY_TAB
      if event.shiftKey # shift-tab
        if @$is_completion
          event.preventDefault()
          @SelectPreviousCompletion()
          return
        else # de-indent as before
          super
          return
      else # tab
        if @$is_completion
          # already completing, so it should select the next item in the list
          event.preventDefault()
          @SelectNextCompletion()
          return
        else
          event.preventDefault()
          if @ShouldIndent()
            super
          else
            @Complete()
          return
    else if key == KEY_BACKSPACE
      if @ShouldDeindent()
        @_Unindent()
        return
      else
        super
        return
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

  # This is used to determine whether we should indent or use completion
  #
  # if there is just white-space (or nothing) on the left, we can tab over
  # otherwise we use completion
  ShouldIndent: ->
    @$prompt_left.text().match(/^\s*$/)

  # This is used to determine if we should de-indent on a backspace on
  # white-space on the left
  #
  # the whitespace must be a multiple of the DEFAULT_INDENT_WIDTH
  ShouldDeindent: ->
    @$prompt_left.text().length > 0 \
      and @$prompt_left.text().match(/^\s*$/) \
      and ( @$prompt_left.text().length % DEFAULT_INDENT_WIDTH ) == 0


$.fn.hpconsole = (header, prompt_main, prompt_continue) ->
  new HPConsole this, header, prompt_main, prompt_continue

$.fn.hpconsole.HPConsole = HPConsole
$.fn.hpconsole.Ansi = Ansi
