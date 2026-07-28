# 1. Required packages ----

library(scico)
library(sysfonts)
library(showtext)
library(showtextdb)

# 2. Set the default font family ----

if(FALSE){
  
  # To list the available fonts: systemfonts::system_fonts()
  font_add(family = "pagella",
           regular = "report/fonts/tex-gyre-pagella/texgyrepagella-regular.otf",
           bold = "report/fonts/tex-gyre-pagella/texgyrepagella-bold.otf",
           italic = "report/fonts/tex-gyre-pagella/texgyrepagella-italic.otf",
           bolditalic = "report/fonts/tex-gyre-pagella/texgyrepagella-bolditalic.otf")
  
  font_choose_graph <- "pagella"
  font_choose_map <- "pagella"
  
}

font_add_google("Roboto", "Roboto") # Add a font from Google Font

font_choose_graph <- "Roboto"
font_choose_map <- "Roboto"

fig_resolution <- 300

showtext::showtext_auto()
showtext::showtext_opts(dpi = fig_resolution)

# 3. Set the colors ----

palette_first <- scico(5, palette = "oslo", begin = 0.8, end = 0)
palette_second <- c("#fac484", "#f8a07e", "#ce6693", "#a059a0", "#5c53a5")

# palette_second taken from https://carto.com/carto-colors/ (SunsetDark)
