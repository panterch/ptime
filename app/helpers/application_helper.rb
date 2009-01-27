# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  ICONS = {
    :edit => ['/images/tango/16x16/apps/accessories-text-editor.png', '16x16'],
    :destroy => ['/images/tango/16x16/actions/edit-delete.png', '16x16'],
    :share => ['/images/tango/16x16/actions/contact-new.png', '16x16']
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

  def title(text)
    content_for(:title) { text }
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def projects_collection
    @current_user.projects.collect { |p| [ p.description, p.id ] }
  end

  def tasks_collection
    return [] unless @entry.project
    @entry.project.tasks.collect { |t| [ t.name, t.id ] }
  end

end
