# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def activeWhenController(name)
    style_class = ''
    if name == @controller.controller_name
      style_class = 'active'
    end
    style_class
  end
end
