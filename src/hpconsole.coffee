# Shorthand for jQuery.
$ = jQuery

KEY_N = parseInt 'N'
KEY_P = parseInt 'P'
KEY_T = parseInt 'T'
KEY_W = parseInt 'W'
KEY_U = parseInt 'U'
KEY_ESC = 27

PROMPT_MARKER_ID = 'prompt-completion-marker'
PROMPT_INPUT_ID = 'prompt-completion-input'

class HPConsole extends JQConsole
  constructor: (@container, header, prompt_label, prompt_continue_label) ->
    super(@container, "Welcome to HotPie\n", "HP> ", ".")
    # callback used to retrieve data for completion
    @completion_callback = null
    # boolean to determine whether completion is currently open
    @$is_completion = false

  Reset: ->
    @completion_callback = null
    @EndCompletion()
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
      ## prevent browser default keys
      ## c.f. <http://stackoverflow.com/questions/7295508/javascript-capture-browser-shortcuts-ctrlt-n-w>
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
      else
        super
      if @$is_completion
        @UpdateCompletionMenu()
      return
    else if key == KEY_ESC
      if @$is_completion
        @EndCompletion()
        return
    else if key == KEY_ENTER
      if @$is_completion
        @AcceptCompletion()
        return
    super
    if @$is_completion
      @UpdateCompletionMenu()

  _HandleChar: (event) =>
    super
    if @$is_completion
      @UpdateCompletionMenu()

  AcceptCompletion: ->
    current_text = @GetCompletionItemSelected()
    @$prompt_left.text( @$prompt_left.text().substring(0, @$completion_start_idx) )
    @_AppendPromptText(current_text.substring(@$completion_prefix_idx))
    @EndCompletion()

  GetCompletionItemSelected:  ->
    items = @GetCompletionItems()
    if @$prompt_current_idx >= 0 && @$prompt_current_idx < items.length
      return $(items[@$prompt_current_idx]).text()
    return ''

  GetCompletionItems: ->
    $(@$prompt_completion_input.autocomplete("widget").find("a"))

  SelectPreviousCompletion: ->
    items = @GetCompletionItems()
    if @$prompt_current_idx == -1 # in the initial state, this will go to end
      @$prompt_current_idx = items.length
    if @$prompt_current_idx > 0
      @$prompt_current_idx--
    else
      @$prompt_current_idx = items.length - 1
    @SelectNthCompletion(@$prompt_current_idx)

  SelectNextCompletion: ->
    items = @GetCompletionItems()
    # in the initial state, this will go to item 0
    if @$prompt_current_idx < items.length - 1
      @$prompt_current_idx++
    else # if at end, loop to beginning
      @$prompt_current_idx = 0
    @SelectNthCompletion(@$prompt_current_idx)

  SelectNthCompletion: (n) ->
    items = @GetCompletionItems()
    items.removeClass("ui-state-focus")
    $(items[n]).addClass("ui-state-focus")

  UpdateCompletionMenu: ->
    if @$prompt_left.text().length < @$completion_start_idx or @$prompt_left.text().length == 0
      @EndCompletion()
      return
    @$prompt_completion_input.val(@$prompt_left.text().substring(@$completion_start_idx))
    @$prompt_completion_input.autocomplete 'search'

  # completion callback
  # function(text, response_callback )
  #
  # - text is string of the text to the left of the cursor
  # - response_callback is a function that takes an array of completion items
  #   as its only parameter
  SetCompletionCallback: (completion_callback) ->
    @completion_callback = completion_callback

  # adds the completion input field as hidden element
  # after the prompt
  SetupCompletion: (results) ->
    orig_text = @$prompt_left.text()
    match = orig_text.match /\b([A-Za-z0-9:]*)$/
    text_before_space = orig_text.substr(0, match.index)
    text_after_space = orig_text.substr(match.index)
    console.log(text_before_space)
    console.log(text_after_space)
    @$prompt_left.text(text_before_space)
    # Used to mark position of completion menu to the left of the cursor.
    # It needs to before the last word boundary.
    @$prompt_completion_mark = $('<span id=' + '"' + PROMPT_MARKER_ID + '"' +
      'style="position: relative"></span>').appendTo @$prompt_left
    # input field that the autocomplete menu is attached to
    pm_input_html = '<input type="text" id=' + '"' + PROMPT_INPUT_ID + '"' + ' />'
    @$prompt_completion_input = $(pm_input_html)# .appendTo( @$prompt_current )
    @$prompt_completion_input.css
      display: 'none'
    @$prompt_current_idx = -1 # the current selected index in the menu

    @$prompt_completion_input.autocomplete
      source: (request, response) ->
        response( $.grep( results, (item, item_ndx) ->
          # match the items in the list that start with the input text
          return item.indexOf(request.term) == 0 ) )
      position: { of: "#" + PROMPT_MARKER_ID }
      minLength: 0

    @$prompt_completion_input.val ''
    # activate menu immediately (for positioning)
    @$prompt_completion_input.autocomplete 'search'
    @$prompt_completion_input.autocomplete 'close'
    @$prompt_completion_input.autocomplete 'search'

    @$prompt_completion_input.val text_after_space
    @$prompt_left.text(orig_text)

    # the text location where the completion started
    @$completion_start_idx = @$prompt_left.text().length
    @$completion_prefix_idx = text_after_space.length

  # remove the completion input field
  BreakdownCompletion: ->
    @$prompt_completion_mark.remove()
    @$prompt_completion_input.remove()
    @$completion_start_idx = -1
    return

  Complete: ->
    @$is_completion = true
    text = @$prompt_left.text() # this is not right (i.e. correct), but it is left
    # --- need to use @GetPromptText(), @GetLine(), @GetColumn()
    # get array of results
    @completion_callback text, (completion_results) =>
      if completion_results.length
        @SetupCompletion completion_results
      else
        @EndCompletion

  # Insert text and end the completion mode
  InsertCompletion: (text) ->
    @_AppendPromptText text
    @EndCompletion()

  # append contents of completion field to @prompt_left
  # and then remove all changes to the prompt
  EndCompletion: ->
    @$is_completion = false
    @BreakdownCompletion()
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
