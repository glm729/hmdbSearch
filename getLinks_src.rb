#!/usr/bin/env ruby

# Function for getting an array of dummy variable names, appropriately padded
def emptyHeader(len)
  return((0...len).map{|i| %Q[v#{i.rjust(len.to_s.length, "0")}]})
end

# Function for getting the header row from the data, if any, or otherwise
# assigning a dummy header of the appropriate length
def getHeader(data, header = true)
  return(data.shift.map{|e| e.gsub(/\W/, "_")}) if header
  return(emptyHeader(data[0].length))
end

# Function for converting a raw TSV document into a Ruby Hash object
def tsvToHash(raw, header = true)
  neat = raw.gsub(/\r/, '').gsub(/\n$/, '').split(/\n/).map{|e| e.split(/\t/)}
  head = getHeader(neat, header)
  result = Hash.new()
  head.each_with_index do |h, i|
    result[h.to_sym] = Array.new()
    neat.map{|s| result[h.to_sym] << s[i]}
  end
  return(result)
end

# Function for producing an array of HMDB URLs for XML data, given an array of
# HMDB IDs
def getHmdbLinks(ident)
  return(ident.map{|e| %Q[https://hmdb.ca/metabolites/#{e}.xml]})
end
