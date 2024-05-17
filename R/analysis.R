# Dependancies ------------------------------------------------------------
library(tidyverse)

# Import Data -------------------------------------------------------------
df <- read_csv("data_static/100_SPI_AB_data_calculated.csv")



# Taxonomic Statistics ----------------------------------------------------

df_taxon <- df %>% group_by(TAXON_E) %>%
  summarise(mean_taxon=mean(SPI_max))
df_taxon


# Graphic 1 ---------------------------------------------------------------

ggplot(df, aes(y=SPI_max)) +
  geom_violin(aes(x=TAXON_E))





library(viridisLite)
