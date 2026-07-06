# 1. Load packages ----

library(tidyverse) # Core tidyverse packages
library(patchwork)
library(ggtext)
library(sf)
sf_use_s2(FALSE)

# 2. Source functions ----

source("code/function/graphical_par.R")
source("code/function/theme_graph.R")

# 3. Load data ----

load("data/model-results.RData")

# 4. Figure 1 - Hard coral cover ----

## 4.1 Load data ----

data_models_hc <- data_models |> 
  filter(category == "Hard coral" & level == "global") |> 
  mutate(color = "#c44d56")

data_languages <- tibble(language = c("EN",
                                      "ES",
                                      "FR"),
                         y_axis = c("Hard coral cover (%)",
                                    "Cobertura bentónica (%)",
                                    "Couverture corallienne (%)"),
                         x_axis = c("Year",
                                    "Año",
                                    "Année"),
                         title = c("Changes in <span style='color:#FFFFFF'>hard coral cover</span> at the global<br>scale from 1980 to 2024",
                                   "Cambio en la cobertura de <span style='color:#FFFFFF'>coral pétreo</span> a escala<br>mundial entre 1980 y 2024",
                                   "Évolution du recouvrement en <span style='color:#FFFFFF'>coraux durs</span> à l'échelle<br>mondiale de 1980 à 2024"),
                         subtitle = c("The bold line represents the median, while the<br>ribbons indicate the credible intervals at 95%",
                                      "La línea gruesa representa la mediana, mientras que las<br>bandas indican los intervalos creíbles al 95 %",
                                      "La ligne en gras représente la médiane, tandis que les bandes<br>indiquent les intervalles de crédibilité à 95 %"))

## 4.2 Create the function ----

plot_exsum_hc <- function(language_i){
  
  data_languages_i <- data_languages |> 
    filter(language == language_i)
  
  ggplot(data = data_models_hc, aes(x = year, fill = color, color = color)) +
    geom_ribbon(aes(ymin = lower_ci_95, ymax = upper_ci_95), alpha = 0.35, color = NA) +
    geom_line(aes(y = mean)) +
    scale_color_identity() +
    scale_fill_identity() +
    theme_graph() +
    theme(panel.background = element_rect(fill = "transparent", colour = NA),
          plot.background = element_rect(fill = "transparent", colour = NA),
          plot.title = element_markdown(color = "black", size = 18),
          plot.subtitle = element_markdown(color = "grey", size = 14)) +
    scale_x_continuous(breaks = seq(1980, 2025, 5),
                       limits = c(1979, 2026),
                       labels = seq(1980, 2025, 5)) +
    labs(x = unique(data_languages_i$x_axis), y = unique(data_languages_i$y_axis),
         title = unique(data_languages_i$title),
         subtitle = unique(data_languages_i$subtitle)) +
    annotate(geom = "label", x = 1995, y = 25, label = "-9.5%", size = 5, family = font_choose_graph,
             fill = "#c44d56", color = "white")
  
  ggsave(paste0("figs/01_ex-summ/hard-coral_", str_to_lower(language_i), ".png"), dpi = 300, height = 6, width = 9)
  
  ggsave(paste0("figs/01_ex-summ/hard-coral_", str_to_lower(language_i), ".pdf"), height = 6, width = 9)
  
}

## 4.3 Map over the function ----

map(unique(data_languages$language), ~plot_exsum_hc(language_i = .x))

# 5. Figure 2 - Macroalgal cover ----

## 5.1 Load data ----

data_models_ma <- data_models |> 
  filter(category == "Macroalgae" & level == "global") |> 
  mutate(color = "#03a678")

data_languages <- tibble(language = c("EN",
                                      "ES",
                                      "FR"),
                         y_axis = c("Macroalgal cover (%)",
                                    "Cobertura de macroalgas (%)",
                                    "Couverture en macroalgues (%)"),
                         x_axis = c("Year",
                                    "Año",
                                    "Année"),
                         title = c("Changes in <span style='color:#FFFFFF'>macroalgal cover</span> at the global<br>scale from 1980 to 2024",
                                   "Cambio en la cobertura de <span style='color:#FFFFFF'>macroalgas</span> a escala<br>mundial entre 1980 y 2024",
                                   "Évolution du recouvrement en <span style='color:#FFFFFF'>macroalgues</span> à l'échelle<br>mondiale de 1980 à 2024"),
                         subtitle = c("The bold line represents the median, while the<br>ribbons indicate the credible intervals at 95%",
                                      "La línea gruesa representa la mediana, mientras que las<br>bandas indican los intervalos creíbles al 95 %",
                                      "La ligne en gras représente la médiane, tandis que les bandes<br>indiquent les intervalles de crédibilité à 95 %"))

## 5.2 Create the function ----

plot_exsum_ma <- function(language_i){
  
  data_languages_i <- data_languages |> 
    filter(language == language_i)
  
  ggplot(data = data_models_ma, aes(x = year, fill = color, color = color)) +
    geom_ribbon(aes(ymin = lower_ci_95, ymax = upper_ci_95), alpha = 0.35, color = NA) +
    geom_line(aes(y = mean)) +
    scale_color_identity() +
    scale_fill_identity() +
    theme_graph() +
    theme(panel.background = element_rect(fill = "transparent", colour = NA),
          plot.background = element_rect(fill = "transparent", colour = NA),
          plot.title = element_markdown(color = "black", size = 18),
          plot.subtitle = element_markdown(color = "grey", size = 14)) +
    scale_x_continuous(breaks = seq(1980, 2025, 5),
                       limits = c(1979, 2026),
                       labels = seq(1980, 2025, 5)) +
    labs(x = unique(data_languages_i$x_axis), y = unique(data_languages_i$y_axis),
         title = unique(data_languages_i$title),
         subtitle = unique(data_languages_i$subtitle)) +
    annotate(geom = "label", x = 1990, y = 7, label = "+44.1%", size = 5, family = font_choose_graph,
             fill = "#03a678", color = "white")
  
  ggsave(paste0("figs/01_ex-summ/macroalgae_", str_to_lower(language_i), ".png"), dpi = 300, height = 6, width = 9)
  
  ggsave(paste0("figs/01_ex-summ/macroalgae_", str_to_lower(language_i), ".pdf"), height = 6, width = 9)
  
}

## 5.3 Map over the function ----

map(unique(data_languages$language), ~plot_exsum_ma(language_i = .x))

# 6. Figure 3 - Regional trends ----

crs_map <- "+proj=eqearth +lon_0=160"

## 6.1 Load Natural Earth Data ----

data_country <- st_read("data/01_maps/01_raw/03_natural-earth/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp") %>% 
  st_wrap_dateline(options = "WRAPDATELINE=YES") %>%
  st_transform(crs_map)

data_graticules <- st_read("data/01_maps/01_raw/03_natural-earth/ne_10m_graticules_20/ne_10m_graticules_20.shp")%>% 
  st_transform(crs = crs_map)

## 6.2 Change projection of GCRMN regions ----

data_gcrmn_regions <- st_read("data/01_maps/02_clean/03_regions/gcrmn_regions.shp") %>% 
  st_transform(crs = crs_map)

## 6.3 Create the border of background map ----

lats <- c(90:-90, -90:90, 90)
longs <- c(rep(c(180, -180), each = 181), 180)

background_map_border <- list(cbind(longs, lats)) %>%
  st_polygon() %>%
  st_sfc(crs = 4326) %>% 
  st_sf() %>%
  st_transform(crs = crs_map)

## 6.4 Create the plot ----

ggplot() +
  geom_sf(data = background_map_border, fill = "white", color = "grey30", linewidth = 0.25) +
  geom_sf(data = data_graticules, color = "#ecf0f1", linewidth = 0.25) +
  geom_sf(data = background_map_border, fill = NA, color = "grey30", linewidth = 0.25) +
  geom_sf(data = data_gcrmn_regions, aes(fill = region), show.legend = FALSE) +
  geom_sf(data = data_country, color = "#24252a", fill = "#dadfe1") +
  theme(text = element_text(family = "Open Sans"),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position = "bottom",
        legend.background = element_rect(fill = "transparent", color = NA),
        legend.title = element_blank(),
        panel.background = element_blank(),
        plot.background = element_rect(fill = "transparent", color = NA)) +
  guides(fill = guide_legend(override.aes = list(size = 5, color = NA))) +
  labs(title = "Regional trends in hard coral cover",
       subtitle = "The arrows indicate the trends")

#ggsave("figs/01_ex-summ/map_regions.png", bg = "transparent", height = 5, width = 8, dpi = 300)





# Couche natural earth sans country boundaries
# Supprimer trait vertical 180°
# Régler problèle trait horizontaux antarctique et groelendan
# Ajouter bordure extérieure


# créer icones en PDF
# Intégrer en Tikz


