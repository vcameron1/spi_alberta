#==============================================================================
# Compute SPI values for species
#
# 2024-05-13
#==============================================================================

# Function to run spi computation
#
# Parameters:
# - SPECIES: A character vector specifying the species of interest.
# - UNION: A logical value indicating whether to perform a union of protected areas.
#
# Returns:
# - A dataframe with the SPI value.
#
run_SPI_computation <- function(SPECIES, UNION = FALSE){
    cat("Computing SPI for", SPECIES, "\n")

    #------------------------------------------------------------------------------
    # 1. Read data
    #------------------------------------------------------------------------------

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
run   
spi <- function(range_maps, prot_areas){    
    intersect <- suppressWarnings(sf::st_intersection(range_maps, prot_areas))
    SPA <- sf::st_area(intersect) |> as.numeric() |> suppressWarnings() |> sum()
    
    if (length(SPA) == 0 | SPA == 0) return(0)

    SPI <- SPA / sum(as.numeric(sf::st_area(range_maps)))
    
    return(SPI)
}