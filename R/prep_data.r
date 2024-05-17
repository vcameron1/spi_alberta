#==============================================================================
# Prep data for SPI computation
#
# Victor Cameron
# 2024-05-13
#==============================================================================

# Function to transform the projection of the data
#
# Parameters:
# - layer: A spatial object.
# - EPSG: An integer specifying the EPSG code.
# - WKT: A character string specifying the WKT projection.
#
transform_projections <- function(layer, EPSG = 3401, WKT = NULL){

    # Check if the layer is an sf object
    if (!inherits(layer, "sf")) stop("The layer must be an sf object.")

    # Check if the layer is of the right epsg
    if (sf::st_crs(layer)$epsg != EPSG | is.na(sf::st_crs(layer)$epsg)){
        if (is.null(WKT)){
            layer <- sf::st_transform(layer, crs = EPSG)
        } else {
            layer <- sf::st_transform(layer, crs = WKT)
        }
    }

    return(layer)
}


# Function to crop maps to the desired extent
#
# Parameters:
# - layer: A spatial object.
# - province: A character string specifying the province to crop the data to.
#
crop_layer <- function(layer, province = "Alberta"){

    # Check if the layer is an sf object
    # if (!inherits(layer, "sf")) stop("The layer must be an sf object.")

    # Read the province boundaries
    province_path <- file.path("data_clean", "province_boundaries.gpkg")
    if (file.exists(province_path)){
        province_boundaries <- sf::st_read(province_path, quiet = TRUE)
    } else {
        # Read the province boundaries
        province_boundaries <- sf::st_read(file.path("data_raw","lpr_000b16a_e.shp"), quiet = TRUE) |> 
            dplyr::filter(PRENAME == province) |>
            transform_projections(EPSG = 3401) |>
            sf::st_union()
        # Save the province boundaries
        sf::st_write(province_boundaries, province_path)
    }

    # Crop the layer
    layer <- sf::st_intersection(layer, province_boundaries)

    return(layer)
}
