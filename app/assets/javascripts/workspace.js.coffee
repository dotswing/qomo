window.plumb = {}

hightest_zIndex = 50
toolbox_offset = 0


init_cache = ->
  if not localStorage.tools
    localStorage.tools = '{}'

cached_tools = ->
  JSON.parse localStorage.tools

restore_workspace = ->
  tools = cached_tools()
  for i of tools
    tool = tools[i]
    add_toolbox tool.box, tool.position

save_cached_tools = (tools)->
  localStorage.tools = JSON.stringify tools

cache_toolbox = (box)->
  $box = $(box)
  tool = {}
  tool.box = box
  tools = cached_tools()
  tools[$box.attr 'id'] = tool
  save_cached_tools tools


update_zIndex = ($box, zIndex) ->
  hightest_zIndex += 2
  $box.css 'z-index', hightest_zIndex
  for ep in plumb.getEndpoints $box.attr('id')
    $(ep.canvas).css 'z-index', hightest_zIndex + 1


update_position = (tid, position) ->
  tools = cached_tools()
  tools[tid].position = position
  save_cached_tools tools


add_toolbox = (box, position, zIndex)->
  $box = $(box)

  if position
    $box.css
      top: position.top
      left: position.left
  else
    $box.offset
      top: toolbox_offset
      left: toolbox_offset
    toolbox_offset += 30
    if toolbox_offset > 400
      toolbox_offset = 5
    update_position $box.attr('id'), $box.position()

  $('#canvas').append $box

  plumb.draggable $box,
    stop: ->
      update_position $box.attr('id'), $box.position()

  # Avoid the jsPlumb endpoint display bug
  $box.find('.chosen').chosen()

  divHeight = $box.outerHeight()
  tdHeight = $box.find('td').outerHeight()
  titleHeight = $box.find('.titlebar').outerHeight()

  for param, i in $box.find('.params .param')
    $param = $(param)
    is_input = false
    if $param.hasClass 'input'
      is_input = true
    else if $param.hasClass 'output'
      is_input = false
    else
      continue

    y = (titleHeight+tdHeight*i + 20) / divHeight

    color =  unless is_input then "#558822" else "#225588"

    plumb.addEndpoint $box.attr('id'),
      container: "##{$box.attr 'id'}"
      endpoint: 'Rectangle'
      anchor: [1, y, 1, 0]
      paintStyle:
        fillStyle: color
        width: 15
        height: 15
      isSource: not is_input
      isTarget: is_input

  update_zIndex $box
  $box.mousedown ->
    if ($box.css 'z-index') < hightest_zIndex
      update_zIndex $box


within 'workspace', ->
  $('#main').layout
    'west__size': .15
    'east__size': .15
    'stateManagement__enabled': true
    'stateManagement__autoLoad': true
    'stateManagement__autoSave': true

  init_cache()

  $('.center .save').click ->
    console.debug 1


  $('.tool-groups h5').click ->
    $this = $(this)
    $ul = $(this).next('ul')
    $i = $(this).find('i')
    if $ul.is(':visible')
      $i.removeClass('fa-folder-open').addClass('fa-folder')
      $ul.slideUp 200, ->
        $this.css 'border-bottom-width', '0'
    else
      $i.removeClass('fa-folder').addClass('fa-folder-open')
      $this.css 'border-bottom-width', '1px'
      $ul.slideDown 200


  jsPlumb.ready ->
    window.plumb = jsPlumb.getInstance
      DragOptions:
        cursor: 'pointer'
        zIndex: 2000

    restore_workspace()

    $('.tool-groups a.tool-link').click ->
      $.get this.href, (box) ->
        cache_toolbox(box)
        add_toolbox(box)

      return false
