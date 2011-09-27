# Adds fields dynamically (such as tasks in a project)
addFields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp('new_' + association, 'g')
  $(link).before(content.replace(regexp, new_id))

$ ->
  # jQuery Datepicker helper
  $('input.ui-datepicker').datepicker()

  # jQuery Timepicker helper
  $('input.ui-timepicker').timepicker({ showPeriod: true })
