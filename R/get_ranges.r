# Download data from ECCC website

# Species at Risk ranges
speciesAtRisk_url <- "https://data-donnees.az.ec.gc.ca/api/file?path=/species%2Fprotectrestore%2Frange-map-extents-species-at-risk-canada%2FSpecies%20at%20Risk%20Range%20Map%20Extents.gdb.zip"
dataRaw_path <- file.path("data_raw", "speciesAtRisk.zip")
download.file(speciesAtRisk_url, dataRaw_path)
unzip(dataRaw_path, exdir = "data_raw")

