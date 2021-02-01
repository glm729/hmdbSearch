#!/usr/bin/env ruby

# Repairing the missing values from the data acquisition

# Load required functions
load("./getLinks_src.rb")
load("./reqData_src.rb")

# Helper function to find which files are present
def checkPresent(dir)
  return(Dir.entries(dir).reject{|e| e.match?(/^\.\.?$/)})
end

# -----------------------------------------------------------------------------

# Find those present and reduce to unique, non-repeat downloads
present = checkPresent("./data/hmdb_xml")
clean = present.map{|e| e.gsub(/\.xml(\.\d+)?$/, '')}.uniq

# Read in the main data
rdata = File.read("./data/data_main.tsv")
hdata = tsvToHash(rdata, header = true)

# Get the unique HMDB IDs from the main data
id = hdata[:identifier].uniq.select{|e| e.match?(/^HMDB/)}

# Get the IDs that were missed and convert to HMDB URLs
idMissed = id.reject{|e| clean.include?(e)}.map{|e|
  %Q[https://hmdb.ca/metabolites/#{e}.xml]
}

# Bit of output to debug/check
print(%Q[#{idMissed.join("\n")}\n])

# Switch to the data storage directory
Dir.chdir("./data/hmdb_xml")

# Retrieve the missing data
groupStr(idMissed, n = 8, delim = "\n").map{|e|
  sendXargsCmd(e, delim = "\n", nProc = 8)
}
# NOTE:
# Two cannot be collected as they do not exist in HMDB; HMDB0005790, and
# HMDB0039116
