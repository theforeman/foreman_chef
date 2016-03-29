$(document).on('ContentLoad', function () {
  JSONEditor.defaults.themes.foreman = JSONEditor.defaults.themes.bootstrap2.extend({
    getIndentedPanel: function () {
      var el = document.createElement('div');
      return el;
    },
    getSelectInput: function(options) {
      var input = this._super(options);
      input.style.maxWidth = '100%';
      input.style.width = '80px';
      return input;
    }
  });
  JSONEditor.defaults.options.theme = 'foreman';
  JSONEditor.defaults.options.iconlib = 'fontawesome4';

  var runlist_schema = {
    "type": "array",
    "title": "Node run list",
    "format": "table",
    "items": {
      "type": "object",
      "properties": {
        "type": {
          "type": "string",
          "enum": [
            "role",
            "recipe"
          ],
          "default": "role"
        },
        "name": {
          "type": "string"
        }
      }
    },
    "default": $("#runlist-editor").data('default')
  };

  // runlist-editor does not exist after host submit (AJAX) redirection to show page or partial
  // host form refresh
  if ($("#runlist-editor").length) {
    var runlist_editor = new JSONEditor($("#runlist-editor")[0], {
      schema: runlist_schema,
      disable_properties: true,
      disable_collapse: true,
      no_additional_properties: true,
      form_name_root: 'host[run_list]'
    });
  }

  $('a.refresh_run_list').bind('click', function () {
    runlist_editor.setValue($(".refresh_run_list").data('runList'))
  });
});
