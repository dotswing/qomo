within 'tools', ->
  tpl_tr_param = $('#tpl_tr_param').text()

  $('.add-param').click ->
    $tr_empty = $(this).parents('fieldset').find('table tr.empty')
    if $tr_empty.length > 0
      $tr_empty.remove()
    $(this).parents('fieldset').find('table.params > tbody').append tpl_tr_param


  $(document).on 'click', '.params .remove', ->
    $(this).parents('tr').remove()


  $('.save-tool').click ->
    $form = $('#form-tool')
    $form.submit()


  $(document).on 'click', '.params .edit-options', ->
    $options = $(this).parents('tr').find('.options')


    offset = $(this).position()
    width = $(this).outerWidth()
    height = $(this).outerHeight()
    popupWidth   = $options.width()

    $options.css
      top    : offset.top + height + 1
      left   : offset.left + (width / 2) - (popupWidth / 2) + 1
      bottom : 'auto'
      right  : 'auto'

    $options.show()


  $(document).on 'click', '.params .options button', ->
    $(this).parents('.options').hide()
    return false


  $(document).on 'change', 'select[name="tool[params][][type]"]', ->
    $(this).parents('td').next().html $("#tpl_param_#{this.value}").text()

