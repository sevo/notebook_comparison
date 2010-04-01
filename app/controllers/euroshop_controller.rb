class EuroshopController < ApplicationController
    require 'open-uri'
    require 'rubygems'
    require 'nokogiri'
    require 'date'


  def parse



    @title = "vysekavac zo stranky"
    url = "http://shop.euroshop.sk/zbozi.aspx?vypis=pe2&skup=1&kat=122&pkat=1752&c=707I1679&skladem=0&page=1"
    @text = []
    doc = Nokogiri::HTML(open(url))
    doc.xpath("//div[@id='DetailItem']//div[@style='text-align:left ']/text()|//div[@style='text-align:left']/text()|//div[@style='text-align: left']/text()|//strong").each {|e| @text << e.content }
    obsah = []
   
rows=doc.xpath("//table[@class='tab1']//tr[@class='tab1_rad1']|//tr[@class='tab1_rad2']")
  rows.collect do |row|
  detail = {}
  [
    [:kod, "td[@class='tab1_kod']/text()"],
    [:link, "td[@class='tab1_nazev']/h3/a/@href|td[@class='tab1_nazev_doprodej']/h3/a/@href"],
    [:cena_dph, "td[@class='tab1_cena_eu'][2]/text()"],
    [:cena_wdph, "td[@class='tab1_cena_eu']/text()"],
    [:obrazok, "td[@class='tab1_nahled']/img/@rel"],
  ].collect do |name, xpath|
        if ((name== :cena_dph) || (name== :cena_wdph)) then detail[name] = row.at_xpath(xpath).to_s.gsub(/[\302\240]/,"").to_f.to_s.strip
        else
        if ((name == :link) || (name == :obrazok)) then detail[name] = "http://shop.euroshop.sk/"+row.at_xpath(xpath).to_s.strip
        else detail[name] = row.at_xpath(xpath).to_s.strip
        end
        end
     detail
    end
    obsah << detail
  end

    obsah.each do |p|
      #@telo= @telo+e[:kod].to_s
      pole = []
      stranka = Nokogiri::HTML(open(p[:link]))
      pole << "<b>kodovanie: </b>"+stranka.encoding
      stranka.xpath("//div[@id='original']//p/text()").each {|e| pole << e.content}
      #p[:podrobnosti] = pole.each {|e| e.to_s+"<br>"}
      p[:podrobnosti]=pole
    end

    @telo = ""
    obsah.each do

    |e| e.collect do |meno, hodnota|
        if (meno == :podrobnosti) then hodnota.each {|e| @telo = @telo+e+"<br>"}
        else @telo = @telo+"<b> "+meno.to_s+" </b>"+hodnota.to_s+"<br>"
        end
      end
      @telo = @telo + "<hr>"
    end

  end

  def pln
    counter = 0
    @telo = ""
     [
      ["euroshop", "http://shop.euroshop.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["shm", "http://eshop.shm.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["x-computers", "http://eshop.x-computers.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["comtec", "http://eshop.comtec.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["ASSI computer", "http://assi.ekatalog.biz/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["mirocomputers", "http://eshop.mirocomputers.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["witto", "http://witto.ekatalog.biz/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["jkc", "http://eobchod.jkc.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["sattva", "http://www.sattva.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["mobilpc", "http://mobilpc.ekatalog.biz/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["eshop4you", "http://www.eshop4you.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
      ["pc-cennik", "http://www.pc-cennik.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="],
     ].collect do |store_name, url|
    #store_name = "euroshop"


    #url = "http://eshop.x-computers.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="
    #url = "http://shop.euroshop.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="
    doc = Nokogiri::HTML(open(url))

    rows = doc.xpath("//zbozi[@podkategorie='Mini notebook']|//zbozi[@podkategorie='Tablet PC']|//zbozi[@podkategorie='Intel Core2 Duo']|//zbozi[@podkategori='Intel Core i5']|//zbozi[@podkategorie='Intel Core2 Quad']|//zbozi[@podkategorie='Intel Core i7']|//zbozi[@podkategori='Intel Dual Core']|//zbozi[@podkategorie='Intel Celeron M']|//zbozi[@podkategorie='Intel Core i3']|//zbozi[@podkategorie='AMD Athlon X2']|//zbozi[@podkategorie='Intel Single Core']|//zbozi[@podkategorie='Intel Celeron Dual Core']|//zbozi[@podkategorie='AMD Turion']|//zbozi[@podkategorie='AMD Athlon']|//zbozi[@podkategorie='AMD Turion X2']")
    obsah = []

    rows.collect do |row|
    detail = {}
    [

    #rows[1].at_xpath("@part_number").to_s

      [:code, "@part_number"],
      [:mark, "@vyrobce"],
      [:cost_wdph, "@cena"],
      [:popis, "@popis"],
      [:podkategoria, "@podkategorie"],
      [:kod, "@kod"],
    ].collect do |name, xpath|
        #if ((name== :cena_dph) || (name== :cena_wdph)) then detail[name] = row.at_xpath(xpath).to_s.gsub(/[\302\240]/,"").to_f.to_s.strip
        #else
        #if ((name == :link) || (name == :obrazok)) then detail[name] = "http://shop.euroshop.sk/"+row.at_xpath(xpath).to_s.strip
        #else detail[name] = row.at_xpath(xpath).to_s.strip
          detail[name] = row.at_xpath(xpath).to_s.strip
        #end
        #end
     detail
    end

    popis = detail[:popis].split(/[\s\/]/)

    detail[:name] = popis[0]+" "+popis[1]

    popis.each {|e| detail[:display_diag]=e.match("^(\\w*-)?[\\D]?\\d\\d([,.]\\d)?(LED)?C?W?\\\"?\\z").to_s.gsub!(/[,.]/,'.').to_f if e=~/^(\w*-)?[\D]?\d\d([,.]\d)?(LED)?C?W?\"?\z/}
    #detail[:vel_displ]=detail[:vel_displ].split['-'][1] if (detail[:vel_displ]=~/-/)
    detail[:display_diag]=detail[:display_diag].match("\\d\\d([,.]\\d)?(LED)?C?W?\\\"?\\z").to_s.gsub!(/[,.]/,'.').to_f if (detail[:display_diag]=~/-/)
    detail[:display_diag] = nil if detail[:display_diag]==0.0

    popis.each do|e|
        detail[:disc_capacity]=e.to_i if e=~/\A\d\d+G?(GB)?(SSD)?\z/
        detail[:disc_capacity]=(e.to_f*1024).to_int if e=~/\A\dT\z/
    end

    detail[:processor_type] = detail[:podkategoria]+" "+detail[:popis].match("[a-zA-Z]+ ?-?[0-9]+\/").to_s.delete("/").to_s unless(detail[:podkategoria]== "Mini notebook"|| detail[:podkategoria]== "Tablet PC")
    popis.each {|e| detail[:processor_type]=detail[:processor_type]+" "+e if ((e=~/i[\d]+/)!=nil) } if ((detail[:podkaregoria]=~/Intel Core i/)!=nil)
    popis.each {|e| detail[:processor_type]=e if ((e=~/[a-zA-Z]+ ?-?[0-9]+\z/)!=nil) } if (detail[:podkategoria]== "Mini notebook"|| detail[:podkategoria]== "Tablet PC")

    popis.each {|e| detail[:memory_capacity]= eval(e.delete('B').delete('G')).to_s if ((e=~/\A\d(GB?)?\z/)||(e=~/\A(\d\+)?\dG?\z/))&&(e!=nil)}

    popis.each {|e| detail[:triG] = e if (e=~/\A3G\z/)&&(detail[:RAM])}

    popis.each {|e| detail[:bluetooth] = true if (e=~/\ABT?\z/)}

    pom=""
    popis.each do |e|

      pom += "Windows 7 Starter " if (e=~/7st/)
      pom += "Windows 7 Home Premium " if (e=~/7HP/)
      pom += "Windows 7 Starter " if (e=~/W7S/)
      pom += "Windows Vista Business " if (e=~/VB/)
      pom += "Windows 7 Professional " if (e=~/7P/)
      pom += "Windows Vista Home Premium " if (e=~/VHP/)
      pom += "Windows XP Home " if (e=~/XPH/)
      pom += "Windows 7 Starter " if (e=~/7S/)
      pom += "Windows 7 Ultimate " if (e=~/7U/)
      pom += "noOS " if (e=~/noOS/)
      pom += "Linux " if (e=~/Lin/)
      pom += "Windows XP Professional " if (e=~/XPP/)
      pom += "Windows XP " if (e=~/XP/)&&!(e=~/XPP/)&&!(e=~/XPH/)

    end
    detail[:OS]=pom unless pom==""

    popis.each do |e|
      detail[:drive] = "DVD" if (e=~/DVD/)
      detail[:drive] = "Blu Ray" if (e=~/BR/)
    end

    obsah << detail
      end
    #end

    store = Store.find_by_name(store_name)

    #@telo = ""
    obsah.each do |e|
    #|e| e.collect do |meno, hodnota|
    #    if (meno == :podrobnosti) then hodnota.each {|e| @telo = @telo+e+"<br>"}
    #    else @telo = @telo+"<b> "+meno.to_s+" </b>"+hodnota.to_s+"<br>"
    #      @telo = @telo+"<b> "+meno.to_s+" </b>"+hodnota.to_s+"<br>"
     #   end
     # end



      if (notebook = Notebook.find_by_code(e[:code])) == nil then   #notebook neexistuje
        notebook=Notebook.new
        notebook.code=e[:code];
        notebook.name=e[:name];
        notebook.disc_capacity=e[:disc_capacity] if e[:disc_capacity]!=nil
        notebook.drive=e[:drive] if e[:drive]!=nil
        notebook.bluetooth=true if e[:bluetooth]!=nil
        notebook.memory_capacity=e[:memory_capacity] if e[:memory_capacity]!=nil
        notebook.processor_type=e[:processor_type] if e[:processor_type]!=nil
        notebook.display_diag=e[:display_diag] if e[:display_diag]!=nil
        notebook.save

        cena = Cost.new
        cena.cost_wdph=e[:cost_wdph]
        cena.date=Date.today
        cena.store_id=store.id
        cena.notebook_id=notebook.id
        cena.save


        notebook_store = NotebookStore.new
        notebook_store.cost_id=cena.id
        notebook_store.notebook_id=notebook.id
        notebook_store.store_id=store.id
        notebook_store.save

      else                                                   #notebook existuje
        #store=Store.find_by_name(store_name)
        notebook_store=NotebookStore.find_by_notebook_id_and_store_id(notebook.id,store.id)
        if notebook_store==nil then     #novy notebook v ponuke obchodu#potrebujem mapovanie medzi cenou a note a obchodom a note
          cena = Cost.new
          cena.cost_wdph=e[:cost_wdph]
          cena.date=Date.today
          cena.store_id=store.id
          cena.notebook_id=notebook.id
          cena.save


          notebook_store = NotebookStore.new
          notebook_store.cost_id=cena.id
          notebook_store.notebook_id=notebook.id
          notebook_store.store_id=store.id
          notebook_store.save

        elsif (cena2=Cost.find_by_notebook_id_and_store_id(notebook.id,store.id)).cost_wdph.to_f<=e[:cost_wdph].to_f and cena2.date=Date.today then    #cena sa len zmenila nic ine
          #dorobit podmienku
          cena = Cost.new
          cena.cost_wdph=e[:cost_wdph]
          cena.date=Date.today
          cena.store_id=store.id
          cena.notebook_id=notebook.id
          cena.save
          counter+=1
         # @telo = @telo + "<br>"+ counter.to_s+"     "+notebook_store.cost_wdph.to_s+"    "+e[:cost_wdph]+"    id: "+notebook.id.to_s+"   "+notebook_store.notebook_id.to_s+"  "+e[:code]+"  "+store.name

          notebook_store.cost_id=cena.id
          notebook_store.save

          cena2.delete

            end

      end

       end
          #  @telo = @telo + "<hr>"
   end
  end


  def parse_xml
    url = "http://eshop.mirocomputers.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="
    #url = "http://shop.euroshop.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="
    doc = Nokogiri::HTML(open(url))

    rows = doc.xpath("//zbozi[@podkategorie='Mini notebook']|//zbozi[@podkategorie='Tablet PC']|//zbozi[@podkategorie='Intel Core2 Duo']|//zbozi[@podkategori='Intel Core i5']|//zbozi[@podkategorie='Intel Core2 Quad']|//zbozi[@podkategorie='Intel Core i7']|//zbozi[@podkategori='Intel Dual Core']|//zbozi[@podkategorie='Intel Celeron M']|//zbozi[@podkategorie='Intel Core i3']|//zbozi[@podkategorie='AMD Athlon X2']|//zbozi[@podkategorie='Intel Single Core']|//zbozi[@podkategorie='Intel Celeron Dual Core']|//zbozi[@podkategorie='AMD Turion']|//zbozi[@podkategorie='AMD Athlon']|//zbozi[@podkategorie='AMD Turion X2']")
    obsah = []

    rows.collect do |row|
    detail = {}
    [

    #rows[1].at_xpath("@part_number").to_s

      [:kod, "@part_number"],
      [:vyrobca, "@vyrobce"],
      [:cena_wdph, "@cena"],
      [:popis, "@popis"],
      [:podkategoria, "@podkategorie"],
    ].collect do |name, xpath|
        #if ((name== :cena_dph) || (name== :cena_wdph)) then detail[name] = row.at_xpath(xpath).to_s.gsub(/[\302\240]/,"").to_f.to_s.strip
        #else
        #if ((name == :link) || (name == :obrazok)) then detail[name] = "http://shop.euroshop.sk/"+row.at_xpath(xpath).to_s.strip
        #else detail[name] = row.at_xpath(xpath).to_s.strip
          detail[name] = row.at_xpath(xpath).to_s.strip
        #end
        #end
     detail
    end
    popis = detail[:popis].split(/[\s\/]/) 

    detail[:meno] = popis[0]+" "+popis[1]

    popis.each {|e| detail[:vel_displ]=e.match("^(\\w*-)?[\\D]?\\d\\d([,.]\\d)?(LED)?C?W?\\\"?\\z").to_s.gsub!(/[,.]/,'.').to_f if e=~/^(\w*-)?[\D]?\d\d([,.]\d)?(LED)?C?W?\"?\z/}
    #detail[:vel_displ]=detail[:vel_displ].split['-'][1] if (detail[:vel_displ]=~/-/)
    detail[:vel_displ]=detail[:vel_displ].match("\\d\\d([,.]\\d)?(LED)?C?W?\\\"?\\z").to_s.gsub!(/[,.]/,'.').to_f if (detail[:vel_displ]=~/-/)

    popis.each do|e|
        detail[:vel_disku]=e.to_i if e=~/\A\d\d+G?(GB)?(SSD)?\z/
        detail[:vel_disku]=(e.to_f*1024).to_int if e=~/\A\dT\z/
    end

    detail[:procesor] = detail[:podkategoria]+" "+detail[:popis].match("[a-zA-Z]+ ?-?[0-9]+\/").to_s.delete("/").to_s unless(detail[:podkategoria]== "Mini notebook"|| detail[:podkategoria]== "Tablet PC")
    popis.each {|e| detail[:procesor]=detail[:procesor]+" "+e if ((e=~/i[\d]+/)!=nil) } if ((detail[:podkaregoria]=~/Intel Core i/)!=nil)
    popis.each {|e| detail[:procesor]=e if ((e=~/[a-zA-Z]+ ?-?[0-9]+\z/)!=nil) } if (detail[:podkategoria]== "Mini notebook"|| detail[:podkategoria]== "Tablet PC")

    popis.each {|e| detail[:RAM]= eval(e.delete('B').delete('G')).to_s if ((e=~/\A\d(GB?)?\z/)||(e=~/\A(\d\+)?\dG?\z/))&&(e!=nil)}

    popis.each {|e| detail[:triG] = e if (e=~/\A3G\z/)&&(detail[:RAM])}

    popis.each {|e| detail[:Bluetooth] = true if (e=~/\ABT?\z/)}

    pom=""
    popis.each do |e|

      pom += "Windows 7 Starter " if (e=~/7st/)
      pom += "Windows 7 Home Premium " if (e=~/7HP/)
      pom += "Windows 7 Starter " if (e=~/W7S/)
      pom += "Windows Vista Business " if (e=~/VB/)
      pom += "Windows 7 Professional " if (e=~/7P/)
      pom += "Windows Vista Home Premium " if (e=~/VHP/)
      pom += "Windows XP Home " if (e=~/XPH/)
      pom += "Windows 7 Starter " if (e=~/7S/)
      pom += "Windows 7 Ultimate " if (e=~/7U/)
      pom += "noOS " if (e=~/noOS/)
      pom += "Linux " if (e=~/Lin/)
      pom += "Windows XP Professional " if (e=~/XPP/)
      pom += "Windows XP " if (e=~/XP/)&&!(e=~/XPP/)&&!(e=~/XPH/)

    end
    detail[:OS]=pom unless pom==""

    popis.each do |e|
      detail[:mechanika] = "DVD" if (e=~/DVD/)
      detail[:mechanika] = "Blu Ray" if (e=~/BR/)
    end

    obsah << detail
    end

    @telo = ""
    obsah.each do
    |e| e.collect do |meno, hodnota|
    #    if (meno == :podrobnosti) then hodnota.each {|e| @telo = @telo+e+"<br>"}
    #    else @telo = @telo+"<b> "+meno.to_s+" </b>"+hodnota.to_s+"<br>"
          @telo = @telo+"<b> "+meno.to_s+" </b>"+hodnota.to_s+"<br>"
     #   end
      end
      @telo = @telo + "<hr>"
    end

   end


    #@telo = ""
   # @telo = doc.xpath("//zbozi").length.to_s+"<br>"#each {|e| @telo = @telo+e.content+"<br><br>"}
   # doc.xpath('//zbozi/@podkategorie').each {|e| @telo = @telo+e+"<br><br>"}



  def agem
    url = "/home/jakub/Desktop/cennik.xml"
    doc = Nokogiri::HTML(open(url))
    @telo = "Pocet notebookov v ponuke: "+doc.xpath("//product/kategorie[kategoria1='Notebook']").length.to_s
    rows = doc.xpath("//product/kategorie[kategoria1='Notebook']") 


  end

end
