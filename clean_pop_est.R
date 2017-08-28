
library(magrittr)
library(stringr)

clean_pop_est <- function(file, single_age, start_year, end_year){
  
  nh_pop <- read_excel(file, sheet = 2)
  names(nh_pop) <- str_replace_all(tolower(names(nh_pop)), ' ', '_')
  
  h_pop <- read_excel(file, sheet = 3)
  names(h_pop) <- str_replace_all(tolower(names(h_pop)), ' ', '_')
  
    if (single_age == FALSE){
  
      nh_pop %<>%
        age_grouping_clean(start_year = start_year, end_year = end_year)
      
      h_pop %<>%
        age_grouping_clean(start_year = start_year, end_year = end_year)
        
      pop <- rbind(nh_pop, h_pop)
      
    }
  
    if (single_age == TRUE){
      
      nh_pop %<>%
        age_single_year_clean(start_year = start_year, end_year = end_year)
      
      h_pop %<>%
        age_single_year_clean(start_year = start_year, end_year = end_year)
      
      pop <- rbind(nh_pop, h_pop)

    }
  
  return(pop)
  
}
