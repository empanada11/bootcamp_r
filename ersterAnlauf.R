setwd("/Users/milicapajkic/Documents/GitHub/bootcamp_r/Data")
library(dplyr)
df1 <- read.csv("/Users/milicapajkic/Documents/GitHub/bootcamp_r/Data/DisasterDeclarationsSummaries.csv")
df2 <- read.csv("/Users/milicapajkic/Documents/GitHub/bootcamp_r/Data/HousingAssistanceOwners.csv")

merge_1 <- full_join(df1, df2, by = "id")
df_merge <- merge(df1,df2,by="id")
df_merge3 <- na.omit(merge_1)
merge_2 <- complete.cases(merge_1)

areas_unique <- unique(df1$designatedArea)


