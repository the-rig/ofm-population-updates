
# Required Libraries

library(RCurl)

# There are a number of files that need to be downloaded from OFM. 

# The first set of files contain population estimates between 2000 and 2016 and that are 
# split between 2000 to 2010 and 2010 to 2016. There are also estimates for Counties based 
# on age (groupings), sex, race and Hispanic origin. There is also a second set of files
# with special age groups so that we can obtain estimates of children under 18.

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

download.file(url = pop_00_10, destfile = paste0(dir_name, '/pop_00_10.xlsx'))
download.file(url = pop_10_16, destfile = paste0(dir_name, '/pop_10_16.xlsx'))

# downloading County (special age groups) files:

download.file(url = pop_s_00_10, destfile = paste0(dir_name, '/pop_s_00_10.xlsx'))
download.file(url = pop_s_10_16, destfile = paste0(dir_name, '/pop_s_10_16.xlsx'))



