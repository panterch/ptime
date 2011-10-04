module ModelMacros

  def should_not_have_abilities_for(user, object)
    specify { user.should_not have_ability_to(:create, object) }
    specify { user.should_not have_ability_to(:index, object) }
    specify { user.should_not have_ability_to(:view, object) }
    specify { user.should_not have_ability_to(:edit, object) }
    specify { user.should_not have_ability_to(:show, object) }
  end

  def should_have_abilities_for(user, object)
    specify { user.should have_ability_to(:create, object) }
    specify { user.should have_ability_to(:index, object) }
    specify { user.should have_ability_to(:view, object) }
    specify { user.should have_ability_to(:edit, object) }
    specify { user.should have_ability_to(:show, object) }
  end
end
