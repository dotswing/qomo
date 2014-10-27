within 'pipelines', ->
  $('.edit').click ->
    $.ajax
      url: this.href,
      method: 'get',
      success: (data)->
        dia = dialog
          title: 'Save pipeline'
          content: data
          width: 700
          okValue: 'Save'
          ok: ->
            $form = $('#form-pipeline')
            $form.submit()
            return true
          cancelValue: 'Cancel'
          cancel: ->

        dia.showModal()

    return false
