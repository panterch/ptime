# Uses jQuery to slideToggle tables in boxes
$ ->
  $('.toggle-box').unbind('click').click ->
    $(this).parent().next().slideToggle('slow')
    $(this).toggleClass('hidden')

  $('.toggle-box-collapsed').toggleClass('hidden').parent().next().hide()
