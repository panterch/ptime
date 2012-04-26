module ReportsHelper

  def drill_down_row(entries, by_group, config = {})
    render :partial => "reports/row_#{by_group}", :locals => { :entries => entries, :show_drilldown => config[:show_drilldown] }
  end

end
