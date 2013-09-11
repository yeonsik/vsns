$ ->
  $('#add_a_community_link').click ->
    $(this).parent().next().slideToggle()
    false
  $('#community_header_info_link').click ->
    $(this).parent().parent().find('.info').slideToggle()
    false