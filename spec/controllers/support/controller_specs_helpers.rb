# Creates attributes for a project with required responsibilities and
# project state
def generate_valid_project_attributes
  user = Factory(:user)
  Factory.attributes_for(:project).merge(
    {:responsibilities_attributes =>
      [Factory.attributes_for(:responsibility, :user_id => user.id,
         :responsibility_type_id =>
           Factory(:scrum_master_responsibility_type).id),
       Factory.attributes_for(:responsibility, :user_id => user.id,
         :responsibility_type_id =>
           Factory(:product_owner_responsibility_type).id)],
     :project_state_attributes => { :name => "Test state" }})
end
