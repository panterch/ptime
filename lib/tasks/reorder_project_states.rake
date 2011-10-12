namespace :utils do
  desc 'Reorders and creates missing project states'
  task :reorder_project_states => :environment do

    project_states = ["lead", "offered", "won", "lost", "running", "closing", "closed", "permanent"]
    project_states.each_with_index do |state_name, index|
      project_state = ProjectState.where(:name => state_name).first

      # Recreate the state if missing
      if project_state
        puts "Setting project state '#{state_name}' to position #{index + 1} "
        project_state.position = index + 1
        project_state.save
      else
        puts "Creating the missing state '#{state_name}' and setting to position #{index + 1}"
        ProjectState.create(:name => state_name, :position => index + 1)
      end
    end

    puts "Done."
  end
end
