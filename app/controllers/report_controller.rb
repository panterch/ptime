class ReportController < ApplicationController

  permit 'admin'
  layout 'time'

  def index
  end

  def preview
    conditions = paramsToConditions(params)
    @count = Entry.count( :all, :conditions => conditions )
    render :partial => 'preview', :layout => false
  end

  def download
    # send the gathered date
    # it seems rails get's problems if we set stream to true, altough
    # it's the default
    conditions = paramsToConditions(params)
    csv = ''
    Entry.find(:all, :conditions => conditions, :order => :date).each do |entry|
      csv << entry.to_csv
      csv << "\n"
    end
    send_data(csv,
             { :type=>'text/csv', :disposition=>'attachement', 
               :stream => false})

  end

  def paramsToConditions(params)
    condition = 'date >= ? AND date <= ?'
    args = Array.new
    args << paramsToDate(params[:start])
    args << paramsToDate(params[:end])
    if params[:post][:project_id] &&  !params[:post][:project_id].empty?
      condition << ' AND project_id = ?'
      args << params[:post][:project_id].to_i
    end
    if params[:post][:user_id] &&  !params[:post][:user_id].empty?
      condition << ' AND user_id = ?'
      args << params[:post][:user_id].to_i
    end
    return args.insert(0,condition)
  end

  def paramsToDate(params)
    Date.civil(Integer(params[:year]), Integer(params[:month]),
               Integer(params[:day]))
  end

end
