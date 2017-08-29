
# Loading required functions into memory

setwd('functions')

files <- list.files()
sapply(files, source)

rm(files)

setwd('..')

# Insuting that the directory the data that we need exists

if (!dir.exists('population_estimates')) {
  source('get-population-data.R')
}

# Putting the data together

files <- list.files('population_estimates')

ofm_data <- get_clean_pop_data(files)


