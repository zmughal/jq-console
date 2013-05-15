// Generated by CoffeeScript 1.6.2
(function() {
  var jqconsole, keyDown, type, typeA, _ref, _ref1;

  _ref = jqconsoleSetup(), jqconsole = _ref.jqconsole, (_ref1 = _ref.typer, typeA = _ref1.typeA, keyDown = _ref1.keyDown, type = _ref1.type);

  describe('History', function() {
    describe('#GetHistory', function() {
      return it('gets the history', function() {
        jqconsole.Prompt(true, function() {});
        typeA();
        keyDown(13);
        return deepEqual(['a'], jqconsole.GetHistory());
      });
    });
    describe('#SetHistory', function() {
      return it('sets history', function() {
        var h;

        h = ['a', 'b'];
        jqconsole.SetHistory(h);
        return deepEqual(h, jqconsole.GetHistory());
      });
    });
    describe('#ResetHistory', function() {
      return it('resets the history', function() {
        jqconsole.ResetHistory();
        return deepEqual(jqconsole.history, []);
      });
    });
    return describe('History interaction in the prompt', function() {
      it('gets the prev history item', function() {
        jqconsole.Prompt(true, function() {});
        type('foo');
        equal(jqconsole.GetPromptText(), 'foo');
        keyDown(13);
        jqconsole.Prompt(true, function() {});
        equal(jqconsole.GetPromptText(), '');
        keyDown(38);
        equal(jqconsole.GetPromptText(), 'foo');
        return jqconsole.AbortPrompt();
      });
      return it('gets the next history item', function() {
        jqconsole.Prompt(true, function() {});
        type('foo');
        keyDown(13);
        jqconsole.Prompt(true, function() {});
        type('bar');
        keyDown(13);
        jqconsole.Prompt(true, function() {});
        keyDown(38);
        equal(jqconsole.GetPromptText(), 'bar');
        keyDown(38);
        equal(jqconsole.GetPromptText(), 'foo');
        keyDown(40);
        equal(jqconsole.GetPromptText(), 'bar');
        keyDown(40);
        return equal(jqconsole.GetPromptText(), '');
      });
    });
  });

}).call(this);
