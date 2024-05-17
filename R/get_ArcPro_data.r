# -------------------------------------------------------------------------
# NAME:     get_ArcPro_data.r
# PURPOSE:  Retrieves the csv intersected in ArcPro and summarised by species
#           then exports the data to data_clean
# AUTHOR:   KWT
# CREATED:  2024-05-17
# -------------------------------------------------------------------------
# Dependancies ------------------------------------------------------------

library(dplyr)
library(readr)

# Import and summarise --------------------------------------------------------------

SPI_data <- read_csv("data_static/010_SPI_AB_data_from_ArcPro.csv", na="NULL") %>%
  select(-PA_Name,-DataSource) %>%
  
  group_by(across(COSEWICID:area_in_AB_m2)) %>%
  summarise(area_in_PA_type_m2=sum(area_in_PA_m2)) %>%
  as_tibble()

# Export

write_csv(SPI_data,"data_clean/020_SPI_AB_data.csv")
