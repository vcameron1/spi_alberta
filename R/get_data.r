#==============================================================================
# Download data
#
# 2024-05-13
#==============================================================================

# Get species at Risk ranges from Environment and Climate Change Canada
speciesAtRisk_url <- "https://data-donnees.az.ec.gc.ca/api/file?path=/species%2Fprotectrestore%2Frange-map-extents-species-at-risk-canada%2FSpecies%20at%20Risk%20Range%20Map%20Extents.gdb.zip"
dataRaw_path <- file.path("data_raw", "speciesAtRisk.zip")
download.file(speciesAtRisk_url, dataRaw_path)
unzip(dataRaw_path, exdir = "data_raw")


# Download Canada boarders shapefile from Statistics Canada
canada_url <- "https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lpr_000b16a_e.zip"
dataRaw_path <- file.path("data_raw", "canada.zip")
download.file(canada_url, dataRaw_path)
unzip(dataRaw_path, exdir = "data_raw")


# Download protected areas
protectedAreas_url <- "https://data-donnees.az.ec.gc.ca/api/file?path=/species%2Fprotectrestore%2Fcanadian-protected-conserved-areas-database%2FDatabases%2FProtectedConservedArea_2022.gdb.zip"
dataRaw_path <- file.path("data_raw", "protectedAreas.zip")
download.file(protectedAreas_url, dataRaw_path)
unzip(dataRaw_path, exdir = "data_raw")