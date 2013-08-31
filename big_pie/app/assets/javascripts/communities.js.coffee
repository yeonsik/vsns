$ ->

  # tagsinput
  # $('#item_tag_list').tagsInput
  #   defaultText:'태그 추가'
  #   width:'100%'
  #   height:'1em'

  $('.add_a_community_link').bind "click", ->
  	$(this).parent().next().slideToggle()
  	false