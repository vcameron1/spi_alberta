library(sf)
library(dplyr)
library(readr)

gdb_path <- "data_raw/Species at Risk Range Map Extents.gdb"

gdb <- st_read(gdb_path, layer = "SpeciesAtRiskRangeMapExtents") %>%
  as_tibble() %>%
  select(-(Shape_STArea__:last_col()))

gdb[] <- lapply(gdb, function(x) {
  if (is.character(x)) iconv(x, from = "UTF-8", to = "ISO-8859-1")
  else x
})

# Export the data table to a CSV file
write_csv(gdb, "data_clean/SpeciesAtRiskRangeMapExtents.csv")
