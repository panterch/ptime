module ControllingHelper

  def meter_graph
    size='400x220'
    p = '%.2f' % @project.percent_time_used
    url = 'http://chart.apis.google.com/chart?chs='+size+
    '&chd=t:'+p+ # data value to display
    '&chds=0,200'+ # scale to max 200
    '&chf=bg,s,FFF8FF'+ # background color
    '&chco=00FF00,FFFF00,FF0000'+ # from white green to red
    '&cht=gom'+ # google meter
    '&chl='+p+' %'# the legend
    image_tag(url, { :size => size, :alt => 'Meter Graph' })
  end

  def billed_graph
    size='400x175'
    url ='http://chart.apis.google.com/chart?cht=p3' +
    '&chf=bg,s,FFF8FF'+ # background color
    '&chd=t:'+(@project.total_time_used-@project.total_time_billed).to_s+','+
    @project.total_time_billed.to_s+
    '&chs='+size+
    '&chl=Not billed|Billed'
    image_tag(url, { :size => size, :alt => 'Billed Graph' })
  end

  def task_graph
    used = @project.time_used_per_task
    url = 'http://chart.apis.google.com/chart?cht=bhg&chco=FF9900,FFCC33'
    url += '&chf=bg,s,FFF8FF' # background color
    url += '&chdl=estimated|spent' # legend
    chd = '&chd=t:' # chart date
    chm = '&chm=' # chart legend
    max = 0  # maximal numerical value presend (for scaling)
    visible = [] # array holding all task that should appear on graph
    cnt = 0 # counter used during traverse
    # gather estimate data
    @project.tasks.each do |t|
      next if !t.estimation
      chd += '%.2f,' % t.estimation
      chm += 't'+t.name+',000000,0,'+cnt.to_s+',13|'
      max = t.estimation if max < t.estimation
      cnt += 1
      visible << t
    end
    chd[-1] = '|' # replace the last coma w/ the data separator
    cnt = 0
    # gather used data
    visible.each do |task|
      dur = used[task.id] || 0.0
      chd += '%.2f,' % dur
      # chm += 'tSpent by now on '+task.name+',000000,1,'+cnt.to_s+',10|'
      max = dur if max < dur
      cnt += 1
    end
    # calculate chart size: each bar need ~30px plus 10px border
    size = '400x'+(60*(visible.length+1)+10).to_s
    url += '&chs='+size
    # add time used not on tasks
    chd += '%.2f' % (used[nil] || 0.0)
    chm += 'tnot on tasks,000000,1,'+cnt.to_s+',13'
    url += chd + chm + '&chds=0,'+('%.2f' % max)
    image_tag(url, { :size => size, :alt => 'Task Graph' })
  end

end
