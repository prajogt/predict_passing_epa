#### Preamble ####
# Purpose: Download NFL stats
# Author: Timothius Prajogi
# Date: 30 March 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: none

#### Workplace setup ####

library(tidyverse)
library(nflverse)
library(arrow)

#### Load Data ####

qb_regular_season_stats <- 
  load_player_stats(seasons = TRUE) |> 
  filter(season_type == "REG" & position == "QB" & season == "2023")

# Select relevant features
qb_regular_season_stats <-
  qb_regular_season_stats |>
  select(week, recent_team, passing_epa, completions, attempts,  passing_yards, passing_tds, interceptions, sacks, pacr)


# Save to csv
write_csv(qb_regular_season_stats, "input/qb_regular_season_stats.csv")

# Save to parquet
write_parquet(qb_regular_season_stats, "input/qb_regular_season_stats.parquet")
