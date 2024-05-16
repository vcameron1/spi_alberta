#==============================================================================
# Compute SPI values for species
#
# 2024-05-13
#==============================================================================

# Function to run spi computation
#
# Parameters:
# - SPECIES: A vector specifying the species of interest.
# - UNION: A logical value indicating whether to perform a union of protected areas.
#
# Returns:
# - A dataframe with the SPI value.
#
run_SPI_computation <- function(SPECIES, UNION = FALSE){
    species_spi <- c()
    for (SPECIES in SCI_NAME){
        SPI <- c(species_spi, SPS(SPECIES, UNION))
    }

    out <- data.frame(scientific_name = SPECIES, spi_value = species_spi, union = UNION)
    return(out)
}
  

# Function to run spi computation for a single species
#
# Parameters:
# - SCI_NAME: A character vector specifying the species of interest.
# - UNION: A logical value indicating whether to perform a union of protected areas.
#
# Returns:
# - A dataframe with the SPI value.
#
SPS <- function(SCI_NAME, UNION = FALSE){
    cat("Computing SPI for", SPECIES, "\n")

    #------------------------------------------------------------------------------
    # 1. Read data
    #------------------------------------------------------------------------------
    # Species distribution
    speciesAtRisk_path <- file.path("data_raw", "Species at Risk Range Map Extents.gdb")
    speciesAtRisk <- sf::st_read(speciesAtRisk_path)

    # Protected areas
    protectedAreas_path <- file.path("data_raw", "ProtectedConservedArea_2022.gdb")
    protectedAreas <- sf::st_read(protectedAreas_path)


    #------------------------------------------------------------------------------
    # 2. Prep data
    #------------------------------------------------------------------------------
    # Filter species
    species_distribution <- speciesAtRisk |> dplyr::filter(SCI_NAME == SCI_NAME)

    # Union of protected areas ?
    if (UNION) protectedAreas <- protectedAreas |> st_union() |> st_as_sf() |> suppressWarnings()


    #------------------------------------------------------------------------------
    # 2. Compute SPI
    #------------------------------------------------------------------------------    
    spi <- spi(occurences_sp, protectedAreas)

    cat("SPI for", SCI_NAME, "is", spi, "\n")

    return(spi)
}


# Helper function to compute SPI
#
# Parameters:
# - range_maps: sf objet with the range maps of the species.
# - prot_areas: sf object with the protected areas.
#
# Returns:
# - A SPI value.
#
spi <- function(range_maps, prot_areas){    
    intersect <- suppressWarnings(sf::st_intersection(range_maps, prot_areas))
    SPA <- sf::st_area(intersect) |> as.numeric() |> suppressWarnings() |> sum()
    
    if (length(SPA) == 0 | SPA == 0) return(0)

    SPI <- SPA / sum(as.numeric(sf::st_area(range_maps)))
    
    return(SPI)
}