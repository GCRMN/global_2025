# 1. Load packages ----

library(tidyverse)
library(deSolve)
library(tidybayes)
library(xkcd)
library(ggtext)

# 2. Source functions ----

source("code/function/graphical_par.R")
source("code/function/theme_graph.R")

# 3. Load parameters ----

contrasts <- read_csv("data/02_misc/contrast_periods.csv") |> 
  mutate(Contrast=sprintf("%s (%s)", Contrast, Event_period)) |> 
  select(Contrast, Behaviour, n_years)

rates <- readRDS("data/02_misc/contrasts_list.rds")$contrasts_GBEs |> 
  left_join(contrasts, by=c("Contrast"))  |> 
  mutate(rate=rel/n_years) |> select(.draw, Contrast, Behaviour, rate) |> 
  group_by(.draw,Behaviour) |>
  summarise(rate=mean(rate)) |> ungroup()

# 4. ODE model definition ---

# Parameters for the coral cover model
# C = coral cover (proportion)
# dC/dt = growth_rate - mortality_rate 

coral_ode <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    
    # State variable: C = coral cover (0 to 1, where 1 = 100%)
    
    # Growth term: logistic growth with carrying capacity
    # dC/dt = r * C * (1 - C/K)
    # Where K = carrying capacity (maximum sustainable coral cover)
    growth <- r_max * C * (1 - C / K_capacity) * (1 - disturbance(time, recov))  # Growth is null during disturbance events
    
    # Mortality term: baseline + stress-induced mortality
    mortality <- m_base * C + m_stress * C * disturbance(time, recov)
    
    # Recovery term: recovery from disturbed areas
    recovery <- recovery_rate * (1 - C)
    
    # Rate of change of coral cover
    dC <- growth - mortality + recovery
    
    return(list(c(dC)))
  })
}

# 5. Disturbance function ----

# Define a time-varying disturbance based on recovery periods (width)

disturbance <- function(time, recov, n=50,  offset = 0, bleaching_interval = 2) {
  d <- rep(1, n)
  interval <- recov + bleaching_interval  # Allow bleaching to repeat two years in a row (as per GBE patterns observed in the past)
  
  # Starts shifted by the offset (1-based indexing)
  starts <- seq(1 + offset, n, by = interval)
  
  # Expand for width
  indices <- as.vector(outer(starts, 0:(recov - 1), `+`))
  
  # Assign 0s to valid indices
  d[indices[indices <= n & indices > 0]] <- 0
  d <- d[time] # Return disturbance value for the current time step
  
  return(d)
}

# 6. Set parameters ----

# 1GBE every 10 years

# Ecological parameters

parameters <- c(
  r_max = 0.00913, #0.0151, # Maximum intrinsic growth rate (per year) (Base on GCRMN Max Recovery rates)
  K_capacity = 0.50, # Carrying capacity - max sustainable coral cover (80%)
  m_base = 0.00, # Baseline mortality rate
  m_stress = 0.0382, #0.12,# Stress-induced mortality coefficient (max coral loss = 12%)
  recovery_rate = 0.0 # Recovery rate from disturbed areas. Given growth is already defining recovery, we set this to 0 to avoid double counting recovery processes
)

# Initial conditions
initial_state <- c(C = 0.26)  # Start with 26% coral cover (as per GCRMN Report 2025)

# Time sequence (years)
n <- 50
times <- seq(1, n, by = 1)  # 50 years, yearly time steps

# 7. Solve ODE using Runge-Kutta method ----

# For different disturbance scenarios and posterior parameter sets

for (rwindow in c( 1, 2, 4, 10)) { # Loop through different recovery windows 
  
  for (i in 1:1000) { # Loop through 1000 posterior samples of growth and mortality rates
    draw_id <- sample(rates$.draw, 1) # Sample draws to pair growth and mortality rates for the same posterior sample
    parameters["r_max"] <- rates |>
      filter(.draw==draw_id, Behaviour=="Recovery") |> 
      pull(rate) # sample growth rate based on posterior samples
    
    parameters["m_stress"] <- abs(rates |>
                                    filter(.draw==draw_id, Behaviour=="Mortality") |>
                                    pull(rate)) # sample mortality rate based on posterior samples  
    output <- ode(
      y = initial_state,
      times = times,
      func = coral_ode,
      parms = c(parameters, recov=rwindow), # add length of recovery windows as a parameter to the model
      method = "rk4"
    )
    
    # Convert output to data frame
    res <- as.data.frame(output)
    names(res) <- c("time", "coral_cover")
    res <- res |>
      mutate(scenario = paste0(rwindow, "years recovery period"), draw = i) # Add scenario and draw number for later analysis
    
    # Combine results
    if (rwindow == 1 && i == 1) {
      data_simulation <- res
    } else {
      data_simulation <- bind_rows(data_simulation, res)
    }
  }
}

# 8. Export results ----

saveRDS(data_simulation, "data/02_misc/data_simulation.rds")

# 9. Make the plot (Conclusions) ----

load("data/model-results.RData")

data_models_hc <- data_models |> 
  filter(category == "Hard coral" & level == "global")

data_hist_ref <- data_models_hc |> 
  filter(year >= 1980 & year <= 2009) |> 
  summarise(across(c(mean, lower_ci_95, upper_ci_95), ~round(mean(.x), 2)))

data_simulation <- data_simulation |> 
  rename(year = time) |> 
  mutate(year = year+2023,
         coral_cover = round(coral_cover*100, 2),
         scenario = case_when(scenario == "1years recovery period" ~ "1 year",
                              scenario == "2years recovery period" ~ "2 years",
                              scenario ==  "4years recovery period" ~ "4 years",
                              scenario == "10years recovery period" ~ "10 years"),
         scenario = factor(scenario, levels = c("10 years", "4 years", "2 years", "1 year")))

plot_i <- ggplot() +
  geom_ribbon(data = data_models_hc, aes(x = year, ymin = lower_ci_80, ymax = upper_ci_80),
              alpha = 0.35, color = NA, fill = "#747d8c") +
  geom_ribbon(data = data_models_hc, aes(x = year, ymin = lower_ci_95, ymax = upper_ci_95),
              alpha = 0.45, color = NA, fill = "#747d8c") +
  geom_line(data = data_models_hc, aes(x = year, y = mean), color = "#0C2F3B") +
  geom_line(data = data_simulation, aes(x = year, y = coral_cover, color = scenario,
                                        group = interaction(scenario, draw)), alpha = 0.1, linewidth = 0.5) +
  scale_color_manual(values = c("1 year" = palette_second[5],
                                "2 years" = palette_second[4],
                                "4 years" = palette_second[3],
                                "10 years" = palette_second[2]),
                     name = "Recovery window",
                     guide = guide_legend(override.aes = list(alpha = 1, linewidth = 1))) +
  annotate(geom = "segment", x = 1980, xend = 2075, y = 30.21, yend = 30.21,
           linetype = "dashed", colour = "#747d8c") +
  annotate("text", x = 2075, y = 30.21, label = "Reference period",
           hjust = 1, vjust = -1, size = 4.5, colour = "black", family = font_choose_graph) +
  theme_graph() +
  theme(panel.background = element_rect(fill = "transparent", colour = NA),
        plot.background = element_rect(fill = "transparent", colour = NA),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        panel.grid = element_blank(),
        axis.line.y = element_line(linewidth = 0.4),
        legend.position = c(0.06, 0.06),
        legend.justification = c(0, 0),
        legend.direction = "vertical",
        legend.background = element_blank(),
        legend.key = element_blank(),
        legend.title = element_text(family = font_choose_graph),
        legend.text = element_text(family = font_choose_graph)) +
  scale_x_continuous(breaks = seq(1980, 2075, 10),
                     limits = c(1979, 2076),
                     labels = seq(1980, 2075, 10)) +
  scale_y_continuous(limits = c(0, 40)) +
  labs(x = "Year", y = "Hard coral cover (%)")

ggsave("figs/10_conclusions/future_trajectories.pdf", height = 5, width = 8.5)

ggsave("figs/10_conclusions/future_trajectories.png", bg = "transparent",
       dpi = fig_resolution, height = 5, width = 8.5)
