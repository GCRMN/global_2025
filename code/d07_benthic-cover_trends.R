# 1. Load packages ----

library(tidyverse) # Core tidyverse packages
library(patchwork)
library(glue)
library(ggtext)
library(ggrepel)
library(scales)
library(zoo)
library(openxlsx)
library(tidybayes)

# 2. Source functions ----

source("code/function/graphical_par.R")
source("code/function/theme_graph.R")
source("code/function/plot_trends_model.R")
source("code/function/transform_ribbons.R")

# 3. Load data ----

load("data/model-results.RData")

data_contrasts <- readRDS("data/13_model-output_hbm/contrasts_global.rds") |> 
  filter(category == "Hard coral") |>
  pull(posteriors) |>
  as.data.frame() |> 
  mutate(Contrast = case_when(Year %in% c(1997, 2000) ~ "1st GBE",
                              Year %in% c(2009, 2012) ~ "2nd GBE",
                              Year %in% c(2015, 2018) ~ "3rd GBE",
                              Year %in% c(2022, 2024) ~ "4th GBE",
                              TRUE ~ NA_character_)) %>% 
  drop_na(Contrast) |> 
  group_by(.draw, Contrast) |>
  summarise(abs = diff(value), rel = exp(diff(log(value)))-1) |> 
  ungroup() |>
  group_by(Contrast) |>
  summarise_draws(median = median,
                  lower = ~quantile(., 0.025),
                  upper = ~quantile(., 0.975),
                  Pg= ~mean(.>0), 
                  Pl= ~mean(.<0)) |> 
  ungroup() |>
  rename(Lower='2.5%',Upper='97.5%') |> 
  mutate(P = max(Pg, Pl),
         evidence = case_when(P >= 0.95 ~ "Strong evidence",
                              P >= 0.90 ~ "Evidence",
                              P >= 0.85 ~ "Weak evidence",
                              P < 0.85 ~ "No evidence")) |>  
  filter(variable == "rel") %>% 
  mutate(across(c(median, Lower, Upper), ~round(.x*100, 1)))

# 4. Figures for Part 1 ----

## 4.1 Global - Hard coral and macroalgae ----

plot_trends_model(level_i = "global", range = "full", category_i = "Hard coral")

plot_trends_model(level_i = "global", range = "full", category_i = "Macroalgae")

## 4.2 Summary table ----

### 4.2.1 Weights ----

data_weights <- read.csv("figs/08_text-gen/reefs_extent.csv") %>% 
  filter(subregion == "All") %>% 
  select(region, reef_extent_rel_world) %>% 
  mutate(reef_extent_rel_world = round(reef_extent_rel_world, 1))

plot_donut_weights <- function(region_i){
  
  data_i <- data_weights %>% 
    mutate(color = case_when(region == region_i ~ "red",
                             TRUE ~ "grey"))
  
  ggplot() +
    geom_bar(data = data_i, aes(x = 2, y = reef_extent_rel_world, fill = color, group = 1),
             stat = "identity", width = 1, show.legend = FALSE, color = "white", linewidth = 1) +
    scale_fill_identity() +
    coord_polar(theta = "y") +
    xlim(0.5, 2.5) + # Create the hole of the donut
    theme_void()
  
  ggsave(paste0("figs/02_part-1/fig_weight-", str_replace_all(str_to_lower(region_i), " ", "-"), ".pdf"),
         height = 4, width = 4, bg = "transparent")
  
}

map(data_weights$region, ~plot_donut_weights(region_i = .x))

### 4.2.2 Trends ----

data_models2 <- data_models %>% 
  filter(category == "Hard coral" & level == "region") %>% 
  mutate(color = case_when(year <= 2009 ~ "red",
                           year > 2009 & year < 2020 ~ "grey",
                           year >= 2020 ~ "blue"))

plot_trends_periods <- function(region_i){
  
  ggplot(data = data_models2 %>% filter(region == region_i),
         aes(x = year, y = mean, color = color, group = 1)) +
    geom_line(linewidth = 2) +
    scale_color_identity() +
    theme_minimal() +
    theme(axis.title = element_blank(),
          axis.ticks = element_blank(),
          axis.text = element_blank(),
          panel.grid = element_blank())
  
  ggsave(paste0("figs/02_part-1/fig_periods-", str_replace_all(str_to_lower(region_i), " ", "-"), ".pdf"),
         height = 4, width = 6, bg = "transparent")
  
}

map(data_weights$region, ~plot_trends_periods(region_i = .x))

# 5. Figures for Part 2 ----

## 5.1 Trends (regions) ----

map(setdiff(unique(data_models$region), NA),
    ~plot_trends_model(region_i = .x,
                 level_i = "region", range = "obs"))

## 5.2 Trends (subregions) ----

map(setdiff(unique(data_models$region), NA),
    ~plot_trends_model(region_i = .x,
                 level_i = "subregion", category_i = "Hard coral", range = "obs"))

map(setdiff(unique(data_models$region), NA),
    ~plot_trends_model(region_i = .x,
                 level_i = "subregion", category_i = "Macroalgae", range = "obs"))

map(c("Brazil", "ETP"),
    ~plot_trends_model(region_i = .x,
                       level_i = "subregion", category_i = "Turf algae", range = "obs"))

## 5.3 Trends (ecoregions) ----

map(setdiff(unique(data_models$region), NA),
    ~plot_trends_model(region_i = .x,
                 level_i = "ecoregion", category_i = "Hard coral", range = "obs"))

map(setdiff(unique(data_models$region), NA),
    ~plot_trends_model(region_i = .x,
                 level_i = "ecoregion", category_i = "Macroalgae", range = "obs"))

# 6. Modeled values per region ----

## 6.1 Create the function ----

export_model_data <- function(region_i, range){
  
  metadata <- tibble(variable = c("category", "region", "subregion",
                                  "year", "mean",
                                  "lower_ci_95",
                                  "upper_ci_95",
                                  "lower_ci_80",
                                  "upper_ci_80",
                                  "data_obs"),
                     description = c("Benthic category", "GCRMN region", "GCRMN subregion",
                                     "Year", "Mean modelled percentage cover",
                                     "Percentage cover for the lower 95% credible interval",
                                     "Percentage cover for the upper 95% credible interval",
                                     "Percentage cover for the lower 80% credible interval",
                                     "Percentage cover for the upper 80% credible interval",
                                     "Observed monitoring data available for the year? Yes (TRUE) or No (FALSE)"))
  
  data_region <- data_models %>% 
    filter(level == "region" & region == region_i & category %in% c("Hard coral", "Macroalgae")) %>% 
    group_by(category) %>% 
    { 
      if (range == "obs") {
        filter(., year >= first_year & year <= last_year)
      } else if(range == "full") {
        .
      }
    } %>% 
    ungroup() %>% 
    select(category, region, year, mean, lower_ci_95, upper_ci_95, lower_ci_80, upper_ci_80, data_obs) %>% 
    arrange(category, region, year) %>% 
    mutate(data_obs = as.character(data_obs)) # To avoid conversion to French by openxlsx package
  
  data_subregion <- data_models %>% 
    filter(level == "subregion" & region == region_i & category %in% c("Hard coral", "Macroalgae")) %>% 
    group_by(category, subregion) %>% 
    { 
      if (range == "obs") {
        filter(., year >= first_year & year <= last_year)
      } else if(range == "full") {
        .
      }
    } %>% 
    ungroup() %>% 
    select(category, subregion, year, mean, lower_ci_95, upper_ci_95, lower_ci_80, upper_ci_80, data_obs) %>% 
    arrange(category, subregion, year) %>% 
    mutate(data_obs = as.character(data_obs)) # To avoid conversion to French by openxlsx package
  
  list_of_datasets <- list("metadata" = metadata, "region" = data_region, "subregion" = data_subregion)
  
  write.xlsx(list_of_datasets, file = paste0("figs/07_additional/08_model-values/", 
                                             str_replace_all(str_replace_all(str_to_lower(region_i), " ", "-"), "---", "-"),
                                             ".xlsx"))
  
}

## 6.2 Map over the function ----

map(setdiff(unique(data_models$region), NA),
    ~export_model_data(region_i = .x, range = "obs"))
