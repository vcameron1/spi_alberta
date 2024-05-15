# Read data
speciesAtRisk_path <- file.path("data_raw", "Species at Risk Range Map Extents.gdb")
speciesAtRisk <- sf::st_read(speciesAtRisk_path)