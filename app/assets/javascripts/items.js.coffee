$ ->

  $('.add_a_comment_link').bind "click", ->
    $(this).parent().parent().next().next().slideToggle()
    false

  $('.show_comments_link').bind "click", ->
    if $(this).hasClass('enabled')
      $(this).next().slideToggle()  

  $('.thumbnail').tooltip
    placement: 'bottom'
    
initTagInput = ->
  $tagInput = $('input[name="item[tag_list]"]')

  $tagInput.tokenInput "/items/tags.json",
    theme             : 'facebook'
    tokenValue        : 'name'
    allowFreeTagging  : true
    prePopulate       : $tagInput.data('tags')

$ ->
  initTagInput()

# Turbolink 이벤트를 통한 처리
$(document).on 'page:load', initTagInput