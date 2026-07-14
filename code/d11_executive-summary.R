# 1. Load packages ----

library(tidyverse) # Core tidyverse packages
library(patchwork)
library(ggtext)
library(sf)
sf_use_s2(FALSE)
library(patchwork)
library(colorspace)

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
                                      "SP",
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
          plot.title = element_markdown(color = "black", size = 18, lineheight = 1.2),
          plot.subtitle = element_markdown(color = "grey", size = 14)) +
    scale_x_continuous(breaks = seq(1980, 2025, 5),
                       limits = c(1979, 2026),
                       labels = seq(1980, 2025, 5)) +
    labs(x = unique(data_languages_i$x_axis), y = unique(data_languages_i$y_axis),
         title = unique(data_languages_i$title),
         subtitle = unique(data_languages_i$subtitle)) +
    annotate(geom = "label", x = 1995, y = 25, label = "-9.5%", size = 5, family = font_choose_graph,
             fill = "#c44d56", color = "white")
  
  ggsave(paste0("figs/01_ex-summ/hard-coral_", str_to_lower(language_i), "_raw.pdf"), height = 6, width = 9)
  
}

## 4.3 Map over the function ----

map(unique(data_languages$language), ~plot_exsum_hc(language_i = .x))

# 5. Figure 2 - Macroalgal cover ----

## 5.1 Load data ----

data_models_ma <- data_models |> 
  filter(category == "Macroalgae" & level == "global") |> 
  mutate(color = "#03a678")

data_languages <- tibble(language = c("EN",
                                      "SP",
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
          plot.title = element_markdown(color = "black", size = 18, lineheight = 1.2),
          plot.subtitle = element_markdown(color = "grey", size = 14)) +
    scale_x_continuous(breaks = seq(1980, 2025, 5),
                       limits = c(1979, 2026),
                       labels = seq(1980, 2025, 5)) +
    scale_y_continuous(limits = c(3, 9)) +
    labs(x = unique(data_languages_i$x_axis), y = unique(data_languages_i$y_axis),
         title = unique(data_languages_i$title),
         subtitle = unique(data_languages_i$subtitle)) +
    annotate(geom = "label", x = 1990, y = 7, label = "+44.1%", size = 5, family = font_choose_graph,
             fill = "#03a678", color = "white")
  
  ggsave(paste0("figs/01_ex-summ/macroalgae_", str_to_lower(language_i), "_raw.pdf"), height = 6, width = 9)
  
}

## 5.3 Map over the function ----

map(unique(data_languages$language), ~plot_exsum_ma(language_i = .x))

# 6. Figure 3 - Regional trends ----

## 6.1 Create the data ----

pal <- colorRampPalette(c("#C44D56", "#E6E6E6", "#013C5E"))(101)

data_arrow <- tibble(region = c("Australia", "Brazil", "Caribbean", "EAS", "ETP", "Pacific", "RSGA", "ROPME", "South Asia", "WIO"),
                     position = c("Bottom", "Bottom", "Top", "Top", "Bottom", "Bottom", "Top", "Top", "Top", "Bottom"),
                     x = 1,
                     y = 1,
                     change = c(-10.9, 0, -43.4, 0, 0, -18.3, -12.5, -48.7, 16.2, 31.0),
                     color = pal[pmax(1, pmin(101, round(change) + 51))],
                     change_label = case_when(change == 0 ~ "No change",
                                              change < 0 ~ paste0(change, "%"),
                                              change > 0 ~ paste0("+", change, "%"))) |> 
  mutate(angle = 90 * change / 100,
         length = 0.2,
         xstart = x - length * cos(angle * pi / 180),
         ystart = y - length * sin(angle * pi / 180),
         xend = x + length * cos(angle * pi / 180),
         yend = y + length * sin(angle * pi / 180))

## 6.2 Make the map ----

crs_selected <- st_crs("+proj=eqc +x_0=0 +y_0=0 +lat_0=0 +lon_0=160")

offset <- 180 - 160

polygon <- st_polygon(x = list(rbind(
  c(-0.0001 - offset, 90),
  c(0 - offset, 90),
  c(0 - offset, -90),
  c(-0.0001 - offset, -90),
  c(-0.0001 - offset, 90)))) %>%
  st_sfc() %>%
  st_set_crs(4326)

data_countries <- st_read("data/01_maps/01_raw/03_natural-earth/ne_10m_land/ne_10m_land.shp")
  
data_countries <- st_crop(x = data_countries, 
                          y = st_as_sfc(st_bbox(c(xmin = -180, ymin = -48, xmax = 180, ymax = 48), crs = 4326))) %>%
  st_difference(polygon) %>%
  st_transform(crs = crs_selected)

data_region <- read_sf("data/01_maps/02_clean/03_regions/gcrmn_regions.shp")

data_region_pac <- data_region %>% 
  filter(region == "Pacific") %>% 
  st_difference(polygon) %>% 
  st_transform(crs = crs_selected)

data_region_pac %<>% # Special pipe from magrittr
  st_buffer(10) %>% # To join polygon (remove vertical line)
  nngeo::st_remove_holes(.)

data_region <- data_region %>% 
  filter(region != "Pacific") %>% 
  st_difference(polygon) %>% 
  st_transform(crs = crs_selected) %>% 
  bind_rows(., data_region_pac) %>% 
  mutate(region = case_when(region == "PERSGA" ~ "RSGA",
                            TRUE ~ region)) %>%
  left_join(., data_arrow %>% select(region, color))

data_tropics <- tibble(tropic = c("Cancer", "Cancer", "Equator", "Equator", "Capricorn", "Capricorn"),
                       lat = c(23.4366, 23.4366, 0, 0, -23.4366, -23.4366),
                       long = c(-180, 180, -180, 180, -180, 180)) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>%
  group_by(tropic) %>%
  dplyr::summarize(do_union = FALSE) %>%
  st_cast("LINESTRING") %>% 
  st_difference(polygon) %>%
  st_transform(crs = crs_selected)

plot_map <- ggplot() +
  geom_sf(data = data_tropics, linetype = "dashed", col = "lightgrey", linewidth = 0.3) +
  geom_sf(data = data_region, aes(fill = color), color = "black",
          show.legend = FALSE, alpha = 1, linewidth = 0.25) +
  scale_fill_identity() +
  geom_sf(data = data_countries, fill = "#2f3542", color = "#2f3542") +
  coord_sf(ylim = c(-5000000, 5000000), expand = FALSE,
           label_axes = list(top = "E", left = "N", right = "N", bottom = "E")) +
  theme(panel.border = element_rect(fill = NA, color = "black"),
        panel.background = element_rect(fill = "white"),
        panel.grid = element_blank(),
        plot.background = element_rect(fill = "transparent", color = NA),
        axis.ticks = element_blank(),
        axis.text = element_blank())

plot_spacer() + plot_map + plot_spacer() + 
  plot_layout(ncol = 1, heights = c(0.5, 1, 0.5)) + 
  plot_annotation(title = "Comparison of relative changes in hard coral cover between 1980-2009\nto 2020-2024 across the ten GCRMN regions",
                  theme = theme(plot.title = element_text(size = 18, hjust = 0, vjust = 1,
                                                          lineheight = 1.2, margin = margin(b = 7.5),
                                                          family = font_choose_graph))) &
  theme(plot.background  = element_rect(fill = "transparent", colour = NA),
        panel.background = element_rect(fill = "transparent", colour = NA))

ggsave("figs/01_ex-summ/map_regions_raw.png", bg = "transparent", height = 6, width = 9, dpi = 300)

## 6.3 Arrows ----

plot_arrow <- function(region_i){
  
  plot_i <- ggplot(data = data_arrow |> filter(region == region_i)) +
    geom_point(aes(x = x, y = y, color = color), size = 35, shape = 19) +
    scale_color_identity() +
    geom_segment(aes(x = xstart, y = ystart, xend = x, yend = y, color = "black"),
                 linewidth = 1) +
    geom_segment(aes(x = x, y = y, xend = xend, yend = yend, color = "black"),
                 linewidth = 1, arrow = arrow(length = unit(0.25, "cm"), type = "closed", angle = 25)) +
    scale_x_continuous(limits = c(0,2), expand = expansion(mult = 0)) +
    scale_y_continuous(limits = c(0,2), expand = expansion(mult = 0)) +
    coord_equal(clip = "off") +
    theme_void() +
    theme(legend.position = "none",
          plot.margin = margin(0, 0, 0, 0)) 
  
  ggsave(paste0("figs/01_ex-summ/arrow_", str_replace_all(str_to_lower(region_i), " ", "-"), ".png"),
         bg = "transparent", height = 3, width = 3)
  
}

walk(unique(data_region$region), ~plot_arrow(region_i = .x))

# 7. Figure 4 - Future trajectories ----

data_models_hc <- data_models |> 
  filter(category == "Hard coral" & level == "global") |> 
  mutate(color = "black")

data_languages <- tibble(language = c("EN",
                                      "SP",
                                      "FR"),
                         y_axis = c("Macroalgal cover (%)",
                                    "Cobertura de macroalgas (%)",
                                    "Couverture en macroalgues (%)"),
                         x_axis = c("Year",
                                    "Año",
                                    "Année"),
                         title = c("Hypothetical trajectories of hard coral cover<br>through 2100 under various scenarios",
                                   "Trayectorias hipotéticas de la cobertura de coral<br>para el año 2100 bajo diferentes escenarios",
                                   "Trajectoires hypothétiques de la couverture corallienne<br>d'ici à 2100 sous différents scénarios"))

data_1a <- spline(x = c(2024, 2060, 2100),
                 y = c(24.64, 10, 2),
                 xout = 2024:2100,
                 method = "natural") |>
  as_tibble()

data_1b <- spline(x = c(2024, 2050, 2100),
                 y = c(27.01, 16, 8),
                 xout = 2024:2100,
                 method = "natural") |>
  as_tibble()

data_1 <- left_join(data_1a |> rename(y_min = y), data_1b |> mutate(y_max = y)) |> 
  rename(year = x) |> 
  mutate(type = "Business as usual",
         color = "#5c53a5")

data_2a <- spline(x = c(2024, 2060, 2100),
                  y = c(24.64, 13.5, 9),
                  xout = 2024:2100,
                  method = "natural") |>
  as_tibble()

data_2b <- spline(x = c(2024, 2050, 2100),
                  y = c(27.01, 18.5, 14),
                  xout = 2024:2100,
                  method = "natural") |>
  as_tibble() 

data_2 <- left_join(data_2a |> rename(y_min = y), data_2b |> mutate(y_max = y)) |> 
  rename(year = x) |> 
  mutate(type = "Local management",
         color = "#a059a0")

data_3a <- spline(x = c(2024, 2070, 2100),
                  y = c(24.64, 17, 19),
                  xout = 2024:2100,
                  method = "natural") |>
  as_tibble()

data_3b <- spline(x = c(2024, 2070, 2100),
                  y = c(27.01, 20, 24),
                  xout = 2024:2100,
                  method = "natural") |>
  as_tibble() 

data_3 <- left_join(data_3a |> rename(y_min = y), data_3b |> mutate(y_max = y)) |> 
  rename(year = x) |> 
  mutate(type = "Climate change + Local management",
         color = "#ce6693")

data_trajectories <- bind_rows(data_1, data_2, data_3)

rm(data_1a, data_1b, data_1, data_2a, data_2b, data_2, data_3a, data_3b, data_3)

plot_exsum_trajectories <- function(language_i){
  
  data_languages_i <- data_languages |> 
    filter(language == language_i)
  
  ggplot() +
    geom_ribbon(data = data_models_hc, aes(x = year, ymin = lower_ci_95, ymax = upper_ci_95), alpha = 0.6, color = NA) +
    #geom_line(data = data_models_hc, aes(x = year, y = mean)) +
    geom_ribbon(data = data_trajectories, aes(x = year, ymin = y_min, ymax = y_max, fill = color), alpha = 0.6, color = NA) +
    scale_color_identity() +
    scale_fill_identity() +
    theme_graph() +
    theme(panel.background = element_rect(fill = "transparent", colour = NA),
          plot.background = element_rect(fill = "transparent", colour = NA),
          plot.title = element_markdown(color = "black", size = 18, lineheight = 1.2),
          plot.subtitle = element_markdown(color = "grey", size = 14),
          axis.title.y = element_blank(),
          axis.text.y = element_blank()) +
    scale_x_continuous(breaks = seq(1980, 2100, 10),
                       limits = c(1979, 2101),
                       labels = seq(1980, 2100, 10)) +
    scale_y_continuous(limits = c(0, 40)) +
    labs(x = unique(data_languages_i$x_axis), y = unique(data_languages_i$y_axis),
         title = unique(data_languages_i$title))
  
  ggsave(paste0("figs/01_ex-summ/trajectories_", str_to_lower(language_i), "_raw.pdf"), height = 6, width = 9)
  
}

map(unique(data_languages$language), ~plot_exsum_trajectories(language_i = .x))
