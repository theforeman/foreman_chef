$(function () {
  $("#host_chef_proxy_id, #hostgroup_chef_proxy_id").change(function () {
    var element = $(this);
    var attrs = attribute_hash(['chef_proxy_id']);
    var url = element.attr('data-url');
    if (element.attr('id') == 'host_chef_proxy_id') {
      attrs['type'] = 'host'
    } else {
      attrs['type'] = 'hostgroup'
    }

    foreman.tools.showSpinner();
    $.ajax({
      data: attrs,
      type: 'get',
      url: url,
      complete: function () {
        reloadOnAjaxComplete(element);
      },
      success: function (request) {
        $('#host_chef_environment_id, #hostgroup_chef_environment_id').parent().parent().replaceWith(request);
      }
    });
  });
});

