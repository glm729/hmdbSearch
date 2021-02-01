#!/usr/bin/env ruby

# Load required functions
load("./getLinks_src.rb")

# Read in and convert required data
rdata = File.read("./data/data_main.tsv")
hdata = tsvToHash(rdata, header = true)
links = getHmdbLinks(hdata[:identifier].uniq.sort)

# Write the data to a main file
File.open("./data/hmdbLinks.txt", "w"){|f| f.write(links.join("\n"))}

# Operations complete
exit(0);
