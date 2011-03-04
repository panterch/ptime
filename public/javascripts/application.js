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

/* jQuery Timepicker helper */
$(document).ready(function(){
    $('input.ui-timepicker').timepicker({
      showPeriod: true});
});

/* Prepopulate new entries with today's date */
$(document).ready(function(){
  var field = $("#entry_day")
  if (field && !field.val()) {
    var today = new Date();
    var prettyDate =(today.getMonth()+1) + '/' + today.getDate() + '/' +
            today.getFullYear();
    field.val(prettyDate);
  }
});

