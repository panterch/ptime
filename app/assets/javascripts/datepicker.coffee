# Handles attaching date/time picker functionality to appropriate input 
# fields:
#   DatePicker for class 'ui-datepicker'
#   TimePicker for class 'ui-timepicker'
$ ->
  # jQuery Datepicker helper
  $('input.ui-datepicker').datepicker()

  # jQuery Timepicker helper
  $('input.ui-timepicker').timepicker()
