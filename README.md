# SPI for Alberta's at Risk Species

This repository contains the code and ressources to compute the Species Protection Index (SPI) for Alberta's at Risk Species. The SPI is a metric that quantifies the protection of species at risk in a given region. 

Species distribution maps are queried from NatureServe's API.

## Usage

Save NatureServe api key

```r
file.edit("~/.Renviron")
```

## Run computation

**1. Download data**

```r
source("R/get_data.r")
```

**2. Prepare, format and clean data**

```r
source("R/prep_data.r")

# 1. Load data
## Species maps
speciesAtRisk_path <- file.path("data_raw", "Species at Risk Range Map Extents.gdb")
speciesAtRisk <- sf::st_read(speciesAtRisk_path)
## Protected areas
protectedAreas_path <- file.path("data_raw", "ProtectedConservedArea_2022.gdb")
protectedAreas <- sf::st_read(protectedAreas_path)
## Province_boundaries
province_boundaries_path <- file.path("data_raw","lpr_000b16a_e.shp")
province_boundaries <- sf::st_read(province_boundaries_path)

# 2. Transform and crop layers to alberta
epsg = 3401
## Province boundaries
province_boundaries <- transform_projections(layer = province_boundaries, EPSG = epsg) |>
    sf::st_union()
sf::st_write(province_boundaries, file.path("data_clean", "province_boundaries.gpkg"))
## Protected areas
protectedAreas <- transform_projections(protectedAreas[1,], epsg) |>
    crop_layer("Alberta")
sf::st_write(protectedAreas, file.path("data_clean", "protectedAreas.gpkg"))
## Species at risk
# speciesAtRisk_alberta <- transform_projections(speciesAtRisk, epsg) |>
#     crop_layer("Alberta")
# sf::st_write(speciesAtRisk_alberta, file.path("data_clean", "speciesAtRisk_alberta.gpkg"))
```

**3. Compute SPI**

```r
source("R/compute_spi.r")

# Define the species to compute SPI for
COSEWICID = as.data.frame(speciesAtRisk) |>
    dplyr::filter(SAR_STAT_E %in% c("Endangered", "Threatened")) |>
    dplyr::select(COSEWICID) |>
COSEWICID <- COSEWICID[!duplicated(COSEWICID),]
# Filter protected areas
IUCN_CAT = 1:4

# Run SPI computation
SPI <- run_SPI_computation(COSEWICID, IUCN_CAT = IUCN_CAT)
```


## References
T. Rudic, K. Ingenloff, M. Rogan, Y. Sica, G. Vigneron, & D. S. Rinnan. (2021). The Species Protection Index. Map of Life. [https://mol.org/indicators/protection/background](https://mol.org/indicators/protection/background)

