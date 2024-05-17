library(rvest)
library(httr)
library(stringr)
library(qdap)
library(roperators) 

# Read data
speciesAtRisk_path <- file.path("data_raw", "Species at Risk Range Map Extents.gdb")
speciesAtRisk <- sf::st_read(speciesAtRisk_path)
total <- length(speciesAtRisk$COM_NAME_E)

#Special significance detector


#Creating usuable species names



for (i in 1:length(speciesAtRisk$COM_NAME_E)){
  
  speciesAtRisk$COM_NAME_E[i] <- bracketX(speciesAtRisk$COM_NAME_E[i], "round")
  speciesAtRisk$COM_NAME_E[i] <- str_replace_all(speciesAtRisk$COM_NAME_E[i], "–", "%20") #WEIRD HYPHEN
  speciesAtRisk$COM_NAME_E[i] <- str_replace_all(speciesAtRisk$COM_NAME_E[i], " ", "%20")
  
}

#Create website adress to find each species annual report

website <- c(seq(1:length(speciesAtRisk$COM_NAME_E))) 

for (i in 1:total){
  website[i] <- paste0("https://species-registry.canada.ca/index-en.html#/documents?sortBy=documentTypeSort&sortDirection=asc&pageSize=10&keywords=",speciesAtRisk$COM_NAME_E[i])

}

speciesAtRisk$Websites <- website


#Classify at-risk species by cultural importance

cultural_significance <- c(seq(1:total))

for(i in 1:length(speciesAtRisk$COM_NAME_E)){

  
# 1. Select and open good document (most recent COSEWIC Assesment and Status report)
col = GET(url=speciesAtRisk$websites[i])
search_page = read_html(col)

search_page %>%
  html_elements(css = "")

#2. Find key words in "Species Significance" section, or equivalent. Crashtest to if not accessible, access Table of contents)

#3. Assign a category for each species based on species significance assessment

}

speciesAtRisk$Significance <- cultural_significance





#In section, find key words. 3 categories:
#"Mythical (Enormous cultural, ecological and economic impact such as: Caribou, Grizzly Bear, White Sturgeon), 
#Important (Model species for research and/or significant cultural and/or economic impact and/or ecological impact such as: threatened bat species  ),
#Not significan (Does not have any of the above such as Marsh Shrew)"


# Read protected area data
protectedAreas_path <- file.path("data_raw", "ProtectedConservedArea_2022.gdb")
protectedAreas <- sf::st_read(protectedAreas_path)
protectedAreas |> names()



#Plot SPI for protection level and Significance

library(ggplot2)
library(readr)
library(viridisLite)
library(dplyr)

X100_SPI_AB_data_calculated <- read_csv("data_static/100_SPI_AB_data_calculated.csv") %>%
  mutate(THREATS = ifelse(THREATS == "Invasive & other Problematic Species, Genes & Diseases",
         "Invasive Species and Disease", THREATS))



# Convert the variable dose from a numeric to a factor variable
X100_SPI_AB_data_calculated$SIGNIFICANCE <- as.factor(X100_SPI_AB_data_calculated$SIGNIFICANCE)
head(X100_SPI_AB_data_calculated)


#Significance
results_significance <- ggplot(X100_SPI_AB_data_calculated, aes(x=SIGNIFICANCE, y=SPI_max)) + 
  geom_violin( aes(fill = SIGNIFICANCE), alpha = 0.5,) +
  stat_summary(fun = "mean",
               geom = "crossbar", 
               width = 0.5,
               colour = "black") +
  theme_classic()

results_significance + 
  ggtitle("SPI for cultural significance") + 
  theme(legend.position="none") +
  scale_x_discrete(breaks=c("1", "2", "3"),
                   labels=c("Very significant", "Significant", "Non-significant")) +
  theme(axis.title.x = element_blank())
  


#Threats
results_threats <- ggplot(X100_SPI_AB_data_calculated, aes(x=THREATS, y=SPI_max)) + 
  geom_violin( aes(fill = THREATS), alpha = 0.5,) +
  theme(legend.text = element_text(colour="black", size = 8, face = "plain")) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  stat_summary(fun = "mean",
               geom = "crossbar", 
               width = 0.4,
               colour = "black") +
  theme_classic()

  results_threats + ggtitle("SPI per threat types") +
  scale_x_discrete(breaks=NULL)


#Status
results_status <- ggplot(X100_SPI_AB_data_calculated, aes(x=SAR_STAT_E, y=SPI_max)) + 
  geom_violin( aes(fill = SAR_STAT_E), alpha = 0.5,) +
  theme(legend.text = element_text(colour="black", size = 8, face = "plain")) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  stat_summary(fun = "mean",
               geom = "crossbar", 
               width = 0.5,
               colour = "black") +
  theme_classic()

results_status + ggtitle("SPI per status") + 
  theme(legend.position="none") +
  scale_x_discrete(limits=c("Endangered","Threatened","Special Concern")) +
  theme(axis.title.x = element_blank())


#Taxon
results_threats <- ggplot(X100_SPI_AB_data_calculated, aes(x=TAXON_E, y=SPI_max)) + 
  geom_violin( aes(fill = TAXON_E), alpha = 0.5,) +
  theme(legend.text = element_text(colour="black", size = 8, face = "plain")) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  stat_summary(fun = "mean",
               geom = "crossbar", 
               width = 0.5,
               colour = "black") +
  theme_classic()

  results_threats + ggtitle("SPI per taxon") +
  scale_x_discrete(breaks=NULL)

