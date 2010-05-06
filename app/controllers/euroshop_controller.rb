class EuroshopController < ApplicationController
    require 'open-uri'
    require 'rubygems'
    require 'nokogiri'
    require 'date'

  caches_page :index,:stores
  cache_sweeper :notebook_sweeper


  def index
    @title = "Úvodná stránka"
    @pocet_notebookov =   Notebook.count_by_sql "SELECT COUNT(*) FROM notebooks"
    @pocet_obchodov =   Store.count_by_sql "SELECT COUNT(*) FROM stores"
    @sidebar = ""

  end

  def stores
    @title = "Obchody"
    @obchody = Store.find(:all)
  end

  def compare
    @title = "Porovnanie"
    #@graph = open_flash_chart_object(600,300,url_for(params.merge({:controller => :euroshop, :action => :graph_code})))#spusta druhy controller s parametrami ktore dostal tento z formularu
    counter = 0

    notebooky1 = Notebook.find :all, :conditions => {'memory_capacity' => params[:RAM1]}
    notebooky2 = Notebook.find :all, :conditions => {'memory_capacity' => params[:RAM2]}
    ceny = ""
    poradie = ""


    unless ((notebooky1==nil)||(params[:RAM1]==nil)) then

      notebooky1.each do |e|
        cena = NotebookStore.all(
          :select => "
            AVG(costs.cost_wdph) as avg",
          :joins => :cost,
          :conditions => {'notebook_stores.notebook_id' => e.id} )


        ceny = cena.first.avg.to_s.to_i.to_s if counter == 0
        ceny += ","+cena.first.avg.to_s.to_i.to_s unless counter == 0
        poradie = counter.to_s if counter == 0
        poradie += ","+(counter.to_s.to_i+rand(99)).modulo(100).to_s unless counter == 0
        counter += 1
      end
    end

    unless ((notebooky2==nil)||(params[:RAM2]==nil)) then

      notebooky2.each do |e|
        cena = NotebookStore.all(
          :select => "
            AVG(costs.cost_wdph) as avg",
          :joins => :cost,
          :conditions => {'notebook_stores.notebook_id' => e.id} )


        ceny = cena.first.avg.to_s.to_i.to_s if counter == 0
        ceny += ","+cena.first.avg.to_s.to_i.to_s unless counter == 0
        poradie = counter.to_s if counter == 0
        poradie += ","+(counter.to_s.to_i+rand(99)).modulo(100).to_s unless counter == 0
        counter += 1
      end
    end


    @google = "<img src='http://chart.apis.google.com/chart?
chs=600x500
&chd=t:#{ceny}|#{poradie}|10
&chds=1,2500,1,100
&cht=s
&chxt=x
&chxr=0,0,2500,500
&chm=o,99ff00,1,,100.0|o,669900,1,0:#{notebooky1.length}:1,10.0
' width = '600' height = '500' alt = 'graf'>"
  end

  

  def graph_code


    chart = OpenFlashChart.new

    title = Title.new("Porovnanie notebookov")

    notebooky1 = Notebook.find :all, :conditions => {'memory_capacity' => params[:RAM1]}
    notebooky2 = Notebook.find :all, :conditions => {'memory_capacity' => params[:RAM2]}
    #title = Title.new(notebooky1.length.to_s)

    chart.set_title(title)


    scatter.set_tooltip(t)

    scatter.values = [
      ScatterValue.new(50,30),
      ScatterValue.new(305,400),
      ScatterValue.new(61,500),  # x, y, dot size
      ScatterValue.new(600,550),
      ScatterValue.new(459,300),
      ScatterValue.new(180,789)
    ]

    chart.add_element(scatter)

    x = XAxis.new
    x.set_range(0, 650,100)  #min, max, steps
    # alternatively, you can use x.set_range(0,65000) and x.set_step(10000)
    x.colour = '#00FF00'

    # have to set the x axis labels because of scatter bug here - http://sourceforge.net/forum/message.php?msg_id=4812326
    x.set_grid_colour('#00F0FF')
    chart.set_x_axis(x)

    y = YAxis.new
    y.set_range(0,800,200)
    y.colour = '#FF0000'
    y.set_grid_colour('#FF00FF')
    chart.set_y_axis(y)
    chart.set_tooltip(t)
    

    render :text => chart.to_s



    if false then
    data1 = []
    data2 = []
    data3 = []

    10.times do |x|
      data1 << rand(5) + 1
      data2 << rand(6) + 7
      data3 << rand(5) + 14
    end

    line_dot = Line.new
    line_dot.text = "Line Dot"
    line_dot.width = 4
    line_dot.colour = '#DFC329'
    line_dot.dot_size = 5
    line_dot.values = notebooky1

    line_hollow = Line.new
    line_hollow.text = "Line Hollow"
    line_hollow.width = 1
    line_hollow.colour = '#6363AC'
    line_hollow.dot_size = 5
    line_hollow.values = notebooky2

    line = Line.new
    line.text = "Line"
    line.width = 3
    line.colour = '#5E4725'
    line.dot_size = 5
    line.values = data3

    y = YAxis.new
    y.set_range(0,20,5)

    x_legend = XLegend.new("MY X Legend")
    x_legend.set_style('{font-size: 20px; color: #778877}')

    y_legend = YLegend.new("MY Y Legend")
    y_legend.set_style('{font-size: 20px; color: #770077}')

    chart =OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y

    chart.add_element(line_dot)
    chart.add_element(line_hollow)
    chart.add_element(line)

    render :text => chart.to_s
    end
    

  end


end
