#### Preamble ####
# Purpose: Create Linear Model to predict passing_epa
# Author: Timothius Prajogi
# Date: 30 March 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 00_download_data, 01_clean_data

#### Workplace setup ####

library(tidyverse)
library(arrow)
library(tidymodels)


#### Create the Model ####

# Load in data
first_half <- read_parquet("output/data/first_half_season.parquet")

# Ensure reproducibility
set.seed(302)

# Split into training and testing
data_split <-
  initial_split(
    data = first_half,
    prop = 0.8
  )

training_data <- training(data_split)
testing_data <- testing(data_split)

passing_epa_model <-
  linear_reg() |>
  set_engine(engine = "lm") |>
  fit(
    passing_epa ~ completions + attempts + passing_yards + passing_tds + interceptions + sacks + pacr,
    data = training_data
  )

# Save the model
saveRDS(passing_epa_model, "output/data/passing_epa_model.rds")

# Save the testing_data
write_parquet(testing_data, "output/data/first_half_testing.parquet")

# Predict
# predictions_epa <- predict(passing_epa_model, testing_data)
# actual <- testing_data$passing_epa
# comparison <- data.frame(predicted = predictions_epa$.pred, actual = actual)

