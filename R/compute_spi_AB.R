# -------------------------------------------------------------------------
# ADD SPI Calculation to SPI_data_AB.csv
# -------------------------------------------------------------------------

# Dependancies ------------------------------------------------------------
library(dplyr)
library(readr)
# Import ------------------------------------------------------------------

SPI_data_in <- read_csv("data_static/020_SPI_AB_data.csv")
str(SPI_data_in)

# SPI Function-----------------------------------------------------------

SPI <- Vectorize(function(area_in_CA_m2, area_in_AB_m2, area_in_PA_m2) {
  # fixed parameters
  A_min <- 10000*10^6
  A_max <- 250000*10^6
  ratio_min <- 1
  ratio_max <- 0.15
  ratio_sp <- as.numeric()
  SPI <- as.numeric()

  # derive log-normal model between A_min and A_max
  b1 <- (ratio_max-ratio_min)/(log10(A_max)-log10(A_min))
  b0 <- ratio_min - b1*log10(A_min)
  
  # determine correct ratio by range area in m^2
  if (area_in_CA_m2 < A_min) {
    ratio_sp <- 1
  } else if (area_in_CA_m2 >= A_max) {
    ratio_sp <- 0.15
  } else {
    ratio_sp <- b0 + b1*log10(area_in_CA_m2)
  }
  # calculate & return SPI
  
  result <- area_in_PA_m2 / (ratio_sp*area_in_AB_m2)
  return(result)
})


# Calculate SPI

SPI_data_out <- SPI_data_in %>%
  mutate(SPI=SPI(area_in_CA_m2, area_in_AB_m2, area_in_PA_m2))


# Export

write_csv(SPI_data_out,"data_static/100_SPI_AB_data_calculated.csv")
View(SPI_data_out)


