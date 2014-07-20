within 'users', ->
  $('input[type=checkbox][name=admin]').click ->
    uid = $(this).parents('tr').data 'uid'
    $.ajax
      url: "/admin/users/#{uid}/admin"
      method: 'put'
      data:
        admin: this.checked

    return true

