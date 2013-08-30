$ ->
  $("#comment_body").keypress (event) ->
    if event.which is 13
      event.preventDefault()
      $("#new_comment").submit()