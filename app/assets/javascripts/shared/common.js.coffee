#= require jquery-tablesort
#= require semantic

window.App =
  scopes: {}
  goto: (url) ->
    Turbolinks.visit(url)
  open: (url) ->
    window.open(url)

  getSelectedRowIds: ($table)->
    row_ids = []
    $table.find('tr td:first-of-type input[type=checkbox]:checked').each ->
      row_ids.push $(this).parents('tr').data 'row-id'
    return row_ids


window.within = (scope, fn)->
  App.scopes[scope] = fn


readyFn = ->
  bodyId = document.body.id
  controller = bodyId.substring 0, bodyId.indexOf('-')
  App.scopes[bodyId]() if App.scopes[bodyId]
  App.scopes[controller]() if App.scopes[controller]

  $('.chosen').chosen()

  $('table.row-selectable tr th:first-of-type input[type=checkbox]').click ->
    checked = this.checked
    $(this).parents('table.row-selectable').find('tr td:first-of-type input[type=checkbox]').each ->
      this.checked = checked
      return true
  $('table.row-selectable tr td:first-of-type input[type=checkbox]').click ->
    $(this).parents('table.row-selectable').find('tr th:first-of-type input[type=checkbox]').removeAttr 'checked'

  $('a.btn-row-selectable').click ->
    ids = App.getSelectedRowIds $($(this).data('rowselectable'))
    this.href += '?'
    for id in ids
      this.href += "ids[]=#{id}&"
    return true

  $('.ui.dropdown').dropdown()

  $('*[title]').popup
    position: 'bottom center'

  $('table.sortable').tablesort()

$(document).on 'page:load', readyFn
$(document).on 'ready', readyFn


NProgress.configure
  showSpinner: false
  speed: 300
  minimum: 0.03
  ease: 'ease'
