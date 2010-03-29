#!/usr/bin/ruby1.8

require 'open-uri'
require 'rubygems'
require 'nokogiri'
require 'pp'


url = "http://shop.euroshop.sk/zbozi.aspx?vypis=pe2&skup=1&kat=122&pkat=1752&c=707I1679&skladem=0&page=1"
    @text = []
    doc = Nokogiri::HTML(open(url))
    obsah = []
    kod = "td[@class='tab1_kod']/text()"
    link = "td[@class='tab1_nazev']/h3/a/@href"

    doc.xpath("//table[@class='tab1']//tr[@class='tab1_rad1']|//tr[@class='tab1_rad2']").each do |e|
        riadok = []
        riadok << "kod: "+e.at_xpath(kod).to_s.strip
        riadok << " link: "+e.at_xpath(link).to_s.strip
        obsah << riadok;
      end
    pp obsah.each {|e| e.to_s}
