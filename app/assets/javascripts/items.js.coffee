$ ->

  # tagsinput
  # $('#item_tag_list').tagsInput
  #   defaultText:'태그 추가'
  #   width:'100%'
  #   height:'1em'

  $('.add_a_comment_link').bind "click", ->
    $(this).parent().parent().next().next().slideToggle()
    false

  $('.show_comments_link').bind "click", ->
    if $(this).hasClass('enabled')
      $(this).next().slideToggle()  

  $('.thumbnail').tooltip
    placement: 'bottom'

  # to set summernote object
  # You should change '#post_content' to your textarea input id
  summer_note = $('#item_description')

  # to call summernote editor
  summer_note.summernote
    # to set options
    height:300  
    toolbar: [
                ['insert', ['link']],
                ["table", ["table"]], 
                ["style", ["style"]], 
                ["fontsize", ["fontsize"]], 
                ["color", ["color"]], 
                ["style", ["bold", "italic", "underline", "clear"]], 
                ["para", ["ul", "ol", "paragraph"]], 
                ["height", ["height"]], 
                ["help", ["help"]]
             ]

  # to set code for summernote
  summer_note.code summer_note.val()

  # to get code for summernote
  summer_note.closest('form').submit ->
    # alert $('#post_content').code()[0]
    summer_note.val summer_note.code()[0]
    true
    
initTagInput = ->
  $tagInput = $('input[name="item[tag_list]"]')

  $tagInput.tokenInput "/items/tags.json",
    theme             : 'facebook'
    tokenValue        : 'name'
    allowFreeTagging  : true
    prePopulate       : $tagInput.data('tags')

$ ->
  initTagInput()

  #$(document).on 'page:load', ->
  #  initTagInput()
