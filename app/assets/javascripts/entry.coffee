# Handles time entry creation and modification including specific time/date
# picker logic

$ ->
  window.entry = entry = $('#entry-ui-datepicker')
  return unless entry.length

  # Add time input method radio button logic
  entry.toggleTimeInputMethod = ->
    entry.toggleDisable($('#entry_start'))
    entry.toggleDisable($('#entry_end'))
    entry.toggleDisable($('#entry_duration_hours'))

  # Toggle disabled state of the given field
  entry.toggleDisable = (field) ->
    if field.attr('disabled')
      field.removeAttr('disabled')
    else
      field.attr('disabled', true)

  # Initialize the time input method by disabling the duration field by
  # default
  entry.toggleDisable($('#entry_duration_hours'))

  # If the previous time capture method was 'duration', toggle again
  if $('input[name=time_capture_method]:checked').val() == 'duration'
    entry.toggleTimeInputMethod()

  # Toggle between date or time entry method by either disabling
  #  * the duration field
  #  * the start -and end time picker fields
  $('input[name=time_capture_method]').click ->
    entry.toggleTimeInputMethod()

  # Reload entry form for chosen date
  $('#entry-ui-datepicker').datepicker({
    onSelect: (dateText, inst) ->
      date = new Date(dateText)
      day = $.datepicker.formatDate("dd-mm-yy", date)
      $('#entry_day_input').val(day)
  })

  # Change date on entry datepicker. It will be set by new and edit actions
  $('#entry-ui-datepicker').datepicker('setDate', new Date($('input#entry_day_input').val()))

  # Calculate entry duration from start:end
  $('#entry_end').change ->
    start_time = $('#entry_start').val()
    end_time = $('#entry_end').val()
    day = $('input#entry_day_input').val()
    if start_time
      start_date = new Date(day + ' ' + start_time)
    end_date = new Date(day + ' ' + end_time)
    if end_date > start_date
      diff = new Date()
      diff.setTime(end_date - start_date)
      $('#entry_duration_hours').val(diff.getHours()+':'+ $.format('%02d', [diff.getMinutes()]))
    else
      $('#entry_duration_hours').val('')

  # Discard entry start:end if duration is edited manually
  $('#entry_duration_hours').change ->
    $('#entry_start').val('')
    $('#entry_end').val('')

  # Fetch associated tasks for a given project in entry form
  $('#entry_project_id').change ->
    $('#entry_task_id').find('option').remove()
    project_id = $('select#entry_project_id :selected').val()
    tasks_from_projects = $.parseJSON($('#tasks_collection_storage').val())
    for i, item of tasks_from_projects[project_id]
      $('#entry_task_id').append(
        $('<option></option>').val(item.id).html(item.name))

  # Focus next field on input after choosing a task
  $('#entry_task_id').click ->
    $('#entry_description').focus()

  # Focus next empty field on load
  $('#entry-ui-datepicker').click ->
    if $('#entry_project_id option:selected').val() == ''
      $('#entry_project_id').focus()
    else
      $('#entry_description').focus()
