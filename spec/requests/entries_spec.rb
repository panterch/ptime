require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

describe "Entries CSV export" do
  describe "GET /entries.csv" do
    it "works! (now write some real specs)" do
      entry = Factory(:entry)
      log_in
      visit "/entries.csv"
      page.should have_content(entry.day.to_s)
    end
  end
end
