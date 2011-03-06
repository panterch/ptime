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
                       console.log(dateText);
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
