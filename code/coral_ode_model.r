# Coral Cover ODE Model
# Description: Ordinary Differential Equation model for coral cover dynamics over time
# Uses deSolve package for numerical integration
# Author: Manuel Gonzalez-Rivero
# Organisation: Australian Institute of Marine Science
# Date: 01/05/2026
# 

# Install packages if needed
# install.packages("deSolve")
# install.packages("ggplot2")

library(deSolve)
library(ggplot2)
library(tidyverse)

# ============================================================================
# Load Parameters from Estimated Growth and Mortality Rates
# ============================================================================
# Reviewing temporal series of Hard Coral Cover we have identified periods of growth or decline in coral cover 
contrasts <- read_csv("model_results/contrast_periods.csv")  |> 
mutate(Contrast=sprintf("%s (%s)", Contrast, Event_period)) |> 
select(Contrast, Behaviour, n_years)

# From the Bayesian model contrasts, we have estimated rates of change to parameterised the ODE model
rates <- readRDS("model_results/contrasts_list.rds")$contrasts_GBEs |> 
left_join(contrasts, by=c("Contrast"))  |> 
mutate(rate=rel/n_years) |> select(.draw, Contrast, Behaviour, rate) |> 
group_by(.draw,Behaviour) |>
summarise(rate=mean(rate)) |> ungroup()


# ============================================================================
# ODE Model Definition
# ============================================================================

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

# ============================================================================
# Disturbance Function
# ============================================================================

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
  d=d[time] # Return disturbance value for the current time step
  
  return(d)
}


# ============================================================================
# Set Parameters
# ============================================================================

## 1GBE every 10 years. 
#Ecological parameters
parameters <- c(
  r_max = 0.00913,#0.0151,           # Maximum intrinsic growth rate (per year) (Base on GCRMN Max Recovery rates)
  K_capacity = 0.50,      # Carrying capacity - max sustainable coral cover (80%)
  m_base = 0.00,          # Baseline mortality rate
  m_stress = 0.0382,#0.12,         # Stress-induced mortality coefficient (max coral loss = 12%)
  recovery_rate = 0.0   # Recovery rate from disturbed areas. Given growth is already defining recovery, we set this to 0 to avoid double counting recovery processes
)

# Initial conditions
initial_state <- c(C = 0.26)  # Start with 26% coral cover (as per GCRMN Report 2025)

# Time sequence (years)
n=50
times <- seq(1, n, by = 1)  # 50 years, yearly time steps

# ============================================================================
# Solve ODE using Runge-Kutta method for different disturbance scenarios and posterior parameter sets
# ============================================================================

for (rwindow in c( 1, 2, 4, 10)) { # Loop through different recovery windows 

  for (i in 1:1000) { # Loop through 1000 posterior samples of growth and mortality rates
    draw_id=sample(rates$.draw, 1) #sample draws to pair growth and mortality rates for the same posterior sample
    parameters["r_max"] <- rates  |>  filter(.draw==draw_id, Behaviour=="Recovery") |> pull(rate) # sample growth rate based on posterior samples
    parameters["m_stress"] <- abs(rates  |>  filter(.draw==draw_id, Behaviour=="Mortality") |> pull(rate))  # sample mortality rate based on posterior samples  
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
  res <- res  |> mutate(scenario = paste0(rwindow, "years recovery period"), draw = i) # Add scenario and draw number for later analysis
  
  # Combine results
  if (rwindow == 1 && i == 1) {
    coral_data <- res
  } else {
    coral_data <- bind_rows(coral_data, res)
  }
}
}


# ============================================================================
# Visualize Results
# ============================================================================


# Create plot
p <-coral_data  |>  group_by(scenario, time)  |> select(-draw) |>
  summarise_draws(
    median = median,
    lower = ~quantile(., 0.025),
    upper = ~quantile(., 0.975)
  )  |> rename(lower=`2.5%`, upper=`97.5%`) |>
  ggplot(aes(x = time, y = median, color = scenario)) +
  geom_line(size = 1) +
  geom_ribbon(aes(ymin = lower, ymax = upper, fill = scenario), alpha = 0.2) +
  geom_hline(yintercept = 0.10, linetype = "dashed", 
             color = "darkgrey", alpha = 0.7, size = 2) +
  labs(
    title = "Coral Cover Dynamics Over Time",
    x = "Time (years)",
    y = "Coral Cover (%)",
    subtitle = "ODE Model with Disturbance Events"
  ) +
  ylim(0, 0.35) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme_classic() +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 11, color = "gray50"),
    axis.title = element_text(size = 12)
  )

 

ggsave("fig/coral_cover_trajectories_new.png", plot = p, width =  8, height = 5, dpi = 300)

# ============================================================================
# Export Results
# ============================================================================

# Save results to RDS
saveRDS(coral_data, "model_results/coral_cover_simulations_uncertainty.rds")


# ##Hindcast coral trajectories to parameterise the model and compare to observed coral cover trajectories.
# # Initial conditions
# initial_state <- c(C = 0.30)  # Start with 30% coral cover 1985 (as per GCRMN Report 2025)

# # Time sequence (years)
# times <- seq(0, 39, by = 1)  # 39 years, yearly time steps (1985-2024)

# # Define a time-varying disturbance (bleaching) following previous GBE patterns (e.g., 1998, 2010, 2016, 2020)
# disturbance <- function(fGBE=1,time) {

#   d <- 0
#   if(time %in% c(2, 14,15, 25,26,27,30,31, 37,38)) {d<-1
#   }else{ d<-0
#     # Example: bleaching events at years 10 and 50
#   #if (time >= 10 && time <= 12) d <- 0.8  # High disturbance for 2 years
#   #if (time >= 50 && time <= 52) d <- 0.6  # Moderate disturbance
#   }

#   return(d)
# }

# #Run model with historical disturbance pattern
# output <- ode(
#   y = initial_state,
#   times = times,
#   func = coral_ode,
#   parms = c(parameters, fGBE = 1), # fGBE is not used in this case since we are defining disturbance directly in the function
#   method = "rk4"
# )

# hist_output <- as.data.frame(output)
# names(hist_output) <- c("time", "coral_cover")  
# hist_output <- hist_output  |> mutate(scenario = "Historical Disturbance")
# # Convert to percentage for plotting
# hist_output$coral_cover_pct <- hist_output$coral_cover * 100

# hist_output <- hist_output |> mutate(Year = time + 1985) |> select(-time) |> 
# rename(median=coral_cover) |> mutate(lower=median, upper=median, scenario="Observed") |> 
# select(Year, median, lower, upper, scenario)




# hist_OBS<-readRDS("model_results/contrasts_global.rds")
# hist_OBS<-hist_OBS$posteriors[[1]]   |> 
# group_by(Year) |> 
# summarise_draws(
#     median = median,
#     lower = ~quantile(., 0.025),
#     upper = ~quantile(., 0.975)
#   ) |> 
#   rename(lower=`2.5%`, upper=`97.5%`) |> 
#   mutate(scenario="Historical hindcast") |> 
# select(Year, median, lower, upper, scenario)

# df<-rbind(hist_OBS, hist_output) 


# # Create plot
# p.H <- ggplot(df, aes(x = Year, y = median, color = scenario)) +
#   geom_line(size = 1, aes(group = scenario)) +
#   geom_hline(yintercept = 10, linetype = "dashed", 
#              color = "darkgrey", alpha = 0.7, size = 2) +
#   #geom_vline(xintercept = c(10, 50), linetype = "dashed", 
#    #          color = "red", alpha = 0.5, size = 1) +
#   # annotate("text", x = 10, y = 95, label = "Bleaching Event 1", 
#   #          angle = 90, vjust = -0.5, color = "red") +
#   # annotate("text", x = 50, y = 95, label = "Bleaching Event 2", 
#   #          angle = 90, vjust = -0.5, color = "red") +
#   labs(
#     title = "Coral Cover Dynamics Over Time",
#     x = "Time (years)",
#     y = "Coral Cover (%)",
#     subtitle = "ODE Model with Disturbance Events"
#   ) +
#   ylim(0.2, 0.35) +
#   theme_classic() +
#   theme(
#     plot.title = element_text(size = 14, face = "bold"),
#     plot.subtitle = element_text(size = 11, color = "gray50"),
#     axis.title = element_text(size = 12)
#   )

# print(p.H)
# ggsave("fig/hindcasted_trajectories.png", plot = p.H, width = 8, height = 5, dpi = 300)
