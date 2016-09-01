#clear workspace
rm(list=setdiff(ls(), "repository"))

#delete folders if they exist
for (folder in c("input", "output", "temp")) {
  if (dir.exists(paste0(repository, "build_dataset/", folder)) == 1) {
    unlink(paste0(repository, "build_dataset/", folder), recursive = TRUE)
  }
  
  #create directories
  dir.create(paste0(repository, "build_dataset/", folder))
}

#run files
for (file in c("get_data.R", "clean_complaint_data.R", "clean_crime_data.R")) {
  source(paste0(repository, "build_dataset/src/", file))
}
