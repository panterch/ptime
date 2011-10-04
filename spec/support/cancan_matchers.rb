module CancanMatchers

  # Custom Matcher for easier CanCan Specs
  # FIXME the string methods may be refactored
  # learn more at: http://solnic.eu/2011/01/14/custom-rspec-2-matchers.html
  RSpec::Matchers.define :have_ability_to do |action, object|
    match do |user|
      #puts "Object Class:", object.class
      ability = Ability.new(user)
      #puts ability.inspect
      #puts "Action", action
      #puts "Object", object
      ability.can?(action, object)
    end

    failure_message_for_should do |user|
      if object.is_a? Class
        "expected to have the ability to #{action} any #{object.to_s.pluralize}"
      else
        "expected to have the ability to #{action} the instance: #{object}"
      end
    end

    failure_message_for_should_not do |user|
      if object.is_a? Class
        "expected NOT to have the ability to #{action} any #{object.to_s.pluralize}"
      else
        "expected NOT to have the ability to #{action} the instance: #{object}"
      end
    end

    description do
      if object.is_a? Class
        #"have the ability to #{action} any #{object.to_s.pluralize}"
        "be able to #{action} any #{object.to_s.pluralize}"
      else
        #"have the ability to #{action} the instance: #{object}"
        "be able to #{action} the instance: #{object}"
      end
    end

  end

end