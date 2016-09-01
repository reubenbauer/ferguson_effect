#clear workspace
rm(list=setdiff(ls(), "repository"))
gc()

#reading in data
setwd("C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/build_dataset/temp")
for (file in list.files(getwd())) {
  assign(file, read.csv(file, header = TRUE, stringsAsFactors = FALSE))
}

#set output directory
setwd("C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/build_dataset/output")

#create data_by_district_year
complaints_by_district_year.csv <- reshape(complaints_by_district_year.csv, varying = c("Freq.2011", "Freq.2012", "Freq.2013", "Freq.2014", "Freq.2015"), v.names = "Complaints", timevar = "Year", direction = "long")
complaints_by_district_year.csv <- select(complaints_by_district_year.csv, district, Year, Complaints)
crimes_by_district_year.csv     <- reshape(crimes_by_district_year.csv, varying = c("Freq.2002", "Freq.2003", "Freq.2004", "Freq.2005", "Freq.2006", "Freq.2007", "Freq.2008", "Freq.2009", "Freq.2010", "Freq.2011", "Freq.2012", "Freq.2013", "Freq.2014", "Freq.2015"), v.names = "Crimes", timevar = "Year", direction = "long")
crimes_by_district_year.csv     <- select(crimes_by_district_year.csv, district, Year, Crimes)
data_by_district_year           <- merge(complaints_by_district_year.csv, crimes_by_district_year.csv, by = c("district", "Year"), all = "TRUE")
data_by_district_year           <- arrange(data_by_district_year, district, Year)
rm(complaints_by_district_year.csv, crimes_by_district_year.csv)

#create data_by_district_year
complaints_by_district_year.csv <- reshape(complaints_by_district_year.csv, varying = c("Freq.2011", "Freq.2012", "Freq.2013", "Freq.2014", "Freq.2015"), v.names = "Complaints", timevar = "Year", direction = "long")
complaints_by_district_year.csv <- select(complaints_by_district_year.csv, district, Year, Complaints)
crimes_by_district_year.csv     <- reshape(crimes_by_district_year.csv, varying = c("Freq.2002", "Freq.2003", "Freq.2004", "Freq.2005", "Freq.2006", "Freq.2007", "Freq.2008", "Freq.2009", "Freq.2010", "Freq.2011", "Freq.2012", "Freq.2013", "Freq.2014", "Freq.2015"), v.names = "Crimes", timevar = "Year", direction = "long")
crimes_by_district_year.csv     <- select(crimes_by_district_year.csv, district, Year, Crimes)
data_by_district_year           <- merge(complaints_by_district_year.csv, crimes_by_district_year.csv, by = c("district", "Year"), all = "TRUE")
data_by_district_year           <- arrange(data_by_district_year, district, Year)
rm(complaints_by_district_year.csv, crimes_by_district_year.csv)