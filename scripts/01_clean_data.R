#### Preamble ####
# Purpose: Clean NFL stats
# Author: Timothius Prajogi
# Date: 30 March 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 00_download_data

#### Workplace setup ####

library(tidyverse)
library(arrow)

#### Clean Data ####

# Read in data
qb_regular_season_stats <- 
  read_csv(
    "input/qb_regular_season_stats.csv",
    col_types =
      cols(
        "week" = col_integer(),
        "passing_epa" = col_double(),
        "completions" = col_integer(),
        "attempts" = col_integer(),
        "passing_yards" = col_integer(),
        "passing_tds" = col_integer(),
        "interceptions" = col_integer(),
        "sacks" = col_integer(),
        "pacr" = col_double()
      )
  )

# Select only non-na passing epa values
qb_regular_season_stats <- 
  qb_regular_season_stats |>
  filter(!is.na(passing_epa)) |>
  mutate(pacr = replace(pacr, is.na(pacr), 0))

# Split into training and test data (defined as first 9 weeks and then rest of season)
first_half <-
  qb_regular_season_stats |>
  filter(week <= 9) |>
  select(-week)

second_half <-
  qb_regular_season_stats |>
  filter(week > 9) |>
  select(-week)

# Save to parquet
write_parquet(first_half, "output/data/first_half_season.parquet")
write_parquet(first_half, "output/data/second_half_season.parquet")
