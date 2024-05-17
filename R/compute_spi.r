#==============================================================================
# Compute SPI values for species
#
# 2024-05-13
#==============================================================================

# Function to run spi computation
#
# Parameters:
# - SPECIES: A spatial layer of range maps.
# - epsg: An integer specifying the EPSG code.
# - IUCN_CAT: A character vector specifying the IUCN category of the protected areas.
#
# Returns:
# - A dataframe with the SPI value.
#
run_SPA_computation <- function(SPECIES, epsg = 3401, IUCN_CAT){
    i = 1
    for (i in 1:nrow(SPECIES)){
        sps <- SPS(SPECIES[i,], epsg, IUCN_CAT)
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
# - SPECIES: A spatial layer for a species.
# - epsg: An integer specifying the EPSG code.
# - IUCN_CAT: A character vector specifying the IUCN category of the protected areas.
#
# Returns:
# - A dataframe with the SPI value.
#
SPS <- function(SPECIES, epsg = 3401, IUCN_CAT){
    cat("Processing COSEWIC id", SPECIES$COSEWICID, "\n")

    #------------------------------------------------------------------------------
    # 1. Read data
    #------------------------------------------------------------------------------
    source("R/prep_data.r")
    # Species distribution
    species_distribution <- SPECIES
        # Transform and crop
        speciesAtRisk_alberta <- transform_projections(species_distribution, epsg) |>
            sf::st_make_valid() |>
            crop_layer("Alberta")

        if(nrow(speciesAtRisk_alberta) == 0) {
            return(data.frame(COSEWICID = species_distribution$COSEWICID, 
                scientific_name = speciesAtRisk$SCI_NAME,
                species_protected_area = NA, 
                protected_area = NA,
                range_area_alberta = NA,
                range_area_canada = as.numeric(sf::st_area(sf::st_make_valid(species_distribution)))))
        }

    # Protected areas
    protectedAreas_path <- file.path("data_clean", "protectedAreas.gpkg")
    if (file.exists(protectedAreas_path)) {
        protectedAreas_alberta <- sf::st_read(protectedAreas_path, quiet = TRUE) |> 
        sf::st_union() |>
        sf::st_make_valid()
    } else {
        protectedAreas_raw_path <- file.path("data_raw", "ProtectedConservedArea_2022.gdb")
        protectedAreas <- sf::st_read(protectedAreas_raw_path, quiet = TRUE)
        ## Filter by IUCN category
        if (!is.null(IUCN_CAT)) protectedAreas <- protectedAreas[protectedAreas$IUCN_CAT %in% IUCN_CAT,]
        protectedAreas <- sf::st_transform(sf::st_cast(protectedAreas, "MULTIPOLYGON"), crs = epsg) |>
            sf::st_make_valid() |>
            sf::st_union()
        protectedAreas_alberta <- crop_layer(protectedAreas,"Alberta") |>
            sf::st_make_valid()
        sf::st_write(protectedAreas_alberta, protectedAreas_path)
    }

    #------------------------------------------------------------------------------
    # 2. Compute SPI
    #------------------------------------------------------------------------------    
    source("R/compute_spi_w_target.r")
    valid_sp_range <- sf::st_make_valid(speciesAtRisk_alberta$Shape)
    intersect <- suppressWarnings(sf::st_intersection(valid_sp_range, protectedAreas_alberta))
    SPA <- sf::st_area(intersect) |> as.numeric() |> suppressWarnings() |> sum()

    prot_area <- as.numeric(sf::st_area(protectedAreas_alberta))
    range_area <- as.numeric(sf::st_area(sf::st_make_valid(species_distribution)))
    range_area_alberta <- as.numeric(sf::st_area(valid_sp_range))

    # spi <- SPI(SPA, prot_area)

    # cat("SPI is", spi, "\n")

    return(data.frame(COSEWICID = COSEWICID, 
        scientific_name = speciesAtRisk_alberta$SCI_NAME,
        species_protected_area = SPA, 
        protected_area = prot_area,
        range_area_alberta = range_area_alberta,
        range_area_canada = range_area))
}
