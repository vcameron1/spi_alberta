#==============================================================================
# SPI conservation target function
# KWT
# 2024-05-13
#==============================================================================
# function to be incorporated into the SPI calculation
# =====
# Species specific protection target is a non-linear function of range size


targetSPI <- function(range_m2) {
  # fixed parameters
  A_min <- 10000*10^6
  A_max <- 250000*10^6
  SPI_min <- 1
  SPI_max <- 0.15

  # derive log-normal model between A_min and A_max
  b1 <- (SPI_max-SPI_min)/(log10(A_max)-log10(A_min))
  b0 <- SPI_min - b1*A_min
  
  # calculate
  if (range_m2 < A_min) {
    return(1)
  } else if (range_m2 >= A_max) {
    return(0.15)
  } else {
    return(b0+b1*log10(range_m2))
  }
}

