module RailsLoveRHelper

  def table_render_csv(table_name)
    file_name = "#{table_name}.csv"
    "data <- dbReadTable(con, '#{table_name}') \n" +
    "write.csv(data, file='#{file_name }')"
  end

end

