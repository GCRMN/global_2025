map_sphere <- function(region_i){
  
  longitude <- data_parameters %>% 
    filter(region == region_i) %>% 
    select(longitude) %>% 
    pull()
  
  g <- as_s2_geography(TRUE)
  co <- data_land
  oc <- s2_difference(g, s2_union_agg(co)) # oceans
  b <- s2_buffer_cells(as_s2_geography(paste0("POINT(", longitude," 0)")), 9800000) # visible half
  i <- s2_intersection(b, oc) # visible ocean
  
  i <- i %>% 
    st_as_sfc() %>% 
    st_transform(., paste0("+proj=ortho +lat_0=0 +lon_0=", longitude))
  
  b <- b %>% 
    st_as_sfc() %>% 
    st_transform(., paste0("+proj=ortho +lat_0=0 +lon_0=", longitude))
  
  data_graticules <- st_intersection(data_graticules,
                                     i %>% st_transform(crs = 4326) %>% st_make_valid()) %>% 
    st_transform(., paste0("+proj=ortho +lat_0=0 +lon_0=", longitude))
  
  data_region_i <- data_region %>% 
    filter(region == region_i) %>% 
    st_as_sfc() %>% 
    st_transform(., paste0("+proj=ortho +lat_0=0 +lon_0=", longitude))
  
  data_region_all <- data_region %>% 
    filter(region != region_i) %>% 
    st_as_sfc() %>% 
    st_transform(., paste0("+proj=ortho +lat_0=0 +lon_0=", longitude))
  
  plot_i <- ggplot() +
    geom_sf(data = b, fill = "#0C2F3B", col = "black", linewidth = 0.3) +
    geom_sf(data = i, fill = "#F2F2F2") +
    geom_sf(data = data_graticules, color = "white", linewidth = 1) +
    geom_sf(data = data_region_i, color = NA, fill = "#40A6AA", alpha = 0.75) +
    geom_sf(data = b, fill = NA, col = "#363737", linewidth = 0.4) +
    theme_minimal() +
    theme(axis.text = element_blank(),
          axis.ticks = element_blank(),
          plot.background = element_rect(fill = "transparent", color = NA),
          panel.background = element_rect(fill = "transparent", color = NA))
  
  ggsave(paste0("figs/03_part-2/fig-0/",
                str_replace_all(str_to_lower(region_i), " ", "-"), "_sphere.png"),
         bg = "transparent")
  
}
