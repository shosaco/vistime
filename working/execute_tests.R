library(vistime)
execute_test <- function(i){
  testfolder <- file.path("working", "tests")
  tests <- list.files(testfolder)

  source(file.path(testfolder, tests[i]), echo = TRUE)
}


execute_all_tests <- function(){
  testfolder <- file.path("working", "tests")
  for (file in list.files(testfolder)){
    print(file)
    source(file.path(testfolder, file), echo = FALSE, print.eval = TRUE, encoding = "UTF-8")
  }
}

execute_all_tests()
