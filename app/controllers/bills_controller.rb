class BillsController < ApplicationController

  permit 'admin'
  layout 'time'

  # GET /bills
  # GET /bills.xml
  def index
    @bills = Bill.find(:all)
    @bill  ||= Bill.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bills }
    end
  end

  # GET /bills/1
  # GET /bills/1.xml
  def show
    @bill = Bill.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bill }
      format.csv  { csv }
    end
  end

  def csv
    @bill = Bill.find(params[:id])
    send_data(@bill.to_csv,
             { :type=>'text/csv', :disposition=>'attachement', 
               :stream => false})
  end

  # GET /bills/new
  # GET /bills/new.xml
  #def new
    #@bill = Bill.new

    #respond_to do |format|
      #format.html # new.html.erb
      #format.xml  { render :xml => @bill }
    #end
  #end

  # GET /bills/1/edit
  def edit
    @bill = Bill.find(params[:id])
    gather_candidates
  end

  # POST /bills
  # POST /bills.xml
  def create
    @bill = Bill.new(params[:bill])
    @bill.user_id = session[:user_id]
    @bill.save!
    redirect_to(edit_bill_path(@bill))
  end

  # PUT /bills/1
  # PUT /bills/1.xml
  def update
    # rebuild & update the form
    @bill = Bill.find(params[:id] || params[:bill][:id])
    @bill.update_attributes(params[:bill])
    # if it's an xhr we only update the partial holding the candidate entries
    if request.xhr?
      gather_candidates
      render :partial => 'entries', :object => @can_entries
    # when called via submit button the entry get's written to the database
    else
      @bill.entries = []
      if params[:selected]
        params[:selected].each do |e_id|
          @bill.entries << Entry.find(e_id)
        end
      end
      @bill.save!
      flash[:notice] ="Bill successfully saved."
      redirect_to({ :action => 'index'})
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.xml
  #def destroy
    #@bill = Bill.find(params[:id])
    #@bill.destroy

    #respond_to do |format|
      #format.html { redirect_to(bills_url) }
      #format.xml  { head :ok }
    #end
  #end

  # gathers candidate records available for current bill
  # method may be called on edit request and vie xhr when view is updated
  def gather_candidates
    @can_entries = Entry.find(:all,
      :conditions => ["project_id = ? and bill_id is NULL " +
      "and date >= ? and date <= ?", 
      @bill.project_id, 
      @bill.start.strftime('%Y-%m-1'), @bill.end.strftime('%Y-%m-31')])
  end

end
