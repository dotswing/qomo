within 'datastore', ->
  $('table.files th:first-of-type input[type=checkbox]').change ->
    if $(this).is(':checked')
      $('table.files tr td:first-of-type input[type=checkbox]').prop 'checked', 'checked'
    else
      $('table.files tr td:first-of-type input[type=checkbox]').removeAttr 'checked'

  endpoint = $('#uploader').data 'endpoint'
  uploader = $('#uploader').fineUploader
    request:
      inputName: 'file'
      filenameParam: 'filename'
      endpoint: endpoint
      params:
        authenticity_token: App.token()
    autoUpload: false
    editFilename:
      enabled: true

  $('#trigger-upload').click ->
    uploader.fineUploader 'uploadStoredFiles'

  $('.trash').click ->
    $.post $(this).data('url'),
        filenames: App.getSelectedRowIds $('.files')
      , (data)->
        window.location.reload()
