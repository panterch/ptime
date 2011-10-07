# Creates attributes for a project with required responsibilities and
# project state
def generate_valid_project_attributes
  user = Factory(:user)
  required_responsibility_type = Factory.create(:required_responsibility_type)
  Factory.attributes_for(:project).merge(
    {:responsibilities_attributes =>
      [Factory.attributes_for(:responsibility, :user_id => user.id,
        :responsibility_type_id => required_responsibility_type.id)],
     :project_state_attributes => { :name => "Test state" }})
end
