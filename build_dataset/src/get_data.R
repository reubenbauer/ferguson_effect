#copy files
#clear workspace
rm(list=setdiff(ls(), "repository"))
file_list = list.files("C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/data", full.names = TRUE)
file.copy(file_list, "C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/build_dataset/input", overwrite = TRUE)