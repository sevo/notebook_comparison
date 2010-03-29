class PagesController < ApplicationController

  def home

  end


  def parse
    require 'open-uri'
    require 'rubygems'
    require 'nokogiri'




    @title = "vysekavac zo stranky"
    #url ="http://www.alza.sk/lenovo-thinkpad-w700-2758-n2g-d142671.htm"
    url = "http://www.alza.sk/toshiba-qosmio-x300-15g-d120006.htm"
    @text = []
    doc = Nokogiri::HTML(open(url))
    doc.xpath("//div[@id='DetailItem']//div[@style='text-align:left ']/text()|//div[@style='text-align:left']/text()|//div[@style='text-align: left']/text()|//strong").each {|e| @text << e.content }
    nadpis = ""
    doc.xpath("//H1[@id='itemH1']").each {|e| nadpis=e.content}
    nadpis=nadpis.split('/ ')

    @telo = ""
    counter = 0
    @text.each {|e| @telo = "#{@telo}<br><br>#{e}:#{counter}"; counter+=1}
    @telo = "#{@telo}<br><br>cena: #{cena(@text)}<br><br>meno: #{meno(doc)}<br><br>kod: #{kod(doc)}"
  end


   def cena(text)
    counter =0
     while (!(text[counter] =~ /vrátane/) && (counter<text.length)) do counter +=1  end
     #text[counter+1]
     text[counter+1].sub(/,/,'.').gsub(/[\302\240]/,'').to_f

   end
  def meno(doc)
    text =[]
    meno = ""
   doc.xpath("//title").each {|e| meno=e.content}
    text = meno.split
    meno = ""
   text[0...text.length-1].each {|e| meno = "#{meno} #{e}"}
    meno
  end

  def kod(doc)
    text = []
   doc.xpath("//title").each {|e| text=e.content}
   text.split[-1] 
  end

  def stranky()

  end

private :cena,:meno,:kod,:stranky
end
