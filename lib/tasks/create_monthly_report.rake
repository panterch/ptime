# Creates monthly reports for all projects and publishes them via paperclip
# as CSV files.

namespace :report do

  def now
    @now = Time.now
  end

  # builds a MetaSearch search param hash with date boundaries
  def build_interval_search(from, to)
    {'day_gte(1i)' => from.year,
     'day_gte(2i)' => from.month,
     'day_gte(3i)' => from.day,
     'day_lte(1i)' => to.year,
     'day_lte(2i)' => to.month,
     'day_lte(3i)' => to.day}
  end

  # for debugging purposes only
  def write_csv_to_file(csv, from, unit_strftime)
    reports_dir = ENV['DIR'] || File.join(Rails.root, 'public')
    reports_path = File.join(reports_dir,
                             "Report_#{from.strftime(unit_strftime)}.csv")
    outfile = File.new(reports_path, "w")
    outfile.write(csv)
    outfile.close
  end

  desc 'Create a time entry report of the last full month'
  task :last_month => :environment do
    last_month_start = DateTime.new(now.year,now.month,1).prev_month
    last_month_end = DateTime.new(now.year,now.month,1)
    csv = Entry.csv(
      build_interval_search(last_month_start, last_month_end))
    write_csv_to_file(csv, last_month_start, '%B_%Y')
  end

  desc 'Create a time entry report of the current month'
  task :current_month => :environment do
    current_month_start = DateTime.new(now.year,now.month,1)
    current_month_end = DateTime.now
    csv = Entry.csv(
      build_interval_search(current_month_start, current_month_end))
    write_csv_to_file(csv, current_month_start, '%B_%Y')
  end

  desc 'Create a time entry report of the last year'
  task :last_year => :environment do
    last_year_start = DateTime.new(now.year-1)
    last_year_end = DateTime.new(now.year)
    csv = Entry.csv(
      build_interval_search(last_year_start, last_year_end))
    write_csv_to_file(csv, last_year_start, '%Y')
  end

  desc 'Create a time entry report of the current year'
  task :current_year => :environment do
    current_year_start = DateTime.new(now.year)
    current_year_end = DateTime.now
    csv = Entry.csv(
      build_interval_search(current_year_start, current_year_end))
    write_csv_to_file(csv, current_year_start, '%Y')
  end

  desc 'Create all defined reports'
  task :all => [:last_month, :current_month, :last_year, :current_year]
end
