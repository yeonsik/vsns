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


initPageless = ->
  $items = $('#items')

  # items dom 존재여부 확인
  return unless $items.length

  # pageless 설정정보 dom에서 가져오기
  opts =
    totalPages  : $items.data('total-pages')
    url         : $items.data('url')
    loaderMsg   : 'Loading more pages...'
    loaderImage : $items.data('loader-image')

  # pageless 시작
  $items.pageless opts

# pageless 초기화
resetPageless = ->
  $items = $('#items')

  return unless $items.length

  $.pagelessReset()


$ -> 
  initPageless()

# Turbolink 이벤트를 통한 처리
$(document).on 'page:load', initPageless
$(document).on 'page:before-change', resetPageless # 화면 전환전 pageless 초기화