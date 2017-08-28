
# Required Libraries

library(RCurl)

# There are a number of files that need to be downloaded from OFM. 

# OFM currenty has county population estimates between 2000 and 2016 that are split 
# between two files, one that includes 2000 to 2010 and another that includes 2010 to 
# 2016. The firs set of county files contain population estimates based on age (groupings), 
# sex, race and Hispanic origin. The second set of files with contain special individual 
# age year estimates that can be used to exclude individuals over the age of 18.

web_address <- 'http://www.ofm.wa.gov/pop/asr/sade/'

# file names

# County:

pop_00_10 <- paste0(web_address, 'ofm_pop_sade_county_2000_to_2010.xlsx')
pop_10_16 <- paste0(web_address, 'ofm_pop_sade_county_2010_to_2016.xlsx')

# County (special age groups):

pop_s_00_10 <- paste0(web_address, 'ofm_pop_sade_county_2000_to_2010_s.xlsx')
pop_s_10_16 <- paste0(web_address, 'ofm_pop_sade_county_2010_to_2016_s.xlsx')

# creating directory for population estimates

dir_name <- 'population_estimates'

dir.create(dir_name)

# downloading County files:

download.file(url = pop_00_10, destfile = paste0(dir_name, '/pop_00_10.xlsx'), mode = 'wb')
download.file(url = pop_10_16, destfile = paste0(dir_name, '/pop_10_16.xlsx'), mode = 'wb')

# downloading County (special age groups) files:

download.file(url = pop_s_00_10, destfile = paste0(dir_name, '/pop_s_00_10.xlsx'), mode = 'wb')
download.file(url = pop_s_10_16, destfile = paste0(dir_name, '/pop_s_10_16.xlsx'), mode = 'wb')



