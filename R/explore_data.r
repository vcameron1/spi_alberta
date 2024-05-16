# Read data
speciesAtRisk_path <- file.path("data_raw", "Species at Risk Range Map Extents.gdb")
speciesAtRisk <- sf::st_read(speciesAtRisk_path)

unique(speciesAtRisk$SAR_STAT_E)

#Special significance detector

#In website https://species-registry.canada.ca/index-en.html#/documents?sortBy=documentTypeSort&sortDirection=asc&pageSize=10, put english name.
#https://species-registry.canada.ca/index-en.html#/documents?sortBy=documentTypeSort&sortDirection=asc&pageSize=10&keywords= *** speciesAtRisk$COM_NAME_E[1] ***

library(rvest)
library(httr)

# creating a string variable
mystring = "Hi Theo would you like to have some cookies?"

i <- 1
x <- 1

for(i in 1:length(speciesAtRisk$COM_NAME_E)){

speciesAtRisk$COM_NAME_E <- chartr("%", "p", speciesAtRisk$COM_NAME_E[x])
  x <- x+1

}

?gsub

col = POST(url="https://species-registry.canada.ca/index-en.html#/documents?sortBy=documentTypeSort&sortDirection=asc&pageSize=10&keywords= ***  ***
",
           encode="form",
           body=list(key="Acer campestre",
                     fossil="0",
                     match="1",
                     search="Search"))
col_html = read_html(col)
col_table = html_table(col_html,fill=F)


#Select document (preferably html) that contains "COSEWIC assessment and status report on the" and *** speciesAtRisk$COM_NAME_E[1] ***

#In document, reach "Significance" section

#In section, find key words. 3 categories:
#"Mythical (Enormous cultural, ecological and economic impact such as: Caribou, Grizzly Bear, White Sturgeon), 
#Important (Model species for research and/or significant cultural and/or economic impact and/or ecological impact such as: threatened bat species  ),
#Not significan (Does not have any of the above such as Marsh Shrew)"


# Read protected area data
protectedAreas_path <- file.path("data_raw", "ProtectedConservedArea_2022.gdb")
protectedAreas <- sf::st_read(protectedAreas_path)
protectedAreas |> names()
