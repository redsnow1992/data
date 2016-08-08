require 'nokogiri'
require "open-uri"


# current = "http://top.chinaz.com/hangye/"
# doc = Nokogiri::HTML(open(current))

def extract_site_info(url)
  puts url
  doc = Nokogiri::HTML(open(url))
  doc.css(".fz14.SimSun")
  all_tags = doc.css(".fz14.SimSun a").map(&:text)
  locate = doc.css(".mb15.fz14.SimSun a").map(&:text)
  cats = all_tags - locate
  [cats.join(","), locate.join(",")]
end

def deal_a_site(url, file)
  home = "http://top.chinaz.com"
  doc = Nokogiri::HTML(open(url))
  doc.css(".rightTxtHead").each do |line|
    name = line.children[0].attributes["title"].value
    domain = line.children[1].text
    link = File.join(home, line.children[0].attributes["href"].value)
    info = extract_site_info(link)
    record = ([name, domain] + info).join("\t")
    puts record
    file.puts record
  end
end

filename = "/home/alfonso/Work/site_info.tsv"

([""] + (2..1719).map{|i| "_#{i}"}.to_a).each do |i|
  home = "http://top.chinaz.com/hangye/"
  url = File.join(home, "index#{i}.html")
  puts url
  File.open(filename, "a") do |file|
    deal_a_site(url, file)
  end
end