function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest('.inputs').hide();
}

function add_fields(link, association, content) {  
    var new_id = new Date().getTime();  
    var regexp = new RegExp("new_" + association, "g");  
    $(link).before(content.replace(regexp, new_id));  
}  

/* jQuery Datepicker helper */
$(document).ready(function(){
    $('input.ui-datepicker').datepicker();
});

/* Populate hidden day field when picking a date in entry form */
$(document).ready(function(){
    $('#entry-ui-datepicker').datepicker({
           onSelect: function(dateText, inst) { 
                       $("input#entry_day_input").val(dateText);
                     }})
});

/* jQuery Timepicker helper */
$(document).ready(function(){
    $('input.ui-timepicker').timepicker({
      showPeriod: true});
});

/* Fetch associated tasks for a given project in entry form */
$(function($) {
    $('#entry_project_id').change(function() {
      var tasks = $('select#entry_project_id :selected').val();
      if(tasks == '') tasks = '0';
      $.get('/entries/update_tasks_select/' + tasks, function(data) {
        $("#tasks_dropdown").html(data);
        })
      return false;
    });
})

/* Calculate entry duration from start:end */
$(function($) {
  $('#entry_end').change(function() {
    var start_time = $('#entry_start').val()
    var end_time = $('#entry_end').val()
    if (start_time) {
      var start_date = new Date("1/1/70 " + start_time);
    }
    var end_date = new Date("1/1/70 " + end_time);
    if (end_date > start_date) {
      var diff = new Date();
      diff.setTime(end_date - start_date);
      $("#entry_duration_hours").val(diff.getHours()-1 +":"+ diff.getMinutes());
    }
    else {
      $("#entry_duration_hours").val("");
    }
  });
})

/* Discard entry start:end if duration is edited manually */
$(function($) {
  $('#entry_duration_hours').change(function() {
    $('#entry_start').val('');
    $('#entry_end').val('');
  });
})
