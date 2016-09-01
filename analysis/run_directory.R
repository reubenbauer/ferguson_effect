#clear workspace
rm(list=setdiff(ls(), "repository"))

#delete folders if they exist
for (folder in c("input", "output", "temp")) {
  if (dir.exists(paste0(repository, "analysis/", folder)) == 1) {
    unlink(paste0(repository, "analysis/", folder), recursive = TRUE)
  }
  
  #create directories
  dir.create(paste0(repository, "analysis/", folder))
}

#run files
for (file in c("get_data.R", "line_complaints_by_district_year.R", "line_homicides_by_district_year.R")) {
  source(paste0(repository, "analysis/src/", file))
}
