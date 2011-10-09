# Handles attaching date/time picker functionality to appropriate input 
# fields:
#   DatePicker for class 'ui-datepicker'
#   TimePicker for class 'ui-timepicker'
$ ->
  # jQuery Datepicker helper
  $('input.ui-datepicker').datepicker({ dateFormat: 'dd M yy' })

  # add Datepicker to facebox dynamic content
  $('#facebox .ui-datepicker').live 'focusin', =>
    $('#facebox .ui-datepicker').datepicker({ dateFormat: 'dd M yy' })

  # jQuery Timepicker helper
  $('input.ui-timepicker').timepicker({ dateFormat: 'hh:mm' })
