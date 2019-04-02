
library(pocr)

get_clean_pop_data <- function(file){
  
  years <- str_replace_all(file, '[a-z]|_|\\.', '')
  
  file_data <- 
    data.frame(file = file
               , start_year = as.numeric(str_sub(years, 1, 4))
               , end_year = as.numeric(str_sub(years, 5, 8))
               , single_age = str_detect(file, '_s')) %>%
    arrange(single_age) %>%
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
  
  pop_data <- bind_rows(pop_list)
  
  pop_data$age_group <- factor(pop_data$age_group, levels = c('0-4', '5-9', '10-14', '15-17', '0-17', 'Total'))
  
  # ordering data
  
  pop_data <- arrange(pop_data, sex, raceeth, year, area_id, age_group)
  
  return(pop_data)
  
}
