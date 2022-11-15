## ------------------------------------------------------------
## by J.Kruppa on Wednesday, June 24, 2020 (10:45)
pacman::p_load(tidyverse, readxl, plyr, stringi, janitor,
               magrittr)
## small script to compile all rnw or tex files
source(file.path("source/runKnitr.R"))
## get students name
## replace umlaute in the file
## \u00e4 -> ä; \u00fc -> ü; \u00f6 -> ö
## students_info_tbl <- read_excel(file.path("organisation", "students_2020.xlsx"))
students_info_tbl <- read_excel("organisation/Prüfungstermine.II.2.SS21.xlsx", skip = 1) %>%
  clean_names() %>% 
  mutate(date = as.character(x5)) %>%
  select(date, termin_bestatigt, Vorname = vorname, Nachname = nachname) %>%
  mutate(date = as.character(date),
         Nachname = stri_replace_all_fixed(Nachname, 
                                c("ä", "ö", "ü", "Ä", "Ö", "Ü"), 
                                c("ae", "oe", "ue", "Ae", "Oe", "Ue"), 
                                vectorize_all = FALSE),
         Vorname = stri_replace_all_fixed(Vorname, 
                                c("ä", "ö", "ü", "Ä", "Ö", "Ü"), 
                                c("ae", "oe", "ue", "Ae", "Oe", "Ue"), 
                                vectorize_all = FALSE),
         Nachname_str = str_replace_all(Nachname, " ", "_"),
         Vorname_str = str_replace_all(Vorname, " ", "_"))

## students_info_tbl %<>%
##   filter(!is.na(Nachname) & !is.na(bestätigt)) 

## !!!!!!!!!!!!!!!!!!!!!!!
students_info_tbl <- students_info_tbl %>%
  select(-termin_bestatigt) %>%
  na.omit
## !!!!!!!!!!!!!!!!!!!!!!!

students_info_tbl <- students_info_tbl[3,]
students_info_tbl$date <- "2021-09-08"

##
## loop over the students
l_ply(1:nrow(students_info_tbl), function(i) {
  student_tbl <- students_info_tbl[i, ]
  student_file_str <- str_c(student_tbl$Nachname_str, "_", student_tbl$Vorname_str)
  dir.create(file.path("template_exam", "tmp"))
  file.copy(file.path("template_exam", "template.Rnw"),
            file.path("template_exam", "tmp", str_c(student_file_str, ".Rnw")))
  change_name_cmd <- paste0("sed -i 's?templateName?",
                            str_c(student_tbl$Nachname, ", ", student_tbl$Vorname),
                            "?' ",
                            file.path("template_exam", "tmp", str_c(student_file_str, ".Rnw")))
  system(change_name_cmd)
  ## get the files for the exercieses...
  student_exam_rnw_file <- file.path("template_exam", "tmp", str_c(student_file_str, ".Rnw"))
  ## copy dir
  copy_dir <- file.path("student_exams", students_info_tbl$date[i])
  dir.create(copy_dir, showWarnings = FALSE)
  ## run knitr
  runKnitr(student_exam_rnw_file, copy.dir = copy_dir, force = TRUE)
  ## file copy stuff
  file.copy(dir(file.path("template_exam", "tmp"), pattern = ".csv", full.names = TRUE),
            copy_dir)
  zip(file.path("student_exams", students_info_tbl$date[i], str_c(student_file_str, ".zip")),
      dir(copy_dir, full.names = TRUE, pattern = student_file_str), extras = "-j")
  unlink(file.path("template_exam", "tmp"), recursive=TRUE)
})
