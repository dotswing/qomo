within 'scholar', ->
  $('table.publications a.add, table.publications a.del').click ->
    $this = $(this)
    $.get this.href, ->
      $this.parents('tr').remove()
      alert 'Success'
    false
