# 1. Load packages ----

library(tidyverse)
library(qrcode)

# 2. Create a function to generate the QR codes ----

create_qrcode <- function(url,
                          output,
                          width = 3,
                          height = 3) {
  
  # Generate the QR code
  mat <- qrcode::qr_code(url, ecl = "H")
  
  # Convert the matrix
  df <- expand.grid(x = seq_len(ncol(mat)),
                    y = seq_len(nrow(mat)))
  
  df$fill <- ifelse(as.vector(mat), "black", NA_character_)
  
  # Create the plot
  plot <- ggplot(df) +
    geom_tile(aes(x = x, y = -y, fill = fill), colour = NA) +
    scale_fill_identity(na.value = "transparent", guide = "none") +
    coord_equal(expand = FALSE) +
    theme_void() +
    theme(plot.margin = margin(0, 0, 0, 0),
          plot.background = element_rect(fill = "transparent", colour = NA),
          panel.background = element_rect(fill = "transparent", colour = NA))
  
  # Export
  ggsave(filename = output,
         plot = plot,
         width = width,
         height = height,
         bg = "transparent")
  
}

# 3. Produce QR codes ----

## 3.1 GitHub repository ----

create_qrcode(url = "https://github.com/GCRMN/global_2025",
              output = "figs/00_misc/qrcode_github.pdf")

## 3.2 Zenodo repository ----

create_qrcode(url = "https://zenodo.org/",
              output = "figs/00_misc/qrcode_zenodo.pdf")

## 3.3 GCRMN website landing page ----
