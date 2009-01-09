module BillsHelper
  # returns rowhighlight when given id matches params[:id], else returns row
  def rowstyle(id)
    clazz = 'row'
    if id.to_s == params[:id]
      clazz << 'highlight'
    end
    return clazz;
  end
end
