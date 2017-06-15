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


#set this to your institution's longitude and lattitude to get miles between your institution and all others
longitude_compare <- -98.621386
latitude_compare <- 29.582418


#initialize variable to find all institutions within distanceFrom (miles)
data.all$distanceCalc <- 0


#rename variables for clarity
data.all <-
  rename(
    data.all,
    name = Institution.Name,
    lat = Latitude.location.of.institution..HD2015.,
    long = Longitude.location.of.institution..HD2015.,
    sector = Sector.of.institution..HD2015.,
    control = Control.of.institution..HD2015.
  )


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

str(data.all)


#loop through all universities and calculate distance between home institution and all others
#n is the main institution and q is the comparison institution



  for (q in 1:nrow(data.all))
  {
   
    #lattitude and longitude of the comparison institution
    long2 <-
      as.numeric(data.all[q, "long"])
    lat2 <-
      as.numeric(data.all[q, "lat"])
    
   
    #get the distance between utsa and comparison institution in km
    
    distance_compare <-
      acos(
        sin(latitude_compare * pi / 180) * sin(lat2 * pi / 180) + cos(latitude_compare * pi / 180) * cos(lat2 *
                                                                                                           pi / 180) * cos(long2 * pi / 180 - longitude_compare * pi / 180)
      ) * 6371
    
    
    #convert kilometers to miles
    
    distance_compare <- distance_compare * 0.621371
    

    #this is used to compare all institutions distance from home institution
    data.all[q, "Compare_Distance"] <- distance_compare
    
  }
  


write.xlsx(
  data.all,
  "OneInstitutionCompare.xlsx"
)



# load it back
wb <- loadWorkbook("OneInstitutionCompare.xlsx")
sheets <- getSheets(wb)
#  Auto Size
autoSizeColumn(sheets[[1]], colIndex=1:ncol(data.all))
saveWorkbook(wb,"OneInstitutionCompare.xlsx")




