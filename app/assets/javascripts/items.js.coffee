$ ->


  # $('.ace-editor')[0].attr('display', 'block')
  $('#item_is_markdown').click ->
    if confirm "Are you sure?"
      if $(this).is(':checked') is true
        $('.ace-editor').attr('display', 'block')
        $('.note-editor').hide()
      else
        $('.ace-editor').attr('display', 'none')
        $('.note-editor').show()
    else
      false

  $('.add_a_comment_link').bind "click", ->
    $(this).parent().parent().next().next().slideToggle()
    false

  $('.show_comments_link').bind "click", ->
    if $(this).hasClass('enabled')
      $(this).next().slideToggle()  

  $('.thumbnail').tooltip
    placement: 'bottom'


  $(".wmd-help-button").html("<a id='markdown-help-link'></a>")
  $("#markdown-help-link").click ->
    $("#editor-help-panel").slideToggle('fast')
    false

