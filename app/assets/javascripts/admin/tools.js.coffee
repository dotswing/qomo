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

  $('.params .edit-options').click ->
    $options = $(this).parents('tr').find('.options')


    offset = $(this).position()
    width = $(this).outerWidth()
    height = $(this).outerHeight()
    popupWidth   = $options.width()

    console.debug height

    $options.css
      top    : offset.top + height + 1
      left   : offset.left + (width / 2) - (popupWidth / 2) + 1
      bottom : 'auto'
      right  : 'auto'

    $options.show()

  $('.params .options button').click ->
    $(this).parents('.options').hide()
    return false
