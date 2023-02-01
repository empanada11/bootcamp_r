setwd("/Users/milicapajkic/Documents/GitHub/bootcamp_r/Data")
library(dplyr)
df1 <- read.csv("/Users/milicapajkic/Documents/GitHub/bootcamp_r/Data/DisasterDeclarationsSummaries.csv")
df2 <- read.csv("/Users/milicapajkic/Documents/GitHub/bootcamp_r/Data/HousingAssistanceOwners.csv")
str(df1)
str(df2)
df2$new_id <- paste(df2$disasterNumber, df2$county, sep = "")


###group by disasterid and county --> aggregate



df_merge <- merge(df1,df2,by="disasterNumber")
df_merge3 <- na.omit(df_merge)
merge_2 <- complete.cases(df_merge)

df1$designatedArea <- sub(" \\(County\\)", "", df1$designatedArea)
df1$designatedArea <- sub(" \\(Parish\\)", "", df1$designatedArea)
df1$designatedArea <- sub(" \\(Municipio\\)", "", df1$designatedArea)
df1$designatedArea <- sub("\\(.*", "", df1$designatedArea)
df1$designatedArea <- sapply(strsplit(df1$designatedArea, "\\("), function(x) x[1])
df2$county <- sub("\\(.*", "", df2$county)


areas_unique <- unique(df1$designatedArea)
areas_unique

#####################################try the wikipedia one
#install.packages('rvest')
library(rvest)
# Reading in the table from Wikipedia
page = read_html("https://en.wikipedia.org/wiki/List_of_United_States_counties_by_per_capita_income")
# Obtain the piece of the web page that corresponds to the "wikitable" node
my.table = html_node(page, ".wikitable")
# Convert the html table element into a data frame
my.table = html_table(my.table, fill = TRUE)
# Extracting and tidying a single column from the table and adding row names
x = as.numeric(gsub("\\[.*","",my.table[,4]))
names(x) = gsub("\\[.*","",my.table[,2])
# Excluding non-states and averages from the table
per.capita.income = x[!names(x) %in% c("United States", "Northern Mariana Islands", "Guam", "American Samoa", "Puerto Rico", "U.S. Virgin Islands")]


