
# Required Packages

library(RCurl)

# There are a number of files that need to be downloaded from OFM. 

# OFM currenty has county population estimates between 2000 and 2016 that are split 
# between two files; one that includes 2000 to 2010 and another that includes 2010 to 
# 2016. The first set of county files contain population estimates based on age (groupings), 
# sex, race and Hispanic origin. The second set of files with contain special individual 
# age year estimates, these can be used to exclude individuals over the age of 18 and get 
# ages 15 - 17.

web_address <- 'https://www.ofm.wa.gov/sites/default/files/public/dataresearch/pop/asr/sade/'

# file names

# County:

pop_2000_2010 <- paste0(web_address, 'ofm_pop_sade_county_2000_to_2010.xlsx')
pop_2010_2017 <- paste0(web_address, 'ofm_pop_sade_county_2010_to_2017.xlsx')

# County (special age groups):

pop_2000_2010_s <- paste0(web_address, 'ofm_pop_sade_county_2000_to_2010_s.xlsx')
pop_2010_2017_s <- paste0(web_address, 'ofm_pop_sade_county_2010_to_2017_s.xlsx')

# creating directory for population estimates

dir_name <- 'population_estimates'

dir.create(dir_name)

# downloading County files:

download.file(url = pop_2000_2010, destfile = paste0(dir_name, '/pop_2000_2010.xlsx'), mode = 'wb')
download.file(url = pop_2010_2017, destfile = paste0(dir_name, '/pop_2010_2017.xlsx'), mode = 'wb')

# downloading County (special age groups) files:

download.file(url = pop_2000_2010_s, destfile = paste0(dir_name, '/pop_2000_2010_s.xlsx'), mode = 'wb')
download.file(url = pop_2010_2017_s, destfile = paste0(dir_name, '/pop_2010_2017_s.xlsx'), mode = 'wb')



