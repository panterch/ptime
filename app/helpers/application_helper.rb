# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  ICONS = {
    :edit => ['/images/tango/16x16/apps/accessories-text-editor.png', '16x16'],
    :destroy => ['/images/tango/16x16/actions/edit-delete.png', '16x16']
  }

  def activeWhenController(name)
    style_class = ''
    if name == @controller.controller_name
      style_class = 'active'
    end
    style_class
  end

  def icon(type)
    image_tag ICONS[type][0],
              :size => ICONS[type][1], :alt => type.to_s.titleize,
              :title => type.to_s.titleize
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end
end
