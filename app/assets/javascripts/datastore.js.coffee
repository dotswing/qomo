within 'datastore', ->
  $('table.files th:first-of-type input[type=checkbox]').change ->
    if $(this).is(':checked')
      $('table.files tr td:first-of-type input[type=checkbox]').prop 'checked', 'checked'
    else
      $('table.files tr td:first-of-type input[type=checkbox]').removeAttr 'checked'
