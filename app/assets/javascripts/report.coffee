$ ->

  # Add chosen
  $('.chzn-select').chosen()

  # Workaround for the issue with the missing entries for drop down boxes
  $('#entry_search .chzn-results').css('width', '90%')
