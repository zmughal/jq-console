// Generated by CoffeeScript 1.6.2
(function() {
  var JQConsole;

  window.equal = assert.equal;

  window.deepEqual = assert.deepEqual;

  window.strictEqual = assert.strictEqual;

  window.ok = assert.ok;

  JQConsole = $().jqconsole.JQConsole;

  window.jqconsoleSetup = function() {
    var $container, jqconsole, typer;

    $container = $('<div/>');
    jqconsole = new JQConsole($container, 'header', 'prompt_label', 'prompt_continue');
    typer = {
      typeA: function() {
        var e;

        e = $.Event('keypress');
        e.which = 'a'.charCodeAt(0);
        return jqconsole.$input_source.trigger(e);
      },
      keyDown: function(code, options) {
        var e, k, v;

        if (options == null) {
          options = {};
        }
        e = $.Event('keydown');
        e.which = code;
        for (k in options) {
          v = options[k];
          e[k] = v;
        }
        return jqconsole.$input_source.trigger(e);
      },
      type: function(str) {
        var chr, type, _i, _len, _results;

        type = function(chr) {
          var e;

          e = $.Event('keypress');
          e.which = chr.charCodeAt(0);
          return jqconsole.$input_source.trigger(e);
        };
        _results = [];
        for (_i = 0, _len = str.length; _i < _len; _i++) {
          chr = str[_i];
          _results.push(type(chr));
        }
        return _results;
      }
    };
    return {
      $container: $container,
      jqconsole: jqconsole,
      typer: typer
    };
  };

}).call(this);
