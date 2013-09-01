$ ->
  $('#add_a_community_link').click ->
    $(this).parent().next().slideToggle()
    false
  $('#community_header_info_link').click ->
    $(this).parent().next().next().slideToggle()
    false