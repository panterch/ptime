# Adds superfish menu

$ ->
  window.superfish_init = superfish_init = $('nav ul.sf-menu')
  return unless superfish_init.length

  superfish_init.superfish()
