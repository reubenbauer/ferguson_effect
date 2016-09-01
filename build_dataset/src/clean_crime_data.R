#clear workspace
rm(list=setdiff(ls(), "repository"))
gc()


library(reshape2)
library(ggplot2)
library(dplyr)
library(data.table)
library(doBy)


#reading in data
setwd("C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/build_dataset/input")
Crimes<-read.csv("Crimes_-_2001_to_present.csv", header = TRUE, stringsAsFactors = FALSE)

#Crimes <- fread("Crimes_-_2001_to_present.csv", header = TRUE, stringsAsFactors = FALSE, 
#                colClasses = c("integer", "character", "character", "character", 
#                               "character", "character", "character", "character", 
#                               "integer", "integer", "integer", "integer",
#                               "character", "integer"))

#set output directory
setwd("C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/build_dataset/output")

#clean
#select variables
names(Crimes)[names(Crimes) == "Primary.Type"]<- "crime_type"
names(Crimes)[names(Crimes) == "District"]<- "district"
names(Crimes)[names(Crimes) == "Year"]<- "year"

Crimes$temp = substr(Crimes$Date, 1, nchar(Crimes$Date) - 12)
Crimes$temp = as.Date(Crimes$temp, "%m/%d/%Y")
names(Crimes)[names(Crimes) == "temp"]<- "date1"

Crimes = select(Crimes, ID, district, year, crime_type, date1)
library(zoo)
Crimes$year_mon = as.yearmon(Crimes$date1)
  
#filter by year
#Crimes = filter(Crimes, year >= 2011)

#clean district
Crimes = filter(Crimes, !is.na(Crimes$district))

#create crimes_by_district_year
crimes_by_district_year = as.data.frame(table(Crimes$district, Crimes$year))
crimes_by_district_year = reshape(crimes_by_district_year, timevar = "Var2", idvar = "Var1", direction = "wide")
names(crimes_by_district_year)[names(crimes_by_district_year)=="Var1"]<-"district"
write.csv(crimes_by_district_year, "crimes_by_district_year.csv", row.names = FALSE)
  
#create crimes_by_type_year
crimes_by_type_year = as.data.frame(table(Crimes$crime_type, Crimes$year))
crimes_by_type_year = reshape(crimes_by_type_year, timevar = "Var2", idvar = "Var1", direction = "wide")
names(crimes_by_type_year)[names(crimes_by_type_year)=="Var1"]<-"crime_type"
write.csv(crimes_by_type_year, "crimes_by_type_year.csv", row.names = FALSE)

#create crimes_by_category_district_year
crimes_by_category_district_year = as.data.frame(count(Crimes, district, crime_type, year))
names(crimes_by_category_district_year)[names(crimes_by_category_district_year) == "n"]<-"Freq"
crimes_by_category_district_year = reshape(crimes_by_category_district_year, timevar = c("year"), idvar = c("district", "crime_type"), direction = "wide")
crimes_by_category_district_year[is.na(crimes_by_category_district_year)]<-0
write.csv(crimes_by_category_district_year, "crimes_by_category_district_year.csv", row.names = FALSE)

#select Homicide sample
Homicides = filter(Crimes, crime_type == "HOMICIDE") #select most conservative sample

#create homicides_by_district_year
homicides_by_district_year = as.data.frame(table(Homicides$district, Homicides$year))
homicides_by_district_year = reshape(homicides_by_district_year, timevar = "Var2", idvar = "Var1", direction = "wide")
names(homicides_by_district_year)[names(homicides_by_district_year)=="Var1"]<-"district"
write.csv(homicides_by_district_year, "homicides_by_district_year.csv", row.names = FALSE)

temp = crimes_by_type_year
molten = melt(temp, id = 1)
molten$year = with(molten, as.integer(substr(variable, 6, 9)))
options( scipen = 10 )
ggplot(subset(molten, crime_type == "HOMICIDE"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Homicides in Chicago by Year")
ggplot(subset(molten, crime_type == "NARCOTICS"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Narcotics Violations in Chicago by Year")
ggplot(subset(molten, crime_type == "INTERFERENCE WITH PUBLIC OFFICER"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Interferance with a Public Officer in Chicago by Year")
ggplot(subset(molten, crime_type == "ROBBERY"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Reported Robberies in Chicago by Year")
ggplot(subset(molten, crime_type == "THEFT"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Reported Thefts in Chicago by Year")
ggplot(subset(molten, crime_type == "WEAPONS VIOLATION"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Reported Weapons Violations in Chicago by Year")



#create crimes_by_type_yearmon
crimes_by_type_yearmon = as.data.frame(table(Crimes$crime_type, Crimes$year_mon))
crimes_by_type_yearmon = reshape(crimes_by_type_yearmon, timevar = "Var2", idvar = "Var1", direction = "wide")
names(crimes_by_type_yearmon)[names(crimes_by_type_yearmon)=="Var1"]<-"crime_type"

temp = crimes_by_type_yearmon
molten = melt(temp, id = 1)
molten$variable = as.character(molten$variable)
molten$year = with(molten, substr(variable, 6, nchar(variable)))
molten$year = as.yearmon(molten$year)
molten = filter(molten, year != "Aug 2016")
options( scipen = 10 )
pdf("graph1.pdf")
ggplot(subset(molten, crime_type == "HOMICIDE"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Homicides in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph2.pdf")
ggplot(subset(molten, crime_type == "NARCOTICS"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Narcotics Violations in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph3.pdf")
ggplot(subset(molten, crime_type == "INTERFERENCE WITH PUBLIC OFFICER"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Interferance with a Public Officer in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph4.pdf")
ggplot(subset(molten, crime_type == "ROBBERY"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Reported Robberies in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph5.pdf")
ggplot(subset(molten, crime_type == "THEFT"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Reported Thefts in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph6.pdf")
ggplot(subset(molten, crime_type == "WEAPONS VIOLATION"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Reported Weapons Violations in Chicago by Year Month")+ scale_x_continuous("Year Month")
dev.off()


#to make quarterly data
temp = filter(temp, temp$crime_type == "HOMICIDE" | temp$crime_type == "NARCOTICS" | temp$crime_type == "INTERFERENCE WITH PUBLIC OFFICER" | temp$crime_type == "ROBBERY" | temp$crime_type == "THEFT" | temp$crime_type == "WEAPONS VIOLATION")
molten = melt(temp, id = 1)

molten$variable = as.character(molten$variable)
molten$year = with(molten, substr(variable, 6, nchar(variable)))
molten = filter(molten, year != "Aug 2016")
molten$year = substr(molten$year, 5, 8)
molten$year = paste0(molten$year, substr(molten$variable, 6, 9))

molten$year <- gsub("Jan", "-1", molten$year)
molten$year <- gsub("Feb", "-1", molten$year)
molten$year <- gsub("Mar", "-1", molten$year)

molten$year <- gsub("Apr", "-2", molten$year)
molten$year <- gsub("May", "-2", molten$year)
molten$year <- gsub("Jun", "-2", molten$year)

molten$year <- gsub("Jul", "-3", molten$year)
molten$year <- gsub("Aug", "-3", molten$year)
molten$year <- gsub("Sep", "-3", molten$year)

molten$year <- gsub("Oct", "-4", molten$year)
molten$year <- gsub("Nov", "-4", molten$year)
molten$year <- gsub("Dec", "-4", molten$year)

molten$year = as.yearqtr(molten$year)

temp <- summaryBy(value ~ crime_type + year, FUN=c(sum), data=molten)

names(temp)[names(temp) == "value.sum"] <-"value"

#logging
temp$value = log(temp$value)

for (i in 378:5) {
  temp[i, 3] <- temp[i, 3] - temp[i - 4, 3]
}                     

molten = filter(temp, substr(year, 1, 4) != "2001")
molten = filter(molten, year != "2016 Q3")


pdf("graph1_per.pdf")
ggplot(subset(molten, crime_type == "HOMICIDE"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Homicides in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph2_per.pdf")
ggplot(subset(molten, crime_type == "NARCOTICS"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Narcotics Violations in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph3_per.pdf")
ggplot(subset(molten, crime_type == "INTERFERENCE WITH PUBLIC OFFICER"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Interferance with a Public Officer in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph4_per.pdf")
ggplot(subset(molten, crime_type == "ROBBERY"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Reported Robberies in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph5_per.pdf")
ggplot(subset(molten, crime_type == "THEFT"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Reported Thefts in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()
pdf("graph6_per.pdf")
ggplot(subset(molten, crime_type == "WEAPONS VIOLATION"), aes(x = year, y = value)) + geom_line() + geom_point() + ggtitle("Reported Weapons Violations in Chicago by Year Month") + scale_x_continuous("Year Month")
dev.off()






#Police Attempt
library(ggplot2)
library(maptools)
library(rgeos)
library(Cairo)
library(ggmap)
library(scales)
library(RColorBrewer)
set.seed(8000)

setwd("C:/Users/reubenbauer/Desktop/police_shapefiles/districts")
temp = crimes_by_category_district_year
temp = filter(temp, temp$crime_type == "HOMICIDE" | temp$crime_type == "NARCOTICS" | temp$crime_type == "INTERFERENCE WITH PUBLIC OFFICER" | temp$crime_type == "ROBBERY" | temp$crime_type == "THEFT" | temp$crime_type == "WEAPONS VIOLATION")
temp = filter(temp, temp$district != 21 & temp$district != 31 & temp$district != 23 & temp$district != 13)

molten = melt(temp, id = c(1, 2))
molten$variable = as.character(molten$variable)
molten$year = with(molten, substr(variable, 6, nchar(variable)))
molten$year = as.numeric(molten$year)
molten = filter(molten, year != 2016)
molten$value = log(molten$value)
molten = select(molten, district, crime_type, value, year)

molten<-molten[order(molten$year, molten$district, molten$crime_type),]

for (i in 1980:133) {
  molten[i, 3] <- 100 * (molten[i, 3] - molten[i - 132, 3])
}
molten = filter(molten, year > 2001)
molten$district = as.character(molten$district)
names(molten)[names(molten) == "district"]<-"id"

states.shp <- readShapeSpatial("PoliceDistrict.shp")
print(states.shp$DIST_LABEL)
#num.states<-length(states.shp$DIST_LABEL)
#mydata<-data.frame(DIST_LABEL=states.shp$DIST_LABEL, id=states.shp$DIST_NUM, prevalence=rnorm(num.states, 0, .1))
#head(mydata)
#print(mydata$id)
print(states.shp$DIST_NUM)
states.shp.f <- fortify(states.shp, region = "DIST_NUM")
class(states.shp.f)
head(states.shp.f)
colours <- c("-200" = "104E8B", "-150" = "1874CD", "-100" = "1C86EE", "-50" = "1E90FF", "0" = "FFFF00", "50" = "FF3030", "100" = "EE2C2C", "150" = "CD2626", "200" = "8B1A1A")

for (crime in sort(unique(molten$crime_type))){
  graph_data <- filter(molten, crime_type == crime)
  
  for (time in sort(unique(graph_data$year))) {
    temp_data <- filter(graph_data, year == time)
    merged_data = merge(states.shp.f, temp_data, by="id", all.x=TRUE)
    
    final.plot<-merged_data[order(merged_data$order), ] 
    final.plot$lat = final.plot$lat/100000
    final.plot$long = final.plot$long/100000
    final.plot$Y1 <- cut(final.plot$value,breaks = c(-200,-150,-100,-50,0,50,100,150,200), right = FALSE)
    A = ggplot() + geom_polygon(data = final.plot, aes(x = long, y = lat, group = group, fill = Y1), color = "black") + coord_map() + theme_nothing(legend = TRUE) + scale_fill_manual(breaks=c("[-200,-150)", "[-150,-100)", "[-100,-50)",  "[-50,0)", "[0,50)", "[50,100)",  "[100,150)", "[150,200)"), values = c("white", "darkblue", "blue", "lightblue", "lightgreen", "green", "darkgreen", "white")) + labs(title = paste("Change in", crime, time))
    print(A)
  }
}
