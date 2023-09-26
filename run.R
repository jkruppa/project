## ------------------------------------------------------------
pacman::p_load(tidyverse, readxl, plyr, stringi, janitor,
               magrittr, fs)
project_path <- file.path(path_home(), "Documents/GitHub/project")
source(file.path(project_path, "source/runKnitr.R"))
## ------------------------------------------------------------

semester_path <- "students"
students_tbl <- read_csv(file.path(project_path, semester_path, "2023_students.txt")) %>% 
  clean_names %>% 
  mutate(nachname = str_replace(nachname, ",", ""),
         nachname = stri_replace_all_fixed(nachname, 
                                c("ä", "ö", "ü", "Ä", "Ö", "Ü"), 
                                c("ae", "oe", "ue", "Ae", "Oe", "Ue"), 
                                vectorize_all = FALSE),
         Nachname_str = str_replace_all(nachname, " ", "_"),
         Vorname_str = str_replace_all(vorname, " ", "_")) 

students_tbl %>% 
  print(n = Inf)

## loop over the students
l_ply(1:nrow(students_tbl), function(i) {
  student_tbl <- students_tbl[i, ]
  student_file_str <- str_c(student_tbl$Nachname_str, "_", student_tbl$Vorname_str)
  dir.create(file.path(project_path, "template", "tmp"))
  file.copy(file.path(project_path, "template", "template.Rnw"),
            file.path(project_path, "template", "tmp", str_c(student_file_str, ".Rnw")))
  change_name_cmd <- paste0("sed -i '' -e 's?templateName?",
                            str_c(student_tbl$nachname, ", ", student_tbl$vorname),
                            "?' ",
                            file.path(project_path, "template", "tmp", str_c(student_file_str, ".Rnw")))
  system(change_name_cmd)
  ## get the files for the exercieses...
  student_exam_rnw_file <- file.path(project_path, "template", "tmp", str_c(student_file_str, ".Rnw"))
  ## copy dir
  copy_dir <- file.path(project_path, semester_path)
  dir.create(copy_dir, showWarnings = FALSE)
  ## run knitr
  runKnitr(student_exam_rnw_file, copy.dir = copy_dir, force = TRUE)
  ## file copy stuff
  file.copy(dir(file.path(project_path, "template", "tmp"), pattern = ".csv", full.names = TRUE),
            copy_dir)
  file.copy(dir(file.path(project_path, "template", "tmp"), pattern = ".txt", full.names = TRUE),
            copy_dir)
  zip(file.path(project_path, semester_path, str_c(student_file_str, ".zip")),
      dir(copy_dir, full.names = TRUE, pattern = student_file_str), extras = "-j")
  unlink(file.path(project_path, "template", "tmp"), recursive=TRUE)
  dir(file.path(project_path, semester_path), pattern = student_file_str, full.names = TRUE) %>% 
    str_subset(".zip", negate = TRUE) %>% 
    unlink()
})
