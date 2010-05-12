class EuroshopController < ApplicationController
    require 'open-uri'
    require 'rubygems'
    require 'nokogiri'
    require 'date'

  #caches_page :index,:stores
  #cache_sweeper :notebook_sweeper


  def index
    @title = "Úvodná stránka"
    @pocet_notebookov =   Notebook.count_by_sql "SELECT COUNT(*) FROM notebooks"
    @pocet_obchodov =   Store.count_by_sql "SELECT COUNT(*) FROM stores"
  end

  def stores
    @title = "Obchody"
    @obchody = Store.find(:all)
  end

  def detail
    @data = []
    @title = "Detail notebooku"
    costs = Cost.find_all_by_notebook_id(params[:code])
    maxdate = 0
    costs.each do |e|
      @data[e.store_id]=[[e.date.to_time.to_i*1000,e.cost_wdph]] if @data[e.store_id]==nil
      @data[e.store_id]<<[e.date.to_time.to_i*1000,e.cost_wdph] unless @data[e.store_id]==nil
      maxdate = e.date.to_time.to_i*1000 if maxdate < e.date.to_time.to_i*1000
    end

    @data.each do |e|
      e<<[maxdate,e.last[1]] if ((e!=nil)&&(e.last[0]!=maxdate))   #toto je tu preto zby tie grafy nekoncili v strede ak nieje zmena hodnoty
    end
    
  end

  def compare

    @title = "Porovnanie"

    counter = 0

    @notebooky1 = Notebook.find :all, :conditions => {'memory_capacity' => params[:RAM1]}
    @notebooky2 = Notebook.find :all, :conditions => {'memory_capacity' => params[:RAM2]}


    @data1 = []
    unless ((@notebooky1==nil)||(params.length != 41)) then
      @notebooky1.each do |e|
        cena = NotebookStore.all(
          :select => "
            AVG(costs.cost_wdph) as avg",
          :joins => :cost,
          :conditions => {'notebook_stores.notebook_id' => e.id} )


        cenaN = cena.first.avg.to_s.to_i
        poradieN = (counter.to_s.to_i+rand(99)).modulo(100).to_s
        counter += 1
        popis = e.popis

        @data1 << [poradieN, cenaN, popis, e.id]
      end
    @data1 = @data1.sort{|a,b| a[2]<=>b[2]}

    end

    @data2 = []
    unless ((@notebooky2==nil)||(params.length != 41)) then
       @notebooky2.each do |e|
        cena = NotebookStore.all(
          :select => "
            AVG(costs.cost_wdph) as avg",
          :joins => :cost,
          :conditions => {'notebook_stores.notebook_id' => e.id} )


        cenaN = cena.first.avg.to_s.to_i
        poradieN = (counter.to_s.to_i+rand(99)).modulo(100).to_s
        counter += 1

        counter += 1
        popis = e.popis

        @data2 << [poradieN, cenaN, popis, e.id]
      end
    @data2 = @data2.sort{|a,b| a[2]<=>b[2]}

    end

  end
                                                    
  

end
