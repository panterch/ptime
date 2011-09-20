remove_fields = (link) ->
  $(link).prev('input[type=hidden]').val('1')
  $(link).closest('.inputs').hide()

add_fields = (link, association, content) ->  
  new_id = new Date().getTime()  
  regexp = new RegExp('new_' + association, 'g')
  $(link).before(content.replace(regexp, new_id))

# jQuery Datepicker helper
$(document).ready ->
  $('input.ui-datepicker').datepicker()

# Reload entry form for chosen date
$(document).ready ->
  $('#entry-ui-datepicker').datepicker({
    onSelect: (dateText, inst) ->
      date = new Date(dateText);
      day = $.datepicker.formatDate("dd-mm-yy", date);
      window.location.href = '/entries/new/' + '?day=' + day;
  })

# Change date on entry datepicker. It will be set by new and edit actions
$(document).ready ->
  day = $('input#entry_day_input').val()
  $('#entry-ui-datepicker').datepicker('setDate', new Date(day))

# jQuery Timepicker helper
$(document).ready ->
  $('input.ui-timepicker').timepicker ->
    showPeriod: true

/* Calculate entry duration from start:end */
$(document).ready ->
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
$(document).ready ->
  $('#entry_duration_hours').change ->
    $('#entry_start').val('')
    $('#entry_end').val('')

# Fetch associated tasks for a given project in entry form
$(document).ready ->
  $('#entry_project_id').change ->
    $('#entry_task_id').find('option').remove()
    project_id = $('select#entry_project_id :selected').val()
    tasks_from_projects = $.parseJSON($('#tasks_collection_storage').val())
    for i, item of tasks_from_projects[project_id]
      $('#entry_task_id').append(
        $('<option></option>').val(item.id).html(item.name)) 
