
library(stringr)
library(dplyr)

get_clean_pop_data <- function(files){
  
  years <- str_replace_all(files, '[a-z]|_|\\.', '')
  
  file_data <- 
    data.frame(file = files
               , start_year = as.numeric(str_sub(years, 1, 4))
               , end_year = as.numeric(str_sub(years, 5, 8))
               , single_age = str_detect(files, '_s')) %>%
    arrange(single_year) %>%
    mutate(start_year = ifelse(is.na(lag(end_year)) == FALSE & lag(end_year) == start_year
                               , start_year + 1, start_year))
  
  pop_list <- list()
  
  for (i in 1:NCOL(file_data)){
    
    pop_list[[i]] <-
      clean_pop_est(file = paste0('population_estimates/', file_data$file[i])
                    , start_year = file_data$start_year[i]
                    , end_year = file_data$end_year[i]
                    , single_age = file_data$single_age[i]
                    )
    if (class(pop_list[[i]]$population) != "numeric") {
      pop_list[[i]]$population <- as.numeric(pop_list[[i]]$population)
    }
    
  }
  
  return(bind_rows(pop_list))
  
}
