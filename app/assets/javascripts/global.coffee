root = exports ? this

# Adds fields dynamically (such as tasks in a project)
root.addFields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp('new_' + association, 'g')
  $(link).after(content.replace(regexp, new_id))
