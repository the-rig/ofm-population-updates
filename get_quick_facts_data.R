
library(dplyr)

ofm_data_recent <- filter(ofm_data, year == 2018, sex == 'all') 

ofm_data_2010 <- 
  filter(ofm_data
         , year == 2010
         , sex == 'all'
         , raceeth == 'all'
         , age_group == 'Total'
         ) %>%
  select(area_id, change_pop = population)

quick_facts <- 
  filter(ofm_data_recent, raceeth == 'all', age_group == 'Total') %>%
  select(area_id, area_name, total_pop = population) %>%
  left_join(ofm_data_2010) %>%
  mutate(change_pop = (total_pop - change_pop) / total_pop
         , change_pop = round(change_pop * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'all', age_group == '0-4') %>% 
              select(area_id, under_5_pop = population)) %>%
  mutate(under_5_pop = under_5_pop / total_pop
         , under_5_pop = round(under_5_pop * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'all', age_group == '0-17') %>% 
              select(area_id, under_18_pop = population)) %>%
  mutate(under_18_pop = under_18_pop / total_pop
         , under_18_pop = round(under_18_pop * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'black', age_group == 'Total') %>% 
              select(area_id, black_alone = population)) %>%
  mutate(black_alone = black_alone / total_pop
         ,black_alone = round(black_alone * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'white', age_group == 'Total') %>% 
              select(area_id, white_alone = population)) %>%
  mutate(white_alone = white_alone / total_pop
         ,white_alone = round(white_alone * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'aian', age_group == 'Total') %>% 
              select(area_id, aian_alone = population)) %>%
  mutate(aian_alone = aian_alone / total_pop
         ,aian_alone = round(aian_alone * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'asian', age_group == 'Total') %>% 
              select(area_id, asian_alone = population)) %>%
  mutate(asian_alone = asian_alone / total_pop
         ,asian_alone = round(asian_alone * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'nhopi', age_group == 'Total') %>% 
              select(area_id, nhopi_alone = population)) %>%
  mutate(nhopi_alone = nhopi_alone / total_pop
         ,nhopi_alone = round(nhopi_alone * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'two_or_more_races', age_group == 'Total') %>% 
              select(area_id, multiracial = population)) %>%
  mutate(multiracial = multiracial / total_pop
         ,multiracial = round(multiracial * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'hispanic', age_group == 'Total') %>% 
              select(area_id, hispanic = population)) %>%
  mutate(hispanic = hispanic / total_pop
         ,hispanic = round(hispanic * 100, 1)) %>%
  left_join(filter(ofm_data_recent, raceeth == 'non_hispanic_white', age_group == 'Total') %>% 
              select(area_id, non_hispanic_white = population)) %>%
  mutate(non_hispanic_white = non_hispanic_white / total_pop
         ,non_hispanic_white = round(non_hispanic_white * 100, 1))



