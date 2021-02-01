# HMDB Data Extraction
## Chemical formula, SMILES, and taxonomic representation
#### Mr. George L. Malone
#### 29<sup>th</sup> of January and 1<sup>st</sup> of February, 2021

## Contents
 0. Note
 1. Background and purpose
 2. Operations
 3. Results
 4. Conclusion

### Note

This work was produced at and for the Australian National Phenome Centre,
Murdoch University.

The scripts and operations in this repository assume a specific directory
structure, which has been partially masked or excluded when pushed to GitHub.
Notably, there are a number of references to the `./data` and `./data/hmdb_xml`
directories.  If the operations here are to be appropriately used, these
directories will need to be created.  Further, the main data source, which will
not be shown in this repository, is assumed to be present in the `./data`
directory, with the name `data_main.tsv`.


### Background and purpose

The original purpose of the work was to provide more accurate representations
of chemical formulae, given a list of HMDB IDs.  Further possibilities included
collecting additional data, such as taxonomic information, for later analysis,
including frequencies and proportions of certain taxonomic representations.

The data are provided in an XLSX spreadsheet, but were converted to TSV for
compatibility.  The data are mostly regular and error-free.  One cell was
removed as it was irregular -- it appears to be a note or other piece of
information that is not relevant to this investigation.  The main column of
interest is the chemical identifier, of which most are HMDB IDs but some
PubChem IDs are present.  PubChem IDs are ignored for the purpose of this
investigation.

The data are to be collected from HMDB with reference to the associated HMDB
ID.  HMDB does not possess an API per se, but data can be collected from the
relevant XML documents, which are provided raw via the appropriate URL.


### Operations

The operations performed are broken into a handful of stages:

 1. Extracting HMDB IDs, given a dataset of chemicals, converting to URLs for
    requesting data via `wget`, and saving the resulting URLs

 2. Requesting and saving the data provided by the URLs

 3. Finding IDs present in the data and checking for repeats, and, if any,
    checking basic measurements to assess severity / level of concern

 4. Collecting data for each chemical from the corresponding XML files,
    appending the data to (a copy of) the original input dataset, and saving
    the new dataset as a TSV


### Results

HMDB IDs were extracted successfully from the original data with no errors, and
the resulting URLs were saved to a single text file.  The URLs were then read
from this file and split into groups of 8, for multiprocess requests to `wget`,
via `xargs`.  A total of 1026 XML documents were downloaded and saved.  No
errors were apparent in this process.  The documents range in size from 8623
bytes to 8593244 bytes (UTF-8 encoded).  The total volume of the files is
91070633 bytes.  The download process was not timed.  Some files were missed
with no error in the initial download process, and a supplementary script was
run to collect the remainder of the data.

Basic testing of IDs shows that there are 1028 unique HMDB IDs found in the
data.  Two IDs are not found in HMDB or are lacking an entry -- HMDB0005790,
and HMDB0039116, hence data for these two IDs were not able to be downloaded
and stored.

Data collection from the remaining XML files was mostly successful.  Not all
XML files appear to contain all data required, but most appear to be present
and correct.  This is uncertain as the gaps in the data mostly correspond to
the entries with PubChem IDs, which were not used for data collection, but some
data such as subclass were missing for HMDB entries.


### Conclusion

The operations required were completed appropriately and successfully.
Visualisation and further numerical investigation could follow from the
resulting dataset produced.  A tree-type graph of the structure of kingdom,
superclass, class, and subclass could be produced, as well as other types of
visualisations to investigate the counts of certain related isomers.
