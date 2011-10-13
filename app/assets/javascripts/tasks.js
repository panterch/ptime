// TODO: rewrite this in coffeescript and move it to global.coffee
$(function() {
  var taskSelect = '#entry_task_id';
  if ($(taskSelect).length > 0) {
    console.log('Task selector present!');
    $(taskSelect).live('change', function() {
      var taskID = $(taskSelect + ' option:selected').val();
      console.log('Selected task ID: ' + taskID);

      $.ajax({ url: '/tasks/' + taskID,
               dataType: 'script' })
    });
  }
});
