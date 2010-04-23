desc "Notebook information parsing"

task :parse_xml => :environment do
  require File.join(File.dirname(__FILE__), "parse.rb")
  Parse.parse_xml
end

task :parse_detail => :environment do
  require File.join(File.dirname(__FILE__), "parse.rb")
   Parse.parse_detail
end

