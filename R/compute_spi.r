#==============================================================================
# Compute SPI values for species
#
# 2024-05-13
#==============================================================================

# Function to run spi computation
#
# Parameters:
# - COSEWICID: A vector specifying the species of interest ID.
# - epsg: An integer specifying the EPSG code.
# - IUCN_CAT: A character vector specifying the IUCN category of the protected areas.
#
# Returns:
# - A dataframe with the SPI value.
#
run_SPI_computation <- function(COSEWICID, epsg = 3401, IUCN_CAT){
    i = 1
    for (species in COSEWICID){
        sps <- SPS(species, epsg, IUCN_CAT)
        if (i > 1) spi <- rbind(spi, sps)
        else spi <- sps

        i = i+1
    }

    out <- spi

    speciesAtRisk_raw_path <- file.path("data_raw", "Species at Risk Range Map Extents.gdb")
    speciesAtRisk <- sf::st_read(speciesAtRisk_raw_path, quiet = TRUE)

    out <- out |>
        dplyr::left_join(as.data.frame(speciesAtRisk)[,c("COSEWICID", "COM_NAME_E", "TAXON_E", "SAR_STAT_E")], by = dplyr::join_by(COSEWICID==COSEWICID)) |>
        # Rename COM_NAME_E : common_name, TAXON_E : taxon_group, SAR_STAT_E : taxon_state
        dplyr::rename(cosewic_id = COSEWICID,
                      common_name = COM_NAME_E,
                      taxon_group = TAXON_E,
                      taxon_state = SAR_STAT_E)

    return(out)
}
  

# Function to run spi computation for a single species
#
# Parameters:
# - COSEWICID: A character vector specifying a single species of interest ID.
# - epsg: An integer specifying the EPSG code.
# - IUCN_CAT: A character vector specifying the IUCN category of the protected areas.
#
# Returns:
# - A dataframe with the SPI value.
#
SPS <- function(COSEWICID, epsg = 3401, IUCN_CAT){
    cat("Computing SPI for COSEWIC id", COSEWICID, "\n")

    #------------------------------------------------------------------------------
    # 1. Read data
    #------------------------------------------------------------------------------
    source("R/prep_data.r")
    # Species distribution
        speciesAtRisk_raw_path <- file.path("data_raw", "Species at Risk Range Map Extents.gdb")
        speciesAtRisk <- sf::st_read(speciesAtRisk_raw_path, quiet = TRUE) 
        # Filter species
        species_distribution <- speciesAtRisk[speciesAtRisk$COSEWICID == COSEWICID,]
        # Transform and crop
        speciesAtRisk_alberta <- transform_projections(species_distribution, epsg) |>
            crop_layer("Alberta")

    # Protected areas
    protectedAreas_path <- file.path("data_clean", "protectedAreas.gpkg")
    if (file.exists(protectedAreas_path)) {
        protectedAreas_alberta <- sf::st_read(protectedAreas_path, quiet = TRUE) |> 
        sf::st_union()
    } else {
        protectedAreas_raw_path <- file.path("data_raw", "ProtectedConservedArea_2022.gdb")
        protectedAreas <- sf::st_read(protectedAreas_raw_path, quiet = TRUE)
        ## Filter by IUCN category
        if (!is.null(IUCN_CAT)) protectedAreas <- protectedAreas[protectedAreas$IUCN_CAT %in% IUCN_CAT,]
        protectedAreas_alberta <- transform_projections(protectedAreas, epsg) |>
            crop_layer("Alberta")
        sf::st_write(protectedAreas_alberta, protectedAreas_path)
    }

    #------------------------------------------------------------------------------
    # 2. Compute SPI
    #------------------------------------------------------------------------------    
    source("R/compute_spi_w_target.r")
    intersect <- suppressWarnings(sf::st_intersection(speciesAtRisk_alberta$Shape, protectedAreas_alberta))
    SPA <- sf::st_area(intersect) |> as.numeric() |> suppressWarnings() |> sum()

    prot_area <- as.numeric(sf::st_area(protectedAreas_alberta))

    spi <- SPI(SPA, prot_area)

    cat("SPI is", spi, "\n")

    return(data.frame(COSEWICID = COSEWICID, spi = spi, intersect_area = SPA, protected_area = prot_area))
}
