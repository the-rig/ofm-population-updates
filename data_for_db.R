
library(dplyr)

ofm_population <-
  mutate(ofm_data, area_id = as.integer(area_id)) %>%
  left_join(select(ref_lookup_county
                           , county_cd
                           , area_id = countyfips)
              ) %>%
  mutate(raceeth = ifelse(raceeth %in% c('non_hispanic_aian'
                                           , 'non_hispanic_asian'
                                           , 'non_hispanic_nhopi'
                                           , 'non_hispanic_two_or_more_races')
                            , 'other_ethnicity', raceeth)
         ) %>%
  group_by(area_name
           , area_id
           , county_cd
           , year
           , raceeth
           , sex
           , age_group) %>%
  summarize(population = sum(population)) %>%
  ungroup() %>%
  mutate(pk_gndr = ifelse(sex == 'all', 0, NA)
         , pk_gndr = ifelse(sex == 'female', 1, pk_gndr)
         , pk_gndr = ifelse(sex == 'male', 2, pk_gndr)
         ) %>%
  mutate(cd_race = ifelse(raceeth == 'all', 0, NA)
         , cd_race = ifelse(raceeth == 'aian', 1, cd_race)
         , cd_race = ifelse(raceeth == 'asian', 2, cd_race)
         , cd_race = ifelse(raceeth == 'black', 3, cd_race)
         , cd_race = ifelse(raceeth == 'nhopi', 4, cd_race)
         , cd_race = ifelse(raceeth == 'white', 5, cd_race)
         # , cd_race = ifelse(cd_race == '', 6, cd_race)
         # , cd_race = ifelse(cd_race == '', 7, cd_race)
         , cd_race = ifelse(raceeth == 'two_or_more_races', 8, cd_race)
         , cd_race = ifelse(raceeth == 'hispanic', 9, cd_race)
         , cd_race = ifelse(raceeth == 'other_ethnicity', 10, cd_race)
         , cd_race = ifelse(raceeth == 'non_hispanic_white', 11, cd_race)
         , cd_race = ifelse(raceeth == 'non_hispanic_black', 12, cd_race)
         ) %>%
  filter(!is.na(cd_race)) %>%
  mutate(age_grouping_cd = ifelse(age_group == '0-17', 0, age_group)
           , age_grouping_cd = ifelse(age_grouping_cd == '0-4', 1, age_grouping_cd)
           , age_grouping_cd = ifelse(age_grouping_cd == '5-9', 2, age_grouping_cd)
           , age_grouping_cd = ifelse(age_grouping_cd == '10-14', 3, age_grouping_cd)
           , age_grouping_cd = ifelse(age_grouping_cd == '15-17', 4, age_grouping_cd)
           ) %>%
  mutate(year = as.integer(year)
         , measurement_year = as.integer(year)) %>%
  select(source_census = year
         , county_cd
         , pk_gndr
         , cd_race
         , age_grouping_cd
         , measurement_year
         , pop_cnt = population)

write.csv(x = ofm_population, file = 'ofm_population.csv', row.names = FALSE)
    

