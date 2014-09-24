#= require jquery-tablesort
#= require semantic/javascript/semantic
#= require jquery-livequery
#= require artDialog/dialog
#= require artDialog/dialog-plus
#= require jquery-form


class GUID
  s4: ->
    Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)

  create: () ->
    "#{@s4()}#{@s4()}-#{@s4()}-#{@s4()}-#{@s4()}-#{@s4()}#{@s4()}#{@s4()}"


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

  setSelectValues: (select, values)->
    values = [] unless values
    $(select).find('option').each ->
      $(this).prop('selected', this.value in values)

  guid: ->
    new GUID().create()

  token: ->
    $('meta[name=csrf-token]').attr('content')


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

  $('.form-submit').click ->
    $(this).parents('form').submit()


  $('.popup[title]').popup
    position: 'bottom center'


  $(document).on 'click', '.remove-tr', ->
    remote = false
    params = {}
    $this = $(this)
    run = ->
      $this.closest('tr').remove()
    for k of this.dataset
      if k.indexOf('param') == 0
        remote = true
        params[k.substring('param'.length)] = this.dataset[k]

    if remote
      $.ajax
        url: this.href
        method: 'delete'
        data: params
        success: run
    else
      run()

    return false


  $(document).on 'click', '.add-tr', ->
    sel_target = $(this).data 'target'
    $target = {}
    if sel_target
      $target = $(sel_target)
    else
      $target = $(this).closest('table')


    $tr_empty = $target.find('tbody tr.empty')
    if $tr_empty.length > 0
      $tr_empty.remove()

    sel_tpl_tr = $(this).data 'tpl'

    $target.append $(sel_tpl_tr).text()
    return false


  $('table.sortable').tablesort()

$(document).on 'page:load', readyFn
$(document).on 'ready', readyFn


NProgress.configure
  showSpinner: false
  speed: 300
  minimum: 0.03
  ease: 'ease'
