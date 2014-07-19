within 'tool_groups', ->
  $('.groups .edit').click ->
    $.get this.href, (data) ->
      dia = dialog
        title: 'Save tool group'
        content: data
        width: 700
        okValue: 'Save'
        ok: ->
          $form = $('#form-group')
          $form.submit()
          return true
        cancelValue: 'Cancel'
        cancel: ->
      dia.showModal()
    return false
