window.plump = {}

hightest_zIndex = 50
toolbox_offset = 0

autoZIndex = ($box) ->
  hightest_zIndex += 2
  $box.css 'z-index', hightest_zIndex
  for ep in plump.getEndpoints $box.attr('id')
    $(ep.canvas).css 'z-index', hightest_zIndex + 1


add_toolbox = (box)->
  $box = $(box)

  $box.offset
    top: toolbox_offset
    left: toolbox_offset
  toolbox_offset += 30
  if toolbox_offset > 400
    toolbox_offset = 5

  $('#canvas').append $box
  plump.draggable $box

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

    y = (titleHeight+tdHeight*i+20) / divHeight

    color =  unless is_input then "#558822" else "#225588"

    plump.addEndpoint $box.attr('id'),
      container: "##{$box.attr 'id'}"
      endpoint: 'Rectangle'
      anchor: [1, y, 1, 0]
      paintStyle:
        fillStyle: color
        width: 15
        height: 15
      isSource: not is_input
      isTarget: is_input

  autoZIndex $box
  $box.mousedown ->
    if ($box.css 'z-index') < hightest_zIndex
      autoZIndex $box


within 'workspace', ->
  $('#main').layout
    'west__size': .15
    'east__size': .15
    'stateManagement__enabled': true
    'stateManagement__autoLoad': true
    'stateManagement__autoSave': true


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
    window.plump = jsPlumb.getInstance
      DragOptions:
        cursor: 'pointer'
        zIndex: 2000

    $('.tool-groups a.tool-link').click ->
      $.get this.href, (box) -> add_toolbox(box)
      return false
