within 'tools', ->
  tpl_tr_param = $('#tpl_tr_param').text()

  $('.add-param').click ->
    $tr_empty = $(this).parents('fieldset').find('table tr.empty')
    if $tr_empty.length > 0
      $tr_empty.remove()
    $(this).parents('fieldset').find('table').append tpl_tr_param

  $('.params .remove').click ->
    $(this).parents('tr').remove()

  $('.save-tool').click ->
    $form = $('#form-tool')
    $form.submit()
