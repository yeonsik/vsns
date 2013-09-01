$ ->
  $("#comment_body, #community_name").keypress (event) ->
    if event.which is 13
      event.preventDefault()
      $(this).closest('form').submit()