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

  def compare

    @title = "Porovnanie"

    counter = 0

    podmienky1 = []
    podmienky2 = []
    
    if params.length >= 41 then
      
      unless params[:RAM1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'memory_capacity = ?'
          podmienky1[1] = params[:RAM1]
        else
          podmienky1[0] = podmienky1[0]+' AND memory_capacity = ?'
          podmienky1 << params[:RAM1]
        end
      end

      unless params[:name1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'name like ?'
          podmienky1[1] = '%'+params[:name1]+'%'
        else
          podmienky1[0] = podmienky1[0]+' AND name like ?'
          podmienky1 << '%'+params[:name1]+'%'
        end
      end

      unless params[:processor_type1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'processor_type like ?'
          podmienky1[1] = '%'+params[:processor_type1]+'%'
        else
          podmienky1[0] = podmienky1[0]+' AND processor_type like ?'
          podmienky1 << '%'+params[:processor_type1]+'%'
        end
      end

      unless params[:processor_freq1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'processor_freq = ?'
          podmienky1[1] = params[:processor_freq1]
        else
          podmienky1[0] = podmienky1[0]+' AND processor_freq = ?'
          podmienky1 << params[:processor_freq1]
        end
      end

      unless params[:display_diag1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'display_diag = ?'
          podmienky1[1] = params[:display_diag1]
        else
          podmienky1[0] = podmienky1[0]+' AND display_diag = ?'
          podmienky1 << params[:display_diag1]
        end
      end

      unless params[:display_resolution_hor1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'display_resolution_hor = ?'
          podmienky1[1] = params[:display_resolution_hor1]
        else
          podmienky1[0] = podmienky1[0]+' AND display_resolution_hor = ?'
          podmienky1 << params[:display_resolution_hor1]
        end
      end

      unless params[:display_resolution_ver1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'display_resolution_ver = ?'
          podmienky1[1] = params[:display_resolution_ver1]
        else
          podmienky1[0] = podmienky1[0]+' AND display_resolution_ver = ?'
          podmienky1 << params[:display_resolution_ver1]
        end
      end

      unless params[:disc_rotations1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'disc_rotations = ?'
          podmienky1[1] = params[:disc_rotations1]
        else
          podmienky1[0] = podmienky1[0]+' AND disc_rotations = ?'
          podmienky1 << params[:disc_rotations1]
        end
      end

      unless params[:network1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'network = ?'
          podmienky1[1] = params[:network1]
        else
          podmienky1[0] = podmienky1[0]+' AND network = ?'
          podmienky1 << params[:network1]
        end
      end

      unless params[:weight1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'weight = ?'
          podmienky1[1] = params[:weight1]
        else
          podmienky1[0] = podmienky1[0]+' AND weight = ?'
          podmienky1 << params[:weight1]
        end
      end

      unless params[:drive1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'drive like ?'
          podmienky1[1] = '%'+params[:drive1]+'%'
        else
          podmienky1[0] = podmienky1[0]+' AND drive like ?'
          podmienky1 << '%'+params[:drive1]+'%'
        end
      end

      unless params[:grafic_card1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'grafic_card like ?'
          podmienky1[1] = '%'+params[:grafic_card1]+'%'
        else
          podmienky1[0] = podmienky1[0]+' AND grafic_card like ?'
          podmienky1 << '%'+params[:grafic_card1]+'%'
        end
      end

      unless params[:batery_life_time1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'batery_life_time = ?'
          podmienky1[1] = params[:batery_life_time1]
        else
          podmienky1[0] = podmienky1[0]+' AND batery_life_time = ?'
          podmienky1 << params[:batery_life_time1]
        end
      end

      unless params[:OS1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'OS like ?'
          podmienky1[1] = '%'+params[:OS1]+'%'
        else
          podmienky1[0] = podmienky1[0]+' AND OS like ?'
          podmienky1 << '%'+params[:OS1]+'%'
        end
      end

      unless params[:monitor_out1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'monitor_out = ?'
          podmienky1[1] = params[:monitor_out1]
        else
          podmienky1[0] = podmienky1[0]+' AND monitor_out = ?'
          podmienky1 << params[:batery_life_time1]
        end
      end

      unless params[:USB_number1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'USB_number = ?'
          podmienky1[1] = params[:USB_number1]
        else
          podmienky1[0] = podmienky1[0]+' AND USB_number = ?'
          podmienky1 << params[:USB_number1]
        end
      end

      unless params[:min_disc_capacity1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'disc_capacity >= ?'
          podmienky1[1] = params[:min_disc_capacity1]
        else
          podmienky1[0] = podmienky1[0]+' AND disc_capacity >= ?'
          podmienky1 << params[:min_disc_capacity1]
        end
      end

      unless params[:max_disc_capacity1] == '' then
        if podmienky1[0] == nil then
          podmienky1[0] = 'disc_capacity <= ?'
          podmienky1[1] = params[:max_disc_capacity1]
        else
          podmienky1[0] = podmienky1[0]+' AND disc_capacity <= ?'
          podmienky1 << params[:max_disc_capacity1]
        end
      end

      unless params[:wifi1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'wifi = ?'
          if params[:wifi1]== 'true' then
            podmienky1[1] = '1'
          else
            podmienky1[1] = '0'
          end
        else
          podmienky1[0] = podmienky1[0]+' AND wifi = ?'
          if params[:wifi1]== 'true' then
            podmienky1 << '1'
          else
            podmienky1 << '0'
          end
        end
      end

      unless params[:bluetooth1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'bluetooth = ?'
          if params[:bluetooth1]== 'true' then
            podmienky1[1] = '1'
          else
            podmienky1[1] = '0'
          end
        else
          podmienky1[0] = podmienky1[0]+' AND bluetooth = ?'
          if params[:bluetooth1]== 'true' then
            podmienky1 << '1'
          else
            podmienky1 << '0'
          end
        end
      end

       unless params[:card_reader1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'card_reader = ?'
          if params[:card_reader1]== 'true' then
            podmienky1[1] = '1'
          else
            podmienky1[1] = '0'
          end
        else
          podmienky1[0] = podmienky1[0]+' AND card_reader = ?'
          if params[:card_reader1]== 'true' then
            podmienky1 << '1'
          else
            podmienky1 << '0'
          end
        end
       end

       unless params[:webcam1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'webcam = ?'
          if params[:webcam1]== 'true' then
            podmienky1[1] = '1'
          else
            podmienky1[1] = '0'
          end
        else
          podmienky1[0] = podmienky1[0]+' AND webcam = ?'
          if params[:webcam1]== 'true' then
            podmienky1 << '1'
          else
            podmienky1 << '0'
          end
        end
       end

       unless params[:numeric_keyboard1] == nil then
        if podmienky1[0] == nil then
          podmienky1[0] = 'numeric_keyboard = ?'
          if params[:numeric_keyboard1]== 'true' then
            podmienky1[1] = '1'
          else
            podmienky1[1] = '0'
          end
        else
          podmienky1[0] = podmienky1[0]+' AND numeric_keyboard = ?'
          if params[:numeric_keyboard1]== 'true' then
            podmienky1 << '1'
          else
            podmienky1 << '0'
          end
        end
      end

     #----------------------------------------
      
      unless params[:RAM2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'memory_capacity = ?'
          podmienky2[1] = params[:RAM2]
        else
          podmienky2[0] = podmienky2[0]+' AND memory_capacity = ?'
          podmienky2 << params[:RAM2]
        end
      end

      unless params[:name2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'name like ?'
          podmienky2[1] = '%'+params[:name2]+'%'
        else
          podmienky2[0] = podmienky2[0]+' AND name like ?'
          podmienky2 << '%'+params[:name2]+'%'
        end
      end

      unless params[:processor_type2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'processor_type like ?'
          podmienky2[1] = '%'+params[:processor_type2]+'%'
        else
          podmienky2[0] = podmienky2[0]+' AND processor_type like ?'
          podmienky2 << '%'+params[:processor_type2]+'%'
        end
      end

      unless params[:processor_freq2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'processor_freq = ?'
          podmienky2[1] = params[:processor_freq2]
        else
          podmienky2[0] = podmienky2[0]+' AND processor_freq = ?'
          podmienky2 << params[:processor_freq2]
        end
      end

      unless params[:display_diag2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'display_diag = ?'
          podmienky2[1] = params[:display_diag2]
        else
          podmienky2[0] = podmienky2[0]+' AND display_diag = ?'
          podmienky2 << params[:display_diag2]
        end
      end

      unless params[:display_resolution_hor2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'display_resolution_hor = ?'
          podmienky2[1] = params[:display_resolution_hor2]
        else
          podmienky2[0] = podmienky2[0]+' AND display_resolution_hor = ?'
          podmienky2 << params[:display_resolution_hor2]
        end
      end

      unless params[:display_resolution_ver2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'display_resolution_ver = ?'
          podmienky2[1] = params[:display_resolution_ver2]
        else
          podmienky2[0] = podmienky2[0]+' AND display_resolution_ver = ?'
          podmienky2 << params[:display_resolution_ver2]
        end
      end

      unless params[:disc_rotations2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'disc_rotations = ?'
          podmienky2[1] = params[:disc_rotations2]
        else
          podmienky2[0] = podmienky2[0]+' AND disc_rotations = ?'
          podmienky2 << params[:disc_rotations2]
        end
      end

      unless params[:network2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'network = ?'
          podmienky2[1] = params[:network2]
        else
          podmienky2[0] = podmienky2[0]+' AND network = ?'
          podmienky2 << params[:network2]
        end
      end

      unless params[:weight2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'weight = ?'
          podmienky2[1] = params[:weight2]
        else
          podmienky2[0] = podmienky2[0]+' AND weight = ?'
          podmienky2 << params[:weight2]
        end
      end

      unless params[:drive2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'drive like ?'
          podmienky2[1] = '%'+params[:drive2]+'%'
        else
          podmienky2[0] = podmienky2[0]+' AND drive like ?'
          podmienky2 << '%'+params[:drive2]+'%'
        end
      end

      unless params[:grafic_card2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'grafic_card like ?'
          podmienky2[1] = '%'+params[:grafic_card2]+'%'
        else
          podmienky2[0] = podmienky2[0]+' AND grafic_card like ?'
          podmienky2 << '%'+params[:grafic_card2]+'%'
        end
      end

      unless params[:batery_life_time2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'batery_life_time = ?'
          podmienky2[1] = params[:batery_life_time2]
        else
          podmienky2[0] = podmienky2[0]+' AND batery_life_time = ?'
          podmienky2 << params[:batery_life_time2]
        end
      end

      unless params[:OS2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'OS like ?'
          podmienky2[1] = '%'+params[:OS2]+'%'
        else
          podmienky2[0] = podmienky2[0]+' AND OS like ?'
          podmienky2 << '%'+params[:OS2]+'%'
        end
      end

      unless params[:monitor_out2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'monitor_out = ?'
          podmienky2[1] = params[:monitor_out2]
        else
          podmienky2[0] = podmienky2[0]+' AND monitor_out = ?'
          podmienky2 << params[:batery_life_time2]
        end
      end

      unless params[:USB_number2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'USB_number = ?'
          podmienky2[1] = params[:USB_number2]
        else
          podmienky2[0] = podmienky2[0]+' AND USB_number = ?'
          podmienky2 << params[:USB_number2]
        end
      end

      unless params[:USB_number2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'USB_number = ?'
          podmienky2[1] = params[:USB_number2]
        else
          podmienky2[0] = podmienky2[0]+' AND USB_number = ?'
          podmienky2 << params[:USB_number2]
        end
      end

      unless params[:min_disc_capacity2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'disc_capacity >= ?'
          podmienky2[1] = params[:min_disc_capacity2]
        else
          podmienky2[0] = podmienky2[0]+' AND disc_capacity >= ?'
          podmienky2 << params[:min_disc_capacity2]
        end
      end

      unless params[:max_disc_capacity2] == '' then
        if podmienky2[0] == nil then
          podmienky2[0] = 'disc_capacity <= ?'
          podmienky2[1] = params[:max_disc_capacity2]
        else
          podmienky2[0] = podmienky2[0]+' AND disc_capacity <= ?'
          podmienky2 << params[:max_disc_capacity2]
        end
      end

      unless params[:wifi2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'wifi = ?'
          if params[:wifi2]== 'true' then
            podmienky2[1] = '1'
          else
            podmienky2[1] = '0'
          end
        else
          podmienky2[0] = podmienky2[0]+' AND wifi = ?'
          if params[:wifi2]== 'true' then
            podmienky2 << '1'
          else
            podmienky2 << '0'
          end
        end
      end

      unless params[:bluetooth2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'bluetooth = ?'
          if params[:bluetooth2]== 'true' then
            podmienky2[1] = '1'
          else
            podmienky2[1] = '0'
          end
        else
          podmienky2[0] = podmienky2[0]+' AND bluetooth = ?'
          if params[:bluetooth2]== 'true' then
            podmienky2 << '1'
          else
            podmienky2 << '0'
          end
        end
      end

       unless params[:card_reader2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'card_reader = ?'
          if params[:card_reader2]== 'true' then
            podmienky2[1] = '1'
          else
            podmienky2[1] = '0'
          end
        else
          podmienky2[0] = podmienky2[0]+' AND card_reader = ?'
          if params[:card_reader2]== 'true' then
            podmienky2 << '1'
          else
            podmienky2 << '0'
          end
        end
       end

       unless params[:webcam2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'webcam = ?'
          if params[:webcam2]== 'true' then
            podmienky2[1] = '1'
          else
            podmienky2[1] = '0'
          end
        else
          podmienky2[0] = podmienky2[0]+' AND webcam = ?'
          if params[:webcam2]== 'true' then
            podmienky2 << '1'
          else
            podmienky2 << '0'
          end
        end
       end

       unless params[:numeric_keyboard2] == nil then
        if podmienky2[0] == nil then
          podmienky2[0] = 'numeric_keyboard = ?'
          if params[:numeric_keyboard2]== 'true' then
            podmienky2[1] = '1'
          else
            podmienky2[1] = '0'
          end
        else
          podmienky2[0] = podmienky2[0]+' AND numeric_keyboard = ?'
          if params[:numeric_keyboard2]== 'true' then
            podmienky2 << '1'
          else
            podmienky2 << '0'
          end
        end
      end

    end

    if false then
    argumenty2[:memory_capacity] = params[:RAM2] unless params[:RAM2] == ''
    argumenty2[:name] = params[:name2] unless params[:name2] == ''
    argumenty2[:processor_type] = params[:processor_type2] unless params[:processor_type2] == ''
    argumenty2[:processor_freq] = params[:processor_freq2] unless params[:processor_freq2] == ''
    argumenty2[:display_diag] = params[:display_diag2] unless params[:display_diag2] == ''
    argumenty2[:display_resolution_hor] = params[:display_resolution_hor2] unless params[:display_resolution_hor2] == ''
    argumenty2[:display_resolution_ver] = params[:display_resolution_ver2] unless params[:display_resolution_ver2] == ''
    argumenty2[:disc_rotations] = params[:disc_rotations2] unless params[:disc_rotations2] == ''
    argumenty2[:network] = params[:network2] unless params[:network2] == ''
    argumenty2[:weight] = params[:weight2] unless params[:weight2] == ''
    argumenty2[:drive] = params[:drive2] unless params[:drive2] == ''
    argumenty2[:grafic_card] = params[:grafic_card2] unless params[:grafic_card2] == ''
    argumenty2[:batery_life_time] = params[:batery_life_time2] unless params[:batery_life_time2] == ''
    argumenty2[:OS] = params[:OS2] unless params[:OS2] == ''
    argumenty2[:monitor_out] = params[:monitor_out2] unless params[:monitor_out2] == ''
    argumenty2[:USB_number] = params[:USB_number2] unless params[:USB_number2] == ''
    end

    @notebooky1 = Notebook.find :all, :conditions => podmienky1 
    @notebooky2 = Notebook.find :all, :conditions => podmienky2


    @data1 = []
    unless ((@notebooky1==nil)||(params.length < 41)) then
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
    @data1 = @data1.sort{|a,b| a[2]<=>b[2]} #zoradenie podla popisu abecedne

    end

    @data2 = []
    unless ((@notebooky2==nil)||(params.length < 41)) then
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
    @data2 = @data2.sort{|a,b| a[2]<=>b[2]} #zoradenie podla popisu abecedne

    end

  end
                                                    
  

end
