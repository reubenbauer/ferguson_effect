#clearworkspace
rm(list=setdiff(ls(), "repository"))

#set input directory
setwd(paste0(repository, "analysis/", "input"))

#read in data
data = read.csv("crimes_by_category_district_year.csv", header = TRUE, stringsAsFactors = FALSE)

#set output directory
setwd(paste0(repository, "analysis/", "input"))

#plot crimes by year
data_year_district <- summaryBy(Freq.2002 + Freq.2003 + Freq.2004 + Freq.2005 + Freq.2006 + Freq.2007 + Freq.2008 + Freq.2009 + Freq.2010 + Freq.2011 + Freq.2012 + Freq.2013 + Freq.2014 + Freq.2015 ~ district, FUN = c(sum), data = data)
data_year = as.data.frame(colSums(data_year_district))
data_year = slice(data_year, 2:15)
years = as.data.frame(matrix(unlist(c(2002:2015)), ncol = 1))
data = cbind(years, data_year)
names(data)[names(data) == "V1"]<-"Year"
names(data)[names(data) == "colSums(data_year_district)"]<-"Crimes"

#plots
ggplot(data = data, aes(x = "Year", y = "Crimes"))  + geom_line() + geom_point()