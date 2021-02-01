#!/usr/bin/env ruby

# Function for grouping an array of strings by a certain delimiter, in groups
# of size `n`
def groupStr(arr, n = 8, delim = "\n")
  out = []
  sar = []
  i = 0
  while i < arr.length
    sar << arr[i]
    if sar.length == n
      out << sar.join(delim)
      sar = []
    end
    i += 1
  end
  out << sar.join(delim) if sar.length > 0
  return(out)
end

# Mostly hardcoded shorthand function for sending a shell command to collect
# the required HMDB data, multiprocess
def sendXargsCmd(str, delim = "\n", nProc = 8)
  `echo "#{str}" | xargs --delimiter="#{delim}" -n 1 -P #{nProc} wget -q`
end
