setwd("/Users/milicapajkic/Documents/GitHub/bootcamp_r/Data")

library(dplyr)
library(tidyr)
library(tidyverse)
library(rvest)
library(readxl)


##EINLESEN
df1 <- read.csv("/Users/milicapajkic/Documents/GitHub/bootcamp_r/Data/DisasterDeclarationsSummaries.csv")
df2 <- read.csv("/Users/milicapajkic/Documents/GitHub/bootcamp_r/Data/HousingAssistanceOwners.csv")
UScounties <- read_excel("~/switchdrive/R-bootcamp/UScounties.xlsx")

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

my.table <- my.table %>% 
  rename(
    county = `County or county-equivalent`
  )

#umbenen
df1$designatedArea <- sub("\\(.*", "", df1$designatedArea)
df2$county <- sub("\\(.*", "", df2$county)
UScounties$county <- sub("\\(.*", "", UScounties$county)

str(df1)
str(df2)

#df2_unique <- df2 %>% distinct(disasterNumber,.keep_all = TRUE)

# merge <- full_join(x = df1, y = df2, by = c('designatedArea' = 'county', 'disasterNumber' = 'disasterNumber'))
# 
# merge_id <- full_join(x = df1, y = df2, by = c('disasterNumber' = 'disasterNumber'))
# merge_na <- merge_id[!with(merge_id,is.na("totalMaxGrants")& is.na("repairReplaceAmount")),]
# 
# merge_na <- merge_id
# 
# merge_neu <- merge_na %>%
#   filter(!if_all(c(totalMaxGrants, repairReplaceAmount), is.na))
# summary(merge_neu)
# 
# merge_neuee <- merge_neu %>% drop_na()
# 
# summary(merge_neuee)
# 
# row.has.na <- apply(merge_na, 1, function(x){any(is.na(x))})
# sum(row.has.na)
# final.filtered <- merge_na[!row.has.na,]
# row.has.na1 <- apply(final.filtered, 1, function(x){any(is.na(x))})
# sum(row.has.na1)



merge_i <- inner_join(x = df1, y = df2, 
                      by = c('designatedArea' = 'county', 'disasterNumber' = 'disasterNumber'))

# row.has.na <- apply(merge_i, 1, function(x){any(is.na(x))})
# final.filtered <- merge_i[!row.has.na,]

#merge_i verkleinern
merge_unique <- merge_i %>% distinct(disasterNumber,.keep_all = TRUE)
merge_unique

merge_i %>% 
  select(designatedArea, zipCode, state.x) %>% 
  as_tibble()

UScounties %>% 
  select(county, county_ascii, state_id) %>% 
  as_tibble()


library(stringr)
merge_i$designatedArea <- str_remove(string = merge_i$designatedArea, pattern = " +$")
#str_extract(string = , pattern = "")

###left join
merge_county <- left_join(x = merge_unique, y = UScounties, by = c('designatedArea' = 'county', "state.x" = "state_id"))
###left join
merge_capita <- left_join(x = merge_county, y = my.table, by = c('designatedArea' = 'county'))



sum( is.na( merge_i ) ) > 0
merge_i[rowSums(is.na(merge_i))==0,]

