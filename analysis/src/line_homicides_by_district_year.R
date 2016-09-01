#clearworkspace
rm(list=setdiff(ls(), "repository"))

#set input directory
setwd(paste0(repository, "analysis/", "input"))

#read in data
data = read.csv("homicides_by_district_year.csv", header = TRUE, stringsAsFactors = FALSE)

#set output directory
setwd(paste0(repository, "analysis/", "input"))

#plots
plot(data$Freq.2012, data$Freq.2014)
plot(log(data$Freq.2012), log(data$Freq.2014))