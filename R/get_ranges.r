

# Get the data
url <- "https://gis.natureserve.ca/download/EBAR_base_data_15.gdb.zip"

# Download the data
download.file(url, "./data/EBAR_base_data_15.gdb.zip")

# Unzip the data
unzip("./data/EBAR_base_data_15.gdb.zip", exdir = "./data/EBAR_base_data_15.gdb")
rm("./data/EBAR_base_data_15.gdb.zip")

# List the files
list.files("./data/EBAR_base_data_15.gdb", full.names = TRUE)


