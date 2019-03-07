
# Insuring that the directory the data that we need exists

if (!dir.exists('population_estimates')) {
  dir.create('population_estimates')
  source('get_population_data.R')
}

if (length(list.files('population_estimates')) == 0) {
  source('get_population_data.R')
}

# Loading required functions into memory

setwd('functions')

files <- list.files()
sapply(files, source)

rm(files)

setwd('..')

# Putting the data together

files <- list.files('population_estimates')

ofm_data <- get_clean_pop_data(files)
