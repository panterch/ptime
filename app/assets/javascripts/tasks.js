// TODO: rewrite this in coffeescript and move it to global.coffee
$(function() {
  var taskSelect = '#entry_task_id';
  if ($(taskSelect).length > 0) {
    $(taskSelect).live('change', function() {
      var taskID = $(taskSelect + ' option:selected').val();

      $.ajax({ url: '/tasks/' + taskID,
               dataType: 'script' })
    });
  }
});
