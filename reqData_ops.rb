#!/usr/bin/env ruby

# Load the required functions
load("./reqData_src.rb")

# Read in the HMDB links and group by 8, separated by a newline
links = File.read("./data/hmdbLinks.txt").split(/\n/)
linkGrp = groupStr(links, n = 8, delim = "\n")

# Switch to the data storage directory
Dir.chdir("./data/hmdb_xml")

# Map over the grouped links and send the shell commands
linkGrp.map{|l| sendXargsCmd(l, delim = "\n", nProc = 8)}
# NOTE:  Because wget is invoked with flag -q, it will silently fail due to the
# number of requests made to HMDB, that is, a number of requests will fail due
# to too many requests to HMDB.  This has the further apparent effect of some
# entries downloaded repeatedly, but this is still uncertain.

# Operations complete
exit(0);
