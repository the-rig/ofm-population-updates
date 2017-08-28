
# downloading required files

# Required Libraries

library(RCurl)

# There are a number of files that need to be downloaded from OFM. For the first two fiels, 
# 
# 1. State: 


web_address <- 'http://www.ofm.wa.gov/pop/asr/sade/'

# file names

# County:

pop_00_10 <- paste0(web_address, 'ofm_pop_sade_state_2000_2010.xlsx')

pop_10_16 <- paste0(web_address, 'ofm_pop_sade_state_2010_2016.xlsx')

# County (special age groups):

pop_s_00_10 <- paste0(web_address, 'ofm_pop_sade_state_2000_2010_s.xlsx')

pop_s_10_16 <- paste0(web_address, 'ofm_pop_sade_state_2010_2016_s.xlsx')

# creating directory for population estimates

dir.create('pop_estimates')

# downloading files







