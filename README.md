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
source("R/get_data.R")
```

**2. Prepare, format and clean data**

```r
source("R/prep_data.R")
```

**3. Compute SPI**

```r
source("R/compute_spi.R")

# Define the species to compute SPI for
SPECIES <- c("Lotus formosissimus", "Athene cunicularia")
# Should protected areas be unioned?
UNION <- TRUE

# Run SPI computation
SPI <- run_SPI_computation(SPECIES, UNION)
```









## References
T. Rudic, K. Ingenloff, M. Rogan, Y. Sica, G. Vigneron, & D. S. Rinnan. (2021). The Species Protection Index. Map of Life. [https://storymaps.arcgis.com/stories/8223a7756fea4c6c8b93eba0ea807794](https://mol.org/indicators/protection/background)

