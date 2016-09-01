#clear workspace
rm(list=setdiff(ls(), "repository"))
gc()

#read in data
setwd("C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/build_dataset/input")
complaints = read.csv("raw_allegations.csv", header = TRUE, stringsAsFactors = FALSE)

#set output directory
setwd("C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/build_dataset/output")

#select variables
complaints = select(complaints, crid, category, beat, incident_date)
complaints = filter(complaints, !is.na(category) & !is.na(beat) &!is.na(incident_date))
complaints = filter(complaints, !duplicated(crid))
  
#remove unneeded complaint types
non_needed_complaints = c("Alcohol Abuse", "Conduct Unbecoming (Off-duty)", "Drug/Substance Abuse", "Traffic", "Unknown") #better to do this by allegation name than complaint type
complaints = filter(complaints, !(category %in% non_needed_complaints))
rm(non_needed_complaints)
  
#clean district
complaints$beat = as.character(complaints$beat)
complaints[nchar(complaints$beat) == 3,]$beat = paste0(0, complaints[nchar(complaints$beat) == 3,]$beat) #fix deletion of leading zeros by excel
complaints$district = substr(complaints$beat, 1, 2) #district is given by the first two digits of the beat. the district lines have changed over time. I need to look up exactly when districts 13, 21, and 23 removed and why districts 31 and 41 exist.
  
#clean incidient date
complaints$incident_date = substr(complaints$incident_date, 1, 10) # remove hours
temp = colsplit(complaints$incident_date, "-", names = c("year", "day", "month"))
complaints = cbind(complaints, temp)
rm(temp)
  
#create complaints_by_district_year
complaints_by_district_year = as.data.frame(table(complaints$district, complaints$year))
complaints_by_district_year = reshape(complaints_by_district_year, timevar = "Var2", idvar = "Var1", direction = "wide")
names(complaints_by_district_year)[names(complaints_by_district_year)=="Var1"]<-"district"
write.csv(complaints_by_district_year, "complaints_by_district_year.csv", row.names = FALSE)

#create complaints_by_category_year
complaints_by_category_year = as.data.frame(table(complaints$category, complaints$year))
complaints_by_category_year = reshape(complaints_by_category_year, timevar = "Var2", idvar = "Var1", direction = "wide")
names(complaints_by_category_year)[names(complaints_by_category_year)=="Var1"]<-"category"
write.csv(complaints_by_category_year, "complaints_by_category_year.csv", row.names = FALSE)

#create complaints_by_category_district_year
complaints_by_category_district_year = as.data.frame(count(complaints, district, category, year))
names(complaints_by_category_district_year)[names(complaints_by_category_district_year) == "n"]<-"Freq"
complaints_by_category_district_year = reshape(complaints_by_category_district_year, timevar = c("year"), idvar = c("district", "category"), direction = "wide")
complaints_by_category_district_year[is.na(complaints_by_category_district_year)]<-0
write.csv(complaints_by_category_district_year, "complaints_by_category_district_year.csv", row.names = FALSE)
