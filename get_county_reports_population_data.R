
library(readxl)
library(tidycensus)
library(stringr)
library(reshape2)
library(rvest)
library(dplyr)

setwd('population_estimates')
files <- list.files()

year <- 2017

sheets <- excel_sheets('pop_2010_2018.xlsx')

total_population_10_17 <- read_excel(files[files == 'pop_2010_2018.xlsx'], sheet = sheets[sheets == 'Total'])

# total_population_10_17 <- total_population_10_17[!total_population_10_17$Year == ".",]

total_population_10_17$Year <- as.numeric(total_population_10_17$Year)

# changing the names to make them easier to deal with

names(total_population_10_17) <- str_replace_all(tolower(names(total_population_10_17)), ' ', '_')

# getting hispanic population

hispanic_population_10_17 <- read_excel(files[files == 'pop_2010_2018.xlsx'], sheet = sheets[sheets == 'Hispanic'])

# changing the names to make them easier to deal with

names(hispanic_population_10_17) <- str_replace_all(tolower(names(hispanic_population_10_17)), ' ', '_')

# getting the data we need by age

total_and_u5_pop <- 
  filter(total_population_10_17, year == year, age_group == "0-4") %>%
  select(area_name, area_id, year, total_under_5 = total)

# getting the data we need by race and ethnicity

total_by_race <- 
  filter(total_population_10_17, year == year, age_group == "Total") %>%
  select(area_name, area_id, year, age_group,contains("total"))

total_by_eth <- 
  filter(hispanic_population_10_17, year == year, age_group == "Total") %>%
  select(area_name, area_id, year, hispanic_total)

# population under 25

over_25_pop <- 
  filter(total_population_10_17, year == year, str_detect(age_group, "0-4|10-14|15-19|20-24|Total")) %>%
  select(area_name, area_id, year, age_group, total) %>%
  mutate(age_group = ifelse(as.character(age_group) == "Total", "Total", "Under_25")) %>%
  group_by(area_name, area_id, year, age_group) %>%
  summarize(total = sum(as.numeric(total))) %>%
  dcast(area_name + area_id + year ~ age_group) %>%
  mutate(over_25 = Total - Under_25) %>%
  select(area_id, over_25)

# getting data totals for 2010 to calculate percent change

total_pop_2010 <- 
  filter(total_population_10_17, year == 2010, age_group == "Total") %>%
  select(area_name, area_id, total_2010 = total)

#####################################################
# Processing 15-17 Population between 2010 and 2017 #
#####################################################

sheets <- excel_sheets('pop_2010_2018_s.xlsx')

sub_population_10_17 <- read_excel(files[files == 'pop_2010_2018_s.xlsx'], sheet = sheets[sheets == 'Total'])

# changing the names to make them easier to deal with
names(sub_population_10_17) <- str_replace_all(tolower(names(sub_population_10_17)), ' ', '_')

child_pop <- 
  filter(sub_population_10_17, year == year, age_group == "0-17") %>%
  select(area_name, area_id, year, total_child = total)

# getting data on poverty

year <- 2017

pov_var <- 
  load_variables(year = year, "acs5", cache = TRUE) %>%
  filter(label == "Estimate!!Total!!Income in the past 12 months below poverty level"
         , concept == "POVERTY STATUS IN THE PAST 12 MONTHS BY AGE")

county_poverty <- 
  get_acs(geography = "county"
          , state = "WA"
          , variable = pov_var$name
          , year = year
          , survey = "acs5") %>%
  select(area_id = GEOID, poverty = estimate)

state_poverty <- 
  get_acs(geography = "state"
          , state = "WA"
          , variable = pov_var$name
          , year = year
          , survey = "acs5") %>%
  select(area_id = GEOID, poverty = estimate)

poverty <- bind_rows(county_poverty, state_poverty)

# getting data on college completion

ed_var <- 
  load_variables(year = year, "acs5", cache = TRUE) %>%
  filter(stringr::str_detect(label, "Regular high school diploma")
         , concept == "EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER")

ed_var <- 
  load_variables(year = year, "acs5", cache = TRUE) %>%
  # filter(stringr::str_detect(label, "Regular high school diploma")
  #        , concept == "EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER")
  filter(concept == "EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER")


county_ed <- 
  get_acs(geography = "county"
          , state = "WA"
          , variable = paste0("B15003_0", 17:25)
          , year = year
          , survey = "acs5") %>%
  group_by(area_id = GEOID) %>%
  summarize(education = sum(estimate))

state_ed <- 
  get_acs(geography = "state"
          , state = "WA"
          , variable = paste0("B15003_0", 17:25)
          , year = year
          , survey = "acs5") %>%
  group_by(area_id = GEOID) %>%
  summarize(education = sum(estimate))

education <- bind_rows(county_ed, state_ed)

## Population density

state_url <- "https://en.wikipedia.org/wiki/Washington_(state)"

state_area <- 
  read_html(state_url) %>%
  html_node("table.infobox") %>%
  # html_text() %>%
  html_table(header = FALSE, fill = TRUE)

state_area <- 
  filter(state_area, str_detect(X1, "Total"), str_detect(X2, "sq")) %>%
  mutate(area_name = "Washington" 
         , area_id = as.character(53)
         , area = str_remove(str_sub(X2, end = 6), ",")
         , area = as.numeric(area)
  ) %>%
  select(area_name, area_id, area)


html_nodes(webpage,".mergedtoprow+ .mergedrow td , .mergedtoprow+ .mergedrow th")


#Specifying the url for desired website to be scraped
url <- "https://en.wikipedia.org/wiki/List_of_counties_in_Washington"

#Reading the HTML code from the website
# webpage <- read_html(url)
# 
# density <- html_nodes(webpage, "th , a , td")

county_areas <- 
  read_html(url) %>%
  html_nodes("table.wikitable") %>%
  html_table()

area <- data.frame(area_name = county_areas[[1]]$County
                   , area_id = county_areas[[1]]$`FIPS code[7]`
                   , area = county_areas[[1]]$`Area[8]`)


area <- 
  mutate(area, area = str_sub(area, start = 21)
         , area = str_remove(area, "sq.*")
         , area = str_remove(area, ",")
         , area = str_trim(area)
         , area = as.numeric(as.character(area))
         , area_id = ifelse(nchar(area_id) == 1, paste0(5300, area_id), paste0(530, area_id))
         # , area_id = as.numeric(area_id)
         , area_name = as.character(area_name)
  ) %>%
  bind_rows(state_area) %>%
  select(-area_name)

## Putting it all together

county_repot_pop_dat <- 
  left_join(total_by_race, total_by_eth) %>%
  mutate(nh_white = as.numeric(total) - as.numeric(hispanic_total)) %>%
  left_join(total_and_u5_pop) %>%
  left_join(child_pop) %>%
  left_join(total_pop_2010) %>%
  melt(id.vars = c("area_name", "area_id", "year", "age_group", "total", "total_2010")) %>%
  mutate(value = as.numeric(value) / as.numeric(total)) %>%
  dcast(area_name + area_id + year + age_group + total + total_2010 ~ variable) %>%
  mutate(total_2010 = (as.numeric(total) - as.numeric(total_2010)) / as.numeric(total_2010)) %>%
  rename(change_2010_2017 = total_2010) %>%
  left_join(poverty) %>%
  mutate(poverty = poverty / as.numeric(total)) %>%
  left_join(over_25_pop) %>%
  left_join(education) %>%
  mutate(education = education / over_25) %>%
  arrange(area_id) %>%
  left_join(area) %>%
  mutate(area = as.numeric(total) / area) %>%
  select(-over_25)

