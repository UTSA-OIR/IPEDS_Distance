# Keywords: IPEDS Data, latitude, longitude, distance compare
# Description: this code will calculate distances between all universities in the IPEDS download file (see csv) and set counters for those within 60 miles
# When was it last updated?: 5/25/2017

#install.packages('dplyr')
#install.packages('xlsx')
library(dplyr)
library(xlsx)

#set working directory to where the file was downloaded

setwd("C:/ipedsDistance")

#read in file to data frame
data.all <- data.frame()
data.all <- read.csv("IPEDS_data.csv")

#set this variable to distance in miles you want to count then create variable name to match miles from
distanceFrom <- 60
LT_Miles<-paste("Inst_LT_",distanceFrom,"_Miles",sep = "")
LT_Miles_pub4<-paste("Inst_LT_",distanceFrom,"_Miles_pub4",sep = "")
LT_Miles_pub2<-paste("Inst_LT_",distanceFrom,"_Miles_pub2",sep = "")


#initialize variables to 0
data.all[, LT_Miles] <- 0
data.all[, LT_Miles_pub4] <- 0
data.all[, LT_Miles_pub2] <- 0

#set this to your institution's longitude and lattitude to get miles between your institution and all others
longitude_compare <- -98.621386
latitude_compare <- 29.582418


#rename variables for clarity
data.all <-
  rename(
    data.all,
    street=Street.address.or.post.office.box..HD2015.,
    city=City.location.of.institution..HD2015.,
    state=State.abbreviation..HD2015.,
    state_fips=FIPS.state.code..HD2015.,
    zip=ZIP.code..HD2015.,
    name = Institution.Name,
    lat = Latitude.location.of.institution..HD2015.,
    long = Longitude.location.of.institution..HD2015.,
    sector = Sector.of.institution..HD2015.
  )

str(data.all)



#loop through all universities and calculate distance between home institution and all others
#n is the main institution and q is the comparison institution





for (n in 1:nrow(data.all))
{
  
  #lattitude and longitude of the original institution
  long1 <-
    as.numeric(data.all[n, "long"])
  lat1 <-
    as.numeric(data.all[n, "lat"])
  
  for (q in 1:nrow(data.all))
  {
    #skip to next loop if n==q (this would be the same institution)
    if (n == q) {
      next
    }
    
    #lattitude and longitude of the comparison institution
    long2 <-
      as.numeric(data.all[q, "long"])
    lat2 <-
      as.numeric(data.all[q, "lat"])
    
    #get the distance between original at row 'n' and comparison institution at row 'q' in km
    
    
    distance <-
      acos(
        sin(lat1 * pi / 180) * sin(lat2 * pi / 180) + cos(lat1 * pi / 180) * cos(lat2 *
                                                                                   pi / 180) * cos(long2 * pi / 180 - long1 * pi / 180)
      ) * 6371
    
    distance <- distance * 0.621371
    
    
    #get the distance between utsa and comparison institution in km
    
    distance_compare <-
      acos(
        sin(latitude_compare * pi / 180) * sin(lat2 * pi / 180) + cos(latitude_compare * pi / 180) * cos(lat2 *
                                                                                                           pi / 180) * cos(long2 * pi / 180 - longitude_compare * pi / 180)
      ) * 6371
    
    
    #convert kilometers to miles
    
    distance_compare <- distance_compare * 0.621371
    
    #when distance is not null and the institution 'n' is not the same as 'q' then use distance
    
    if (!is.na(distance))
      data.all[n, LT_Miles] <-
      data.all[n, LT_Miles] + ifelse(distance <= distanceFrom, 1, 0)
    
    
    
    
    if (!is.na(distance) & data.all[q,"sector"]==1)
      data.all[n, LT_Miles_pub4] <-
      data.all[n, LT_Miles_pub4] + ifelse(distance <= distanceFrom, 1, 0)
    
    
    
    
    if (!is.na(distance) & data.all[q,"sector"]==4)
      data.all[n, LT_Miles_pub2] <-
      data.all[n, LT_Miles_pub2] + ifelse(distance <= distanceFrom, 1, 0)
    
    
    
    
    
    #this is used to compare all institutions distance from home institution
    data.all[q, "Compare_Distance"] <- distance_compare
    
  }
  
}


#specify value labels for sector
data.all$sector <- factor(
  data.all$sector,
  levels = c(1, 2, 3, 4, 5, 6),
  labels = c(
    "Public, 4-year or above",
    "Private not-for-profit, 4-year or above",
    "Private for-profit, 4-year or above"
    ,
    "Public, 2-year",
    "Private not-for-profit, 2-year",
    "Private for-profit, 2-year"
  )
)




#write full spreadsheet to working directory
write.xlsx(
  data.all,
  "mydata_2_4_yr_tx.xlsx", row.names = FALSE
)





# load it back
wb <- loadWorkbook("mydata_2_4_yr.xlsx")
sheets <- getSheets(wb)
#  Auto Size
autoSizeColumn(sheets[[1]], colIndex=1:ncol(data.all))
saveWorkbook(wb,"mydata_2_4_yr.xlsx")

