#!/usr/bin/env ruby

=begin

This script is essentially for a bit of debugging or investigation into
repeated IDs and missing data.  It is not particularly regular or clean, and
not necessarily intended to be flexible or transferable.  It is essentially a
record of a couple of investigations performed to try to diagnose the missing
data, which was later found to be due to silent failures in the wget calls.

=end

# Load required functions
load("./getLinks_src.rb")

# Helper function
def getFilenames(dir)
  return(Dir.entries(dir).reject{|e| e.match?(/^\.\.?$/)})
end

# Read in required data and convert to required formats
rdata = File.read("./data/data_main.tsv")
hdata = tsvToHash(rdata, header = true)
links = getHmdbLinks(hdata[:identifier].sort)

# Get some details about the XML files collected
xmlNames = getFilenames("./data/hmdb_xml")
xmlSub = xmlNames.map{|x| x.gsub(/\.\d+$/, '')}.uniq

# xmlNames contains purely unique names, due to the xargs/wget storage method.
# xmlSub contains unique entries after stripping tagged repeats.

print([
  "Number of files:  #{xmlNames.length}\n",
  "Number of unique HMDB IDs:  #{xmlSub.length}\n",
  "Diff:  #{xmlNames.length - xmlSub.length}\n",
].join(''))

# Checking the original file for number of HMDB IDs
rows = hdata[:identifier]
rowsHmdb = hdata[:identifier].select{|e| e.match?(/^HMDB/)}

print([
  "Number of rows in original data:  #{rows.length}\n",
  "Number of HMDB IDs:  #{rowsHmdb.length}\n",
  "Number of unique HMDB IDs:  #{rowsHmdb.uniq.length}\n"
].join(''))

# Checking uniqueness of IDs

def countId(within, id)
  i = 0
  within.each{|w| i += 1 if w == id}
  return(i)
end

counts = rowsHmdb.map{|id| [id, countId(rowsHmdb, id)]}
gt1 = counts.select{|e| e[1] > 1}
gt1.map{|g| print(%Q[ID reported > 1:  #{g[0]}  #{g[1]}\n])}
