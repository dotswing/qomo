
window.plump = {}

add_toolbox = (box)->
  $box = $(box)
  $('#canvas').append $box
  plump.draggable $box
  plump.addEndpoint $box.attr('id')


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
      container: 'canvas'
      DragOptions:
        cursor: 'pointer'
        zIndex: 2000

    $('.tool-groups a.tool-link').click ->
      $.get this.href, (box) -> add_toolbox(box)
      return false
