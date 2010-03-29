class EuroshopController < ApplicationController
    require 'open-uri'
    require 'rubygems'
    require 'nokogiri'


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

  def parse_xml
    url = "http://eshop.x-computers.sk/cenikXML.aspx?akt=&skup=1&kat=122&vyr="
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

    popis.each {|e| detail[:vel_displ]=e.match("^(\\w*-)?[\\D]?\\d\\d([,.]\\d)?(LED)?C?W?\\\"?\\z").to_s if e=~/^(\w*-)?[\D]?\d\d([,.]\d)?(LED)?C?W?\"?\z/}
    #detail[:vel_displ]=detail[:vel_displ].split['-'][1] if (detail[:vel_displ]=~/-/)
    detail[:vel_displ]=detail[:vel_displ].match("\\d\\d([,.]\\d)?(LED)?C?W?\\\"?\\z").to_s if (detail[:vel_displ]=~/-/)

    popis.each do|e|
        detail[:vel_disku]=e if e=~/\A\d\d+G?(GB)?(SSD)?\z/
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




    #@telo = ""
   # @telo = doc.xpath("//zbozi").length.to_s+"<br>"#each {|e| @telo = @telo+e.content+"<br><br>"}
   # doc.xpath('//zbozi/@podkategorie').each {|e| @telo = @telo+e+"<br><br>"}


  end

  def agem
    url = "/home/jakub/Desktop/cennik.xml"
    doc = Nokogiri::HTML(open(url))
    @telo = "Pocet notebookov v ponuke: "+doc.xpath("//product/kategorie[kategoria1='Notebook']").length.to_s
    rows = doc.xpath("//product/kategorie[kategoria1='Notebook']") 


  end

end
