
library(reshape2)
library(dplyr)

clean_age_grouping <- function(data, start_year, end_year){
  
  data %>%
    filter(age_group %in% c('0-4', '5-9', '10-14', 'Total')
           , year >= start_year
           , year <= end_year) %>%
    melt(id.vars = c('area_name'
                     , 'area_id'
                     , 'year'
                     , 'age_group')) %>%
    mutate(raceeth = variable
           , population = value) %>%
    select(area_name
           , area_id
           , year
           , raceeth
           , age_group
           , population) %>%
    return()
  
}

