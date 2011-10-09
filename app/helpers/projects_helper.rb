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

  def project_description(project)
    truncate(project.shortname + ' - ' + project.description, :length => 40)
  end

  def expected_profitability
    @project.expected_profitability.round(2).to_s + "%"
  end

end
