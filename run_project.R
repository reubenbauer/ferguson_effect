#clear workspace
rm(list = ls())

#load libaries
library(reshape2)
library(ggplot2)
library(dplyr)
library(data.table)
library(doBy)

#set repository
repository = "C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/"
print(repository)

for (directory in c("build_dataset/", "analysis/")) {
  source(paste0(repository, directory, "run_directory.R"))
}

#KLAAR
