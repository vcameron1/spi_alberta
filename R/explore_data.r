# Read data
speciesAtRisk_path <- file.path("data_raw", "Species at Risk Range Map Extents.gdb")
speciesAtRisk <- sf::st_read(speciesAtRisk_path)

# Read protected area data
protectedAreas_path <- file.path("data_raw", "ProtectedConservedArea_2022.gdb")
protectedAreas <- sf::st_read(protectedAreas_path)
protectedAreas |> names()