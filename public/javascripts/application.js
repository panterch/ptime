function highlight(id) {
  document.observe("dom:loaded", function() {
      $(id).highlight();
  });
}
