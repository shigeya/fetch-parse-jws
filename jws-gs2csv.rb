#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'nokogiri'
require 'ap'
require 'csv'

if ARGV.count != 1
  puts "usage: jws-gs2csv.rb in-file-html"
end

infile = ARGV[0]
outfile = [File::dirname(infile),
           File::basename(infile, ".html")+".csv" ].join("/")

STDERR.puts "#{infile} => #{outfile}"

uri = 'http://jpquake.wikispaces.com/Journalist+Wall+of+Shame'
n = Nokogiri::HTML(open infile)

num = 1

csv = CSV.open(outfile, "w")

n.css("table").each do |t| # for tables
  tid = t['id']
  if tid =~ /^tblMain_/
    t.css('tr').each do |tr|
      if tr['class'] == nil
        tds = tr.css('td')
        
        date        = tds[1].content
        name        = tds[2].content
        publication = tds[3].content
        nature      = tds[4].content
        severity    = tds[5].content
        link        = tds[6].content
        comments    = tds[7].content
        if tds[1]['class'] == "s0"
          date        = tds[3].content
          name        = tds[2].content
          publication = tds[4].content
          nature      = tds[5].content
          severity    = tds[6].content
          link        = tds[7].content
          comments    = tds[8].content
        end

        if date != ""
#          puts "////#{num}//// #{date} // #{name} // #{publication} :: #{nature} // #{severity} // #{link} // #{comments}"
          csv << [num, date, name, publication, nature, severity, link, comments]
          num += 1
        end
      end
    end
  end
end		 


