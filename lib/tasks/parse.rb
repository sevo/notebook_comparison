module Parse

require 'open-uri'
require 'rubygems'
require 'nokogiri'
require 'date'



   def self.parse_xml
     obchody = Store.find(:all)
     obchody.each do |obchod|

      store_name = obchod.name
      url = obchod.link + "cenikXML.aspx?akt=&skup=1&kat=122&vyr="
      puts "parsing: "+store_name
      begin
          doc = Nokogiri::HTML(open(url))
      rescue Exception
         puts "Error: "+ url
         next
      end

      #v xml subore najde vsetky elementy notebookov
      rows = doc.xpath("//zbozi[@podkategorie='Mini notebook']|//zbozi[@podkategorie='Tablet PC']|//zbozi[@podkategorie='Intel Core2 Duo']|//zbozi[@podkategori='Intel Core i5']|//zbozi[@podkategorie='Intel Core2 Quad']|//zbozi[@podkategorie='Intel Core i7']|//zbozi[@podkategori='Intel Dual Core']|//zbozi[@podkategorie='Intel Celeron M']|//zbozi[@podkategorie='Intel Core i3']|//zbozi[@podkategorie='AMD Athlon X2']|//zbozi[@podkategorie='Intel Single Core']|//zbozi[@podkategorie='Intel Celeron Dual Core']|//zbozi[@podkategorie='AMD Turion']|//zbozi[@podkategorie='AMD Athlon']|//zbozi[@podkategorie='AMD Turion X2']")
      obsah = []  #premenna na ulozenie detailov o vsetkych notebookoch

      #ziskanie detailov z elementu notebooku
      rows.collect do |row|
          detail = {}
          [
            [:code, "@part_number"],
            [:mark, "@vyrobce"],
            [:cost_wdph, "@cena"],
            [:popis, "@popis"],
            [:podkategoria, "@podkategorie"],
            [:kod, "@kod"],
          ].collect do |name, xpath|
            detail[name] = row.at_xpath(xpath).to_s.strip
            detail
          end

          popis = detail[:popis].split(/[\s\/]/)

          detail[:name] = popis[0]+" "+popis[1]

          popis.each {|e| detail[:display_diag]=e.match("^(\\w*-)?[\\D]?\\d\\d([,.]\\d)?(LED)?C?W?\\\"?\\z").to_s.gsub!(/[,.]/,'.').to_f if e=~/^(\w*-)?[\D]?\d\d([,.]\d)?(LED)?C?W?\"?\z/}
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

          popis.each {|e| detail[:bluetooth] = true if (e=~/\ABT?\z/)}

          obsah << detail
       end

      #vlkadanie notebookov do databazy
      store = Store.find_by_name(store_name)
      obsah.each do |e|


        notebook = Notebook.find_or_create_by_code(e[:code])   #vytvorenie notebooku ak neexistuje v databaze
        notebook.code=e[:code];
        notebook.name=e[:name];
        notebook.disc_capacity=e[:disc_capacity] if ((e[:disc_capacity]!=nil)&&(e[:disc_capacity]!=0))
        notebook.bluetooth=true if e[:bluetooth]!=nil
        notebook.memory_capacity=e[:memory_capacity] if ((e[:memory_capacity]!=nil)&&(e[:memory_capacity]!=0))
        notebook.processor_type=e[:processor_type] if e[:processor_type]!=nil
        notebook.display_diag=e[:display_diag] if ((e[:display_diag]!=nil)&&(e[:display_diag]!=0))
        notebook.save


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

        else
          cena2 = Cost.find(notebook_store.cost_id)
          if (cena2!=nil and cena2.date==Date.today and cena2.cost_wdph.to_f<=e[:cost_wdph].to_f) then #osetrenie opakovania sa rovnakych produktov
            cena2.cost_wdph=e[:cost_wdph]
            cena2.save
          elsif (cena2!=nil and cena2.date!=Date.today and cena2.cost_wdph.to_f!=e[:cost_wdph].to_f) then #zmenila sa cena produktu
               cena = Cost.new
               cena.cost_wdph=e[:cost_wdph]
               cena.date=Date.today
               cena.store_id=store.id
               cena.notebook_id=notebook.id
               cena.save

               notebook_store.cost_id=cena.id
               notebook_store.save
          end
        end


      end
   end
 end

   def self.parse_detail


     obchody = Store.find(:all)
     obchody.each do |obchod|


       meno = obchod.name
       adresa = obchod.link

       pocet_stran = 0
       puts "parsing "+meno
       url = adresa+"zbozi.aspx?vypis=pe2&cena=G200&skup=1&kat=122&pkat=1934O1646O1906O1647O1729O1710O1752O1937O1968O1969O1970O1788O1789O1790O1929O1918O1418O1913&sort=Popis&desc=0&skladem=0&page=1"
       begin
          doc = Nokogiri::HTML(open(url))
       rescue Exception
           puts "Error: "+ url
           next
       end
       doc.xpath("//td[@class='strankovani']/a").each {|e| pocet_stran = e.content.match(/\d*/).to_s.to_i if pocet_stran < e.content.match(/\d*/).to_s.to_i}

       pocet_stran.times do |p|
       #10.times do |p|
       url = adresa+"zbozi.aspx?vypis=pe2&cena=G200&skup=1&kat=122&pkat=1934O1646O1906O1647O1729O1710O1752O1937O1968O1969O1970O1788O1789O1790O1929O1918O1418O1913&sort=Popis&desc=0&skladem=0&page="+(p+1).to_s

       begin
          doc = Nokogiri::HTML(open(url))
       rescue Exception
           puts "Error: "+ url
           next
       end
       obsah = []

       rows=doc.xpath("//table[@class='tab1']//tr[@class='tab1_rad1']|//tr[@class='tab1_rad2']")
         rows.collect do |row|
         detail = {}
         [
           [:link, "td[@class='tab1_nazev']/h3/a/@href|td[@class='tab1_nazev_doprodej']/h3/a/@href"],
           [:obrazok, "td[@class='tab1_nahled']/img/@rel"],
           [:cena_wdph, "td[@class='tab1_cena_eu']/text()"],
         ].collect do |name, xpath|
               if ((name == :link) || (name == :obrazok)) then detail[name] = "http://shop.euroshop.sk"+row.at_xpath(xpath).to_s.strip
               else detail[name] = row.at_xpath(xpath).to_s.strip
               end
            detail
           end
           obsah << detail
         end

           obsah.each do |p|
             pole = {}
             begin
                 stranka = Nokogiri::HTML(open(p[:link]+"&page=3-technicke-parametre"))
             rescue Exception
                 puts "Error: "+ p[:link]+"&page=3-technicke-parametre"
                 next
             end
             pole_obch = {}
             begin
                 stranka_obch = Nokogiri::HTML(open(p[:link]+"&page=2-obchodne-parametre"))
             rescue Exception
                 puts "Error: "+ p[:link]+"&page=2-obchodne-parametre"
                 next
             end
             stranka_obch.xpath("//tr[@class='tab1_rad1']|//tr[@class='tab1_rad2']").each {|e| pole_obch[e.at_xpath("td[1]").to_s.strip]=e.at_xpath("td[2]").to_s }
             pole_obch.each do |key, value|
               p[:kod]=value.match(">.+<").to_s.delete("<>Â") if key=~/Part/   #ziskanie kodu notebooku
             end

             p[:podrobnosti] = ""
             stranka.xpath("//table[@class='tab1']//tr[@class='tab1_rad1']|//tr[@class='tab1_rad2']").each {|e| pole[e.at_xpath("td[1]").to_s.strip]=e.at_xpath("td[2]").to_s }
             #stranka.xpath("//table[@class='tab1']//tr[@class='tab1_rad1']|//tr[@class='tab1_rad2']").each {|e| pole << e}

             #stranka.xpath("//div[@id='original']//p/text()").each {|e| pole << e.content}
             #pole_obch.each {|e| p[:podrobnosti]=p[:podrobnosti]+e.to_s+"<br>"}
             if p[:kod]!=nil then
               notebook = Notebook.find_or_create_by_code(p[:kod])
               notebook.code=p[:kod]
               notebook.picture_link=p[:obrazok]
               notebook.save()

               pole.each do |key, value|
                 notebook.code=p[:kod]
                 notebook.processor_freq=value.match("\\d+[,.]?\\d*").to_s.gsub(/[,.]/,'.').to_s.to_f if key=~/Frekvence procesoru/
                 notebook.display_diag=value.match("\\d+[,.]?\\d*").to_s.gsub!(/[,.]/,'.').to_f if key=~/ÃhlopÅÃ­Äka LCD/
                 notebook.display_diag=value.match("\\d+[,.]?\\d*").to_s.gsub!(/[,.]/,'.').to_f if key=~/Úhlopříčka LCD/
                 notebook.display_resolution_ver=value.match("\\d+x").to_s.delete("x").to_i if key=~/RozliÅ¡enÃ­ LCD/
                 notebook.display_resolution_hor=value.match("x\\d+").to_s.delete("x").to_i if key=~/RozliÅ¡enÃ­ LCD/
                 notebook.display_resolution_ver=value.match("\\d+x").to_s.delete("x").to_i if key=~/Rozlišení LCD/
                 notebook.display_resolution_hor=value.match("x\\d+").to_s.delete("x").to_i if key=~/Rozlišení LCD/
                 notebook.disc_rotations=value.match("\\d+").to_s.to_i if key=~/OtÃ¡Äky pevnÃ©ho disku/ || key=~/Otáčky pevného disku/
                 notebook.drive=value.match(">.+<").to_s.delete("<>Â") if ((key=~/OptickÃ¡ mechanika/)&&!(value.match(">.+<").to_s.delete("<>Â")=~/bez/))
                 notebook.drive=value.match(">.+<").to_s.delete("<>Â") if ((key=~/Optická mechanika/)&&!(value.match(">.+<").to_s.delete("<>Â")=~/bez/))
                 notebook.card_reader=true if ((key=~/ÄteÄka karet/)&&(value=~/ANO/i))
                 notebook.card_reader=false if ((key=~/ÄteÄka karet/)&&(value=~/NE/i))
                 notebook.card_reader=true if ((key=~/Čtečka karet/)&&(value=~/ANO/i))
                 notebook.card_reader=false if ((key=~/Čtečka karet/)&&(value=~/NE/i))
                 notebook.network=value.match(">.+<").to_s.delete("<>Â") if key=~/SÃ­Å¥ovÃ¡ karta/
                 notebook.network=value.match(">.+<").to_s.delete("<>Â") if key=~/Síťová karta/
                 notebook.wifi=true if ((key=~/BezdrÃ¡tovÃ¡ sÃ­Å¥ovÃ¡ karta/)&&(value=~/ANO/i))
                 notebook.wifi=false if ((key=~/BezdrÃ¡tovÃ¡ sÃ­Å¥ovÃ¡ karta/)&&(value=~/NE/i))
                 notebook.wifi=true if ((key=~/Bezdrátová síťová karta/)&&(value=~/ANO/i))
                 notebook.wifi=false if ((key=~/Bezdrátová síťová karta/)&&(value=~/NE/i))
                 notebook.modem =true if ((key=~/Modem/)&&(value=~/ANO/i))
                 notebook.modem=false if ((key=~/Modem/)&&(value=~/NE/i))
                 if ((key=~/3G/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("3G")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end
                 notebook.disc_capacity=value.match("\\d+").to_s.to_i if key=~/PevnÃ½ disk/
                 notebook.disc_capacity=value.match("\\d+").to_s.to_i if key=~/Pevný disk/
                 notebook.grafic_card=value.match(">\\S+\\s").to_s.delete("<>Â")+" zdielana pamat" if ((key=~/GrafickÃ¡ karta/)&&(value=~/ sd/))
                 notebook.grafic_card=value.match(">\\S+\\s").to_s.delete("<>Â")+value.match("\\d+MB").to_s if ((key=~/GrafickÃ¡ karta/)&&(value=~/nesd/))
                 notebook.grafic_card=value.match(">\\S+\\s").to_s.delete("<>Â")+" zdielana pamat" if ((key=~/Grafická karta/)&&(value=~/ sd/))
                 notebook.grafic_card=value.match(">\\S+\\s").to_s.delete("<>Â")+value.match("\\d+MB").to_s if ((key=~/Grafická karta/)&&(value=~/nesd/))
                 notebook.touchpad=true if ((key=~/PolohovacÃ­ zaÅÃ­zenÃ­/)&&(value=~/TouchPad /i))
                 notebook.touchpad=false if ((key=~/PolohovacÃ­ zaÅÃ­zenÃ­/)&&!(value=~/TouchPad /i))
                 notebook.touchpad=true if ((key=~/Polohovací zařízení/)&&(value=~/TouchPad /i))
                 notebook.touchpad=false if ((key=~/Polohovací zařízení/)&&!(value=~/TouchPad /i))
                 notebook.numeric_keyboard=true if ((key=~/NumerickÃ¡ klÃ¡vesnice/)&&(value=~/ANO/i))
                 notebook.numeric_keyboard=false if ((key=~/NumerickÃ¡ klÃ¡vesnice/)&&(value=~/NE/i))
                 notebook.numeric_keyboard=true if ((key=~/Numerická klávesnice/)&&(value=~/ANO/i))
                 notebook.numeric_keyboard=false if ((key=~/Numerická klávesnice/)&&(value=~/NE/i))
                 notebook.webcam=true if ((key=~/WebovÃ¡ kamera/)&&(value=~/ANO/i))
                 notebook.webcam=false if ((key=~/WebovÃ¡ kamera/)&&(value=~/NE/i))
                 notebook.webcam=true if ((key=~/Webová kamera/)&&(value=~/ANO/i))
                 notebook.webcam=false if ((key=~/Webová kamera/)&&(value=~/NE/i))

                 if ((key=~/ReplikÃ¡tor portÅ¯/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("Port replicator")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 if ((key=~/Replikátor portů/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("Port replicator")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 notebook.USB_number=value.match("\\d+").to_s.to_i if key=~/PoÄet USB portÅ¯/
                 notebook.USB_number=value.match("\\d+").to_s.to_i if key=~/Počet USB portů/

                 if ((key=~/Firewire/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("Firewire")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 if ((key=~/TV vÃ½stup/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("TV out")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 if ((key=~/TV výstup/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("TV out")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 notebook.monitor_out=value.match(">.*<").to_s.delete("<>") if key=~/VÃ½stup na monitor/
                 notebook.monitor_out=value.match(">.*<").to_s.delete("<>") if key=~/Výstup na monitor/

                 if ((key=~/TV tuner/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("TV tuner")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 if ((key=~/SÃ©riovÃ½ port/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("Serial port")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 if ((key=~/Sériový port/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("Serial port")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 if ((key=~/Infra port/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("Infra port")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 notebook.bluetooth=true if ((key=~/Bluetooth/)&&(value=~/ANO/i))
                 notebook.bluetooth=false if ((key=~/Bluetooth/)&&(value=~/NE/i))

                 if ((key=~/ParalelnÃ­ port/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("Parallel port")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 if ((key=~/Paralelní port/)&&(value=~/ANO/i)) then
                  port = Port.find_or_create_by_name("Parallel port")
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 if ((key=~/Card slot/)&&!(value=~/NE/i)) then
                   hodnota = value.match(">.+<").to_s.delete("<>Â")
                  port = Port.find_or_create_by_name(hodnota)
                  port.save()
                  port_notebook= NotebookPort.find_or_create_by_notebook_id_and_port_id(notebook.id,port.id)
                  port_notebook.save()
                 end

                 notebook.OS=value.match(">.+<").to_s.delete("<>Â") if key=~/OperaÄnÃ­ systÃ©m/ || key=~/Operační systém/
                 notebook.weight=value.match(">.+<").to_s.delete("<>Â").gsub("více","viac").gsub("vÃ­ce","viac") if key=~/Hmotnost/

                 notebook.batery_life_time=value.match(">.+<").to_s.delete("<>Â").gsub(/v.+ce/,"viac") if key=~/VÃ½drÅ¾ na baterie/
                 notebook.batery_life_time=value.match(">.+<").to_s.delete("<>Â").gsub("více","viac").gsub(/v.+ce/,"viac").gsub("v�ce","viac") if key=~/Výdrž na baterie/
               end
               notebook.save();
             end

             end
           


       end
       end
end


end