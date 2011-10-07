# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :entry, 'Entry', new_entry_path, :if => Proc.new {can? :create, Entry}

    primary.item :projects, 'Projects', '#' , 
      :if => Proc.new { current_user && current_user.admin }  do |project|
      project.item :show_projects, 'All projects',
        projects_path, :if => Proc.new {can? :show, Project}
      project.item :new_project, 'New project',
        new_project_path, :if => Proc.new {can? :create, Project}
    end

    primary.item :report, 'Report', report_path,
      :if => Proc.new {can? :show, Report}

    primary.item :admin, 'Admin', '#', 
      :if => Proc.new { current_user && current_user.admin } do |admin|
      admin.item :users, 'Users', users_path, 
        :if => Proc.new {can? :show, User}
      admin.item :project_states, 'Project States',
        project_states_path, :if => Proc.new {can? :show, ProjectState}
      admin.item :milestone_types, 'Milestone Types',
        milestone_types_path, :if => Proc.new {can? :show, MilestoneType}
      admin.item :responsibility_types, 'Responsibility Types',
        responsibility_types_path, :if => Proc.new {can? :show, ResponsibilityType}
    end

    primary.dom_class = 'sf-menu'
  end
end
