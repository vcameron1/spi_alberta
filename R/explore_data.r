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



#Compare SPI for protection level and Significance

library(ggplot2)


# Convert the variable dose from a numeric to a factor variable
ToothGrowth$dose <- as.factor(ToothGrowth$dose)
head(ToothGrowth)


results <- ggplot(ToothGrowth, aes(x=supp, y=len)) + 
  geom_violin()

results

