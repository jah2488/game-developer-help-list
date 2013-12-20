#!/usr/bin/env ruby
require 'csv'
require 'erb'

Row = Struct.new(:twitter, :name, :tags)
data = CSV.read('./data/game-dev-list-12-17-13-14-00.csv', :headers => true)

rows = data.map { |x| x.to_hash }.map do |row|
  tag_str = row['Whatchoo good for?'] || ""
  Row.new(row['Twitter'], row['Name'], tag_str.split(",")) if row['Twitter'] || row['Name']
end.compact

namespace = Struct.new(:rows).new(rows)

HTML = ERB.new(File.read("index.html.erb")).result(namespace.instance_eval { binding })

File.open("index.html", "w+") do |f|
  f.write(HTML)
end
