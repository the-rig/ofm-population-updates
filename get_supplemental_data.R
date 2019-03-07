
# Required Packages

library(RCurl)

dir_name <- 'supplemental_data'

# creating directory for population estimates

dir.create(dir_name)

# Supplemental Data

# Population Density

download.file(url = 'https://www.ofm.wa.gov/sites/default/files/public/legacy/pop/popden/popden_county.xlsx'
              , destfile = paste0(dir_name, '/popden_county.xlsx')
              , mode = 'wb')

# Median income by county

# https://www.ofm.wa.gov/sites/default/files/public/legacy/economy/hhinc/medinc.xlsx