
library(magrittr)
library(stringr)
library(readxl)

clean_pop_est <- function(file, single_age, start_year, end_year){

  nh_pop <- read_excel(file, sheet = 2)
  names(nh_pop) <- str_replace_all(tolower(names(nh_pop)), ' ', '_')
  
  h_pop <- read_excel(file, sheet = 3)
  names(h_pop) <- str_replace_all(tolower(names(h_pop)), ' ', '_')
  
    if (single_age == FALSE){
  
      nh_pop %<>%
        clean_age_grouping(start_year = start_year, end_year = end_year)
      
      h_pop %<>%
        clean_age_grouping(start_year = start_year, end_year = end_year)
        
      pop <- rbind(nh_pop, h_pop)
      
    }
  
    if (single_age == TRUE){
      
      nh_pop %<>%
        clean_single_year(start_year = start_year, end_year = end_year)
      
      h_pop %<>%
        clean_single_year(start_year = start_year, end_year = end_year)
      
      pop <- rbind(nh_pop, h_pop)

    }
  
  pop %<>%
    mutate(sex = str_extract(raceeth, 'total|male|female')
           , sex = str_replace_all(sex, 'total', 'all')
           , raceeth = as.character(raceeth)
           , raceeth = ifelse(raceeth %in% c('total', 'male', 'female'), 'all', raceeth)
           , raceeth = str_replace_all(raceeth, '_total|_male|_female', '')) %>%
    select(area_name
           , area_id
           , year
           , raceeth
           , sex
           , age_group
           , population)
  
  return(pop)
  
}

