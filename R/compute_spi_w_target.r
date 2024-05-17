#==============================================================================
# SPI function v.2
# KWT
# 2024-05-17
#==============================================================================
# PURPOSE
# 
# This function calculates SPI. It calculates and returns a species specific area
# target as a function of its range. This is calculated as referenced in 
# The Species Protection Index: Measuring progress toward comprehensive biodiversity
# conservation. Map of Life. September 24, 2021. https://mol.org/indicators/protection/background
#
# INPUTS
#
# protected_m2: A numeric value specifying the area of the species range that is protected.
# range_m2: A numeric value specifying the total area in Canada of the species range.
#
# =============================================================================

SPI <- function(protected_m2, range_provincial_m2, range_m2) {
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
  if (range_m2 < A_min) {
    ratio_sp <- 1
  } else if (range_m2 >= A_max) {
    ratio_sp <- 0.15
  } else {
    ratio_sp <- b0 + b1*log10(range_m2)
  }
  # calculate & return SPI
  
  result <- protected_m2 / (ratio_sp*range_provincial_m2)
  return(result)
}


