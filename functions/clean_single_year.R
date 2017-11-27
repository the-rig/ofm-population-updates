
library(reshape2)
library(dplyr)

clean_single_year <- function(data, start_year, end_year){
  
    single_years <- 
    filter(data, age_group %in% c('15', '16', '17')
           , year >= start_year
           , year <= end_year
    ) %>%
    melt(id.vars = c('area_name'
                     , 'area_id'
                     , 'year'
                     , 'age_group')) %>%
    group_by(area_name, area_id, year, variable) %>%
    summarise(population = sum(as.numeric(value))) %>%
    mutate(age_group = '15-17'
           , raceeth = variable) %>%
    select(area_name
           , area_id
           , year
           , raceeth
           , age_group
           , population) %>%
    ungroup() 
  
    total_children <- 
      filter(data, age_group %in% c('0-17')
             , year >= start_year
             , year <= end_year
      ) %>%
      melt(id.vars = c('area_name'
                       , 'area_id'
                       , 'year'
                       , 'age_group')) %>%
      mutate(raceeth = variable
             , population = as.numeric(value)) %>%
      select(area_name
             , area_id
             , year
             , raceeth
             , age_group
             , population) %>%
      ungroup() 
    
    return(bind_rows(single_years, total_children))
  
}
