#!/usr/bin/env ruby

# NOTE:  This script is perhaps a bit hastily mashed together, and I did not
# have the time to neaten it up a bit more, but it functions properly in its
# current state.  It's just a bit awkward to look at in some parts.

# Pull in Nokogiri, and source required functions
require("nokogiri")
load("./getLinks_src.rb")

=begin
Plan:
- Iterate over the rows of the data
- Get the HMDB ID if present
- Check the relevant XML and return chem. formula, fam. identifiers
- Store IDs seen (with data) to avoid repeats
ALT:
- Loop over the unique IDs and get the relevant data from the XML files
- Store these in hash
- Loop over the rows of the data
- Assign the relevant data per the present ID
  - If PubChem, return nil
=end

# Helper function to extract data from the XML
def getXmlData(xml, nodes)
  # NOTE:  REQUIRES/ASSUMES NOKOGIRI, ASSUMES UNIQUENESS OF XPATH ELEMENTS
  out = Hash.new()
  nodes.each do |n|
    x = xml.at_xpath("//#{n}")
    out[n.to_sym] = ((x.nil?) ? nil : x.text)
  end
  return(out)
end

# Read and convert main data
rdata = File.read("./data/data_main.tsv")
hdata = tsvToHash(rdata, header = true)

# Get unique HMDB IDs from main data
idHmdbUniq = hdata[:identifier].select{|e| e.match?(/^HMDB/)}.uniq.sort

# Array of nodes to search under
nodes = [
  "chemical_formula",
  "smiles",
  # "description",  # NOTE:  Ignored because some of these are insanely large
  "kingdom",
  "super_class",
  "class",
  "sub_class"
]

# Initialise the ID-related data as hash
idData = Hash.new()

# Map over the unique IDs and extract the XML data, if possible, or return nil
idHmdbUniq.each do |id|
  begin
    xml = Nokogiri::XML(File.read("./data/hmdb_xml/#{id}.xml"))
    idData[id.to_sym] = getXmlData(xml, nodes)
  rescue Errno::ENOENT
    idData[id.to_sym] = nodes.map{|n| [n, nil]}.to_h
  end
end

# Initialise new headers in the main data hash
nodes.map{|n| hdata[n.to_sym] = Array.new()}

# Map over the length of the data hash rows
hdata[:id].each_index do |i|
  # Get reference data
  ref = idData[hdata[:identifier][i].to_sym]
  # Map over the data and push to the relevant header in the data hash
  nodes.map{|n| hdata[n.to_sym] << ((ref.nil?) ? nil : ref[n.to_sym])}
end

# Open a new file to write the augmented data
f = File.open("./data/data_additional.tsv", "w")

# Initialise with the header
f.write(%Q[#{hdata.keys.map{|k| k.to_s}.join("\t")}\n])

# Map over the data hash rows and write to the file
hdata[:id].each_index do |i|
  f.write(%Q[#{hdata.keys.map{|k| hdata[k][i]}.join("\t")}\n])
end

# Close the file when complete
f.close

# Operations complete
exit(0);
