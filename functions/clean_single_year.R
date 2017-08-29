
library(reshape2)
library(dplyr)

clean_single_year <- function(data, start_year, end_year){
  
  data %>%
    filter(age_group %in% c('15', '16', '17')
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
    ungroup() %>%
    return()
  
}

