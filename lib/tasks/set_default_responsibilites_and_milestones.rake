DEFAULT_PROJECT_LEADER = 'some_existing_username'

namespace :db do

  desc 'Set default milestones'
  task :set_default_milestones => :environment do
    active_projects = Project.active
    active_projects.each do |project|
      if project.milestones.empty?
        project.set_default_milestones

        if project.save
          puts "Setting default milestones for project... #{project.shortname}"
        else
          puts "Failed to set default milestones for project... #{project.shortname} Reason: #{project.errors}"
        end
      end
    end
  end

  desc 'Set default responsibilities'
  task :set_default_responsibilities => :environment do
    active_projects = Project.active
    active_projects.each do |project|
      if project.responsibilities.empty?
        project.set_default_responsibilities

        # Set default project leader
        user = User.where(:username => DEFAULT_PROJECT_LEADER).first
        responsibility_type = ResponsibilityType.where(:name => 'project leader').first

        project.responsibilities.each do |responsibility|
          if responsibility.responsibility_type_id == responsibility_type.id
            responsibility.user = user
          end
        end

        if project.save
          puts "Setting default responsibilities for project... #{project.shortname}"
        else
          puts "Failed to set default responsibilities for project... #{project.shortname} Reason: #{project.errors}"
        end
      end
    end
  end

end
