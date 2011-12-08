module ProjectsHelper
  def bool_to_img(flag)
    if flag
      image_tag "check.png"
    else
      image_tag "no.png"
    end
  end

  def get_project_state(project)
    if project.project_state
      project.project_state.try(:name)
    else
      image_tag "none.png"
    end
  end

  # TODO: This should be probably moved into the model
  def project_description(project)
    "#{project.shortname} - #{project.description}"
  end

  def expected_profitability(project)
    project.expected_profitability.round(2).to_s + "%"
  end

  # Rails helper number_to_percentage doesn't have fine grained support for number formating
  # so we are implementing our own
  def format_percentage(number)
    percentage = "%05.2f" % (number * 100)
    "#{percentage} %"
  end

end
