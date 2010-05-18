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
    unless params[:code]==nil then
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
      begin
      @notebook = Notebook.find(params[:code])
      rescue Exception
      end
      #najdenie vstkych portov k notebooku            
      @ports = Port.find_by_sql "SELECT p.name FROM
                                 (
                                    SELECT port_id FROM `notebook_ports`
                                    WHERE notebook_id =#{params[:code]}
                                 ) s, ports p
                                 WHERE p.id = s.port_id "
    end
  end

  def compare

    @title = "Porovnanie"

    counter = 0

    podmienky1 = []
    podmienky2 = []
    
    if params.length >= 40 then   #vytvaranie parametrov do dopytu na databazu
      
      unless params[:RAM1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'memory_capacity = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND memory_capacity = ?'
        end
        podmienky1 << params[:RAM1]
      end

      unless params[:name1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'name like ?'
        else
          podmienky1[0] = podmienky1[0]+' AND name like ?'
        end
        podmienky1 << '%'+params[:name1]+'%'
      end

      unless params[:processor_type1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'processor_type like ?'
        else
          podmienky1[0] = podmienky1[0]+' AND processor_type like ?'
        end
        podmienky1 << '%'+params[:processor_type1]+'%'
      end

      unless params[:processor_freq1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'round(processor_freq,2) = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND round(processor_freq,2) = ?'
        end
        podmienky1 << params[:processor_freq1]
      end

      unless params[:display_diag1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'round(display_diag,2) = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND round(display_diag,2) = ?'
        end
        podmienky1 << params[:display_diag1].to_f
      end

      unless params[:display_resolution_hor1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'display_resolution_hor = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND display_resolution_hor = ?'
        end
        podmienky1 << params[:display_resolution_hor1]
      end

      unless params[:display_resolution_ver1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'display_resolution_ver = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND display_resolution_ver = ?'
        end
        podmienky1 << params[:display_resolution_ver1]
      end

      unless params[:disc_rotations1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'disc_rotations = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND disc_rotations = ?'
        end
        podmienky1 << params[:disc_rotations1]
      end

      unless params[:network1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'network = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND network = ?'
        end
        podmienky1 << params[:network1]
      end

      unless params[:weight1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'weight = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND weight = ?'
        end
        podmienky1 << params[:weight1]
      end

      unless params[:drive1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'drive like ?'
        else
          podmienky1[0] = podmienky1[0]+' AND drive like ?'
        end
        podmienky1 << '%'+params[:drive1]+'%'
      end

      unless params[:grafic_card1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'grafic_card like ?'
        else
          podmienky1[0] = podmienky1[0]+' AND grafic_card like ?'
        end
        podmienky1 << '%'+params[:grafic_card1]+'%'
      end

      unless params[:batery_life_time1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'batery_life_time = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND batery_life_time = ?'
        end
        podmienky1 << params[:batery_life_time1]
      end

      unless params[:OS1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'OS like ?'
        else
          podmienky1[0] = podmienky1[0]+' AND OS like ?'
        end
        podmienky1 << '%'+params[:OS1]+'%'
      end

      unless params[:monitor_out1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'monitor_out = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND monitor_out = ?'
        end
        podmienky1 << params[:batery_life_time1]
      end

      unless params[:USB_number1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'USB_number = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND USB_number = ?'
        end
        podmienky1 << params[:USB_number1]
      end

      unless params[:min_disc_capacity1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'disc_capacity >= ?'
        else
          podmienky1[0] = podmienky1[0]+' AND disc_capacity >= ?'
        end
        podmienky1 << params[:min_disc_capacity1]
      end

      unless params[:max_disc_capacity1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'disc_capacity <= ?'
        else
          podmienky1[0] = podmienky1[0]+' AND disc_capacity <= ?'
        end
        podmienky1 << params[:max_disc_capacity1]
      end

      unless params[:wifi1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'wifi = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND wifi = ?'
        end
        if params[:wifi1]== 'true' then
          podmienky1 << '1'
        else
          podmienky1 << '0'
        end
      end

      unless params[:bluetooth1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'bluetooth = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND bluetooth = ?'
        end
        if params[:bluetooth1]== 'true' then
          podmienky1 << '1'
        else
          podmienky1 << '0'
        end
      end

       unless params[:card_reader1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'card_reader = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND card_reader = ?'
        end
        if params[:card_reader1]== 'true' then
          podmienky1 << '1'
        else
          podmienky1 << '0'
        end
       end

       unless params[:webcam1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'webcam = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND webcam = ?'
        end
        if params[:webcam1]== 'true' then
          podmienky1 << '1'
        else
          podmienky1 << '0'
        end
       end

       unless params[:numeric_keyboard1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'numeric_keyboard = ?'
        else
          podmienky1[0] = podmienky1[0]+' AND numeric_keyboard = ?'
        end
        if params[:numeric_keyboard1]== 'true' then
          podmienky1 << '1'
        else
          podmienky1 << '0'
        end
      end

     #----------------------------------------
      
      unless params[:RAM2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'memory_capacity = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND memory_capacity = ?'
        end
        podmienky2 << params[:RAM2]
      end

      unless params[:name2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'name like ?'
        else
          podmienky2[0] = podmienky2[0]+' AND name like ?'
        end
        podmienky2 << '%'+params[:name2]+'%'
      end

      unless params[:processor_type2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'processor_type like ?'
        else
          podmienky2[0] = podmienky2[0]+' AND processor_type like ?'
        end
        podmienky2 << '%'+params[:processor_type2]+'%'
      end

      unless params[:processor_freq2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'round(processor_freq,2) = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND round(processor_freq,2) = ?'
        end
        podmienky2 << params[:processor_freq2]
      end

      unless params[:display_diag2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'round(display_diag,2) = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND round(display_diag,2) = ?'
        end
        podmienky2 << params[:display_diag2].to_f
      end

      unless params[:display_resolution_hor2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'display_resolution_hor = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND display_resolution_hor = ?'
        end
        podmienky2 << params[:display_resolution_hor2]
      end

      unless params[:display_resolution_ver2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'display_resolution_ver = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND display_resolution_ver = ?'
        end
        podmienky2 << params[:display_resolution_ver2]
      end

      unless params[:disc_rotations2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'disc_rotations = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND disc_rotations = ?'
        end
        podmienky2 << params[:disc_rotations2]
      end

      unless params[:network2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'network = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND network = ?'
        end
        podmienky2 << params[:network2]
      end

      unless params[:weight2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'weight = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND weight = ?'
        end
        podmienky2 << params[:weight2]
      end

      unless params[:drive2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'drive like ?'
        else
          podmienky2[0] = podmienky2[0]+' AND drive like ?'
        end
        podmienky2 << '%'+params[:drive2]+'%'
      end

      unless params[:grafic_card2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'grafic_card like ?'
        else
          podmienky2[0] = podmienky2[0]+' AND grafic_card like ?'
        end
        podmienky2 << '%'+params[:grafic_card2]+'%'
      end

      unless params[:batery_life_time2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'batery_life_time = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND batery_life_time = ?'
        end
        podmienky2 << params[:batery_life_time2]
      end

      unless params[:OS2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'OS like ?'
        else
          podmienky2[0] = podmienky2[0]+' AND OS like ?'
        end
        podmienky2 << '%'+params[:OS2]+'%'
      end

      unless params[:monitor_out2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'monitor_out = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND monitor_out = ?'
        end
        podmienky2 << params[:batery_life_time2]
      end

      unless params[:USB_number2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'USB_number = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND USB_number = ?'
        end
        podmienky2 << params[:USB_number2]
      end

      unless params[:USB_number2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'USB_number = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND USB_number = ?'
        end
        podmienky2 << params[:USB_number2]
      end

      unless params[:min_disc_capacity2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'disc_capacity >= ?'
        else
          podmienky2[0] = podmienky2[0]+' AND disc_capacity >= ?'
        end
        podmienky2 << params[:min_disc_capacity2]
      end

      unless params[:max_disc_capacity2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'disc_capacity <= ?'
        else
          podmienky2[0] = podmienky2[0]+' AND disc_capacity <= ?'
        end
        podmienky2 << params[:max_disc_capacity2]
      end

      unless params[:wifi2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'wifi = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND wifi = ?'
        end
        if params[:wifi2]== 'true' then
          podmienky2 << '1'
        else
          podmienky2 << '0'
        end
      end

      unless params[:bluetooth2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'bluetooth = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND bluetooth = ?'
        end
        if params[:bluetooth2]== 'true' then
          podmienky2 << '1'
        else
          podmienky2 << '0'
        end
      end

       unless params[:card_reader2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'card_reader = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND card_reader = ?'
        end
        if params[:card_reader2]== 'true' then
          podmienky2 << '1'
        else
          podmienky2 << '0'
        end
       end

       unless params[:webcam2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'webcam = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND webcam = ?'
        end
        if params[:webcam2]== 'true' then
          podmienky2 << '1'
        else
          podmienky2 << '0'
        end
       end

       unless params[:numeric_keyboard2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'numeric_keyboard = ?'
        else
          podmienky2[0] = podmienky2[0]+' AND numeric_keyboard = ?'
        end
        if params[:numeric_keyboard2]== 'true' then
          podmienky2 << '1'
        else
          podmienky2 << '0'
        end
      end

    end

    @notebooky1 = Notebook.find :all, :conditions => podmienky1
    @notebooky2 = Notebook.find :all, :conditions => podmienky2


    @data1 = []
    unless ((@notebooky1==nil)||(params.length < 40)) then
      @notebooky1.each do |e|
        cena = NotebookStore.all(
          :select => "
            AVG(costs.cost_wdph) as avg",
          :joins => :cost,
          :conditions => {'notebook_stores.notebook_id' => e.id} )


        cenaN = cena.first.avg.to_s.to_i
        poradieN = (counter.to_s.to_i+rand(200)).modulo(100).to_s
        counter += 1
        popis = e.popis

        @data1 << [poradieN, cenaN, popis, e.id]
      end
    @data1 = @data1.sort{|a,b| a[2]<=>b[2]} #zoradenie podla popisu abecedne

    end

    @data2 = []
    unless ((@notebooky2==nil)||(params.length < 40)) then
       @notebooky2.each do |e|
        cena = NotebookStore.all(
          :select => "
            AVG(costs.cost_wdph) as avg",
          :joins => :cost,
          :conditions => {'notebook_stores.notebook_id' => e.id} )


        cenaN = cena.first.avg.to_s.to_i
        poradieN = (counter.to_s.to_i+rand(200)).modulo(100).to_s
        counter += 1

        counter += 1
        popis = e.popis

        @data2 << [poradieN, cenaN, popis, e.id]
      end
    @data2 = @data2.sort{|a,b| a[2]<=>b[2]} #zoradenie podla popisu abecedne

    end

  end
                                                    
  

end
