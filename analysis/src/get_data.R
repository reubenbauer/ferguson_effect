#clearworkspace
rm(list=setdiff(ls(), "repository"))
file_list = list.files("C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/build_dataset/output", full.names = TRUE)
file.copy(file_list, "C:/Users/reubenbauer/Documents/GitHub/ferguson_effect/analysis/input", overwrite = TRUE)
