
<!-- README.md is generated from README.Rmd. Please edit that file -->

# **Status of Coral Reefs of the World: 2025**

## 1. Introduction [<img src='misc/2025-11-17_report-page-cover.jpg' align="right" height="300" />](https://gcrmn.net/2025-report/)

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus.
Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies
sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius
a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy
molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat.
Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium
a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra
tempor. Cras vestibulum bibendum augue. Praesent egestas leo in pede.
Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit
sodales. Vestibulum ante ipsum primis in faucibus orci luctus et
ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede
pellentesque fermentum. Maecenas adipiscing ante non diam sodales
hendrerit.

Ut velit mauris, egestas sed, gravida nec, ornare ut, mi. Aenean ut orci
vel massa suscipit pulvinar. Nulla sollicitudin. Fusce varius, ligula
non tempus aliquam, nunc turpis ullamcorper nibh, in tempus sapien eros
vitae ligula. Pellentesque rhoncus nunc et augue. Integer id felis.
Curabitur aliquet pellentesque diam. Integer quis metus vitae elit
lobortis egestas. Lorem ipsum dolor sit amet, consectetuer adipiscing
elit. Morbi vel erat non mauris convallis vehicula. Nulla et sapien.
Integer tortor tellus, aliquam faucibus, convallis id, congue eu, quam.
Mauris ullamcorper felis vitae erat. Proin feugiat, augue non elementum
posuere, metus purus iaculis lectus, et tristique ligula justo vitae
magna.

Aliquam convallis sollicitudin purus. Praesent aliquam, enim at
fermentum mollis, ligula massa adipiscing nisl, ac euismod nibh nisl eu
lectus. Fusce vulputate sem at sapien. Vivamus leo. Aliquam euismod
libero eu enim. Nulla nec felis sed leo placerat imperdiet. Aenean
suscipit nulla in justo. Suspendisse cursus rutrum augue. Nulla
tincidunt tincidunt mi. Curabitur iaculis, lorem vel rhoncus faucibus,
felis magna fermentum augue, et ultricies lacus lorem varius purus.
Curabitur eu amet.

## 2. Code

### Cleaning and selection (`a_`)

- `a01_select_benthic-data.R` Extract benthic cover data from
  [gcrmndb_benthos](https://github.com/GCRMN/gcrmndb_benthos).
- `a02_clean_intersect-reefs.R`
- `a03_benthic-data_sources.R` Extract lists of datasetID and
  contributors details.
- `a04_clean_buffer-reefs.js` Create coral reef buffer polygons at 5,
  20, 50, and 100 km using [GEE](https://earthengine.google.com/).
- `a05_clean_cyclones.R` Clean cyclones data.
- `a06_download_crw-year.R`

### Indicators’ extraction (`b_`)

- `b01_extract_population.js` Extract population indicators using
  [GEE](https://earthengine.google.com/).
- `b02_extract_crw.R` Extract SST indicators.
- `b03_extract_cyclones.R` Extract cyclones indicators.
- `b04_region-characteristics.R` Extract region characteristics.

### Models (benthic cover) (`c_`)

- `c01_explo_benthic-data.qmd` Exploratory analyses of benthic cover
  data.
- `c02_select_pred-sites.R`  
- `c03_extract_predictor_gee.js`
- `c04_extract_predictor_gravity.R`
- `c05_extract_predictor_enso.R`
- `c06_extract_predictor_cyclones.R`
- `c07_extract_predictor_crw.R`
- `c08_model_data-preparation.R`
- `c09_xgboost-model.R`
- 
- `c11_format-results.R`

### Figures and tables (`d_`)

- `d01_geography-maps.R`  
- `d02_spatio-temporal.R`
- `d03_cyclones.R`
- `d04_crw.R`
- `d05_population.R`
- `d06_reef-extent.R`
- `d07_benthic-cover_trends.R`
- `d08_case-studies.R`

### Functions

- `data_descriptors.R` Get number of sites, surveys, datasets, first and
  last year of monitoring.
- `extract_coeff.R` Extract slope from linear regression.
- `graphical_par.R` Graphical parameters, including colors and fonts.
- `map_region_geography.R` Map of region (geography).
- `map_region_monitoring.R` Map of region (monitoring).
- `map_sphere.R` Map of region (sphere).
- `plot_trends_model.R` Plot temporal trends from models.
- `plot_trends_raw.R` Plot temporal trends from raw data.
- `prepare_benthic_data.R` Prepare benthic cover data for models.
- `theme_graph.R` Main ggplot theme for the plots of the reports.
- `theme_map.R` Main ggplot theme for the maps of the reports.

## 3. Reproducibility parameters

    ─ Session info ───────────────────────────────────────────────────────────────
     setting  value
     version  R version 4.6.0 (2026-04-24 ucrt)
     os       Windows 11 x64 (build 26200)
     system   x86_64, mingw32
     ui       RTerm
     language (EN)
     collate  French_France.utf8
     ctype    French_France.utf8
     tz       Europe/Paris
     date     2026-07-16
     pandoc   3.8.3 @ C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/ (via rmarkdown)
     quarto   1.9.38 @ C:\\PROGRA~1\\RStudio\\RESOUR~1\\app\\bin\\quarto\\bin\\quarto.exe

    ─ Packages ───────────────────────────────────────────────────────────────────
     ! package       * version date (UTC) lib source
       askpass         1.2.1   2024-10-04 [1] CRAN (R 4.6.0)
       backports       1.5.1   2026-04-03 [1] CRAN (R 4.6.0)
       base64enc       0.1-6   2026-02-02 [1] CRAN (R 4.6.0)
       bit             4.6.0   2025-03-06 [1] CRAN (R 4.6.0)
       bit64           4.8.2   2026-05-19 [1] CRAN (R 4.6.1)
       blob            1.3.0   2026-01-14 [1] CRAN (R 4.6.0)
       broom           1.0.13  2026-05-14 [1] CRAN (R 4.6.1)
       bslib           0.11.0  2026-05-16 [1] CRAN (R 4.6.1)
       cachem          1.1.0   2024-05-16 [1] CRAN (R 4.6.0)
       callr           3.8.0   2026-06-05 [1] CRAN (R 4.6.1)
       cellranger      1.1.0   2016-07-27 [1] CRAN (R 4.6.0)
       class           7.3-23  2025-01-01 [2] CRAN (R 4.6.0)
       classInt        0.4-11  2025-01-08 [1] CRAN (R 4.6.0)
       cli             3.6.6   2026-04-09 [1] CRAN (R 4.6.0)
       clipr           0.8.1   2026-05-25 [1] CRAN (R 4.6.1)
       conflicted      1.2.0   2023-02-01 [1] CRAN (R 4.6.0)
       cpp11           0.5.5   2026-05-06 [1] CRAN (R 4.6.1)
       crayon          1.5.3   2024-06-20 [1] CRAN (R 4.6.0)
       curl            7.1.0   2026-04-22 [1] CRAN (R 4.6.0)
       data.table      1.18.4  2026-05-06 [1] CRAN (R 4.6.1)
       DBI             1.3.0   2026-02-25 [1] CRAN (R 4.6.0)
       dbplyr          2.6.0   2026-06-17 [1] CRAN (R 4.6.1)
       digest          0.6.39  2025-11-19 [1] CRAN (R 4.6.0)
       dplyr           1.2.1   2026-04-03 [1] CRAN (R 4.6.0)
       dtplyr          1.3.3   2026-02-11 [1] CRAN (R 4.6.0)
       e1071           1.7-17  2025-12-18 [1] CRAN (R 4.6.0)
       evaluate        1.0.5   2025-08-27 [1] CRAN (R 4.6.0)
       farver          2.1.2   2024-05-13 [1] CRAN (R 4.6.0)
       fastmap         1.2.0   2024-05-15 [1] CRAN (R 4.6.0)
       fontawesome     0.5.3   2024-11-16 [1] CRAN (R 4.6.0)
       forcats         1.0.1   2025-09-25 [1] CRAN (R 4.6.0)
       fs              2.1.0   2026-04-18 [1] CRAN (R 4.6.0)
       gargle          1.6.1   2026-01-29 [1] CRAN (R 4.6.0)
       generics        0.1.4   2025-05-09 [1] CRAN (R 4.6.0)
       ggplot2         4.0.3   2026-04-22 [1] CRAN (R 4.6.0)
       glue            1.8.1   2026-04-17 [1] CRAN (R 4.6.0)
       googledrive     2.1.2   2025-09-10 [1] CRAN (R 4.6.0)
       googlesheets4   1.1.2   2025-09-03 [1] CRAN (R 4.6.0)
       gtable          0.3.6   2024-10-25 [1] CRAN (R 4.6.0)
       haven           2.5.5   2025-05-30 [1] CRAN (R 4.6.0)
       highr           0.12    2026-03-06 [1] CRAN (R 4.6.0)
       hms             1.1.4   2025-10-17 [1] CRAN (R 4.6.0)
       htmltools       0.5.9   2025-12-04 [1] CRAN (R 4.6.0)
       httr            1.4.8   2026-02-13 [1] CRAN (R 4.6.0)
       ids             1.0.1   2017-05-31 [1] CRAN (R 4.6.0)
       isoband         0.3.0   2025-12-07 [1] CRAN (R 4.6.0)
       jquerylib       0.1.4   2021-04-26 [1] CRAN (R 4.6.0)
       jsonlite        2.0.0   2025-03-27 [1] CRAN (R 4.6.0)
       KernSmooth      2.23-26 2025-01-01 [2] CRAN (R 4.6.0)
       knitr           1.51    2025-12-20 [1] CRAN (R 4.6.0)
       labeling        0.4.3   2023-08-29 [1] CRAN (R 4.6.0)
       lifecycle       1.0.5   2026-01-08 [1] CRAN (R 4.6.0)
       lubridate       1.9.5   2026-02-04 [1] CRAN (R 4.6.0)
       magrittr        2.0.5   2026-04-04 [1] CRAN (R 4.6.0)
       MASS            7.3-65  2025-02-28 [2] CRAN (R 4.6.0)
       memoise         2.0.1   2021-11-26 [1] CRAN (R 4.6.0)
       mime            0.13    2025-03-17 [1] CRAN (R 4.6.0)
       modelr          0.1.11  2023-03-22 [1] CRAN (R 4.6.0)
       openssl         2.4.2   2026-06-09 [1] CRAN (R 4.6.1)
       otel            0.2.0   2025-08-29 [1] CRAN (R 4.6.0)
       pillar          1.11.1  2025-09-17 [1] CRAN (R 4.6.0)
       pkgconfig       2.0.3   2019-09-22 [1] CRAN (R 4.6.0)
       prettyunits     1.2.0   2023-09-24 [1] CRAN (R 4.6.0)
       processx        3.9.0   2026-04-22 [1] CRAN (R 4.6.0)
       progress        1.2.3   2023-12-06 [1] CRAN (R 4.6.0)
       proxy           0.4-29  2025-12-29 [1] CRAN (R 4.6.0)
       ps              1.9.3   2026-04-20 [1] CRAN (R 4.6.0)
       purrr           1.2.2   2026-04-10 [1] CRAN (R 4.6.0)
       R6              2.6.1   2025-02-15 [1] CRAN (R 4.6.0)
       ragg            1.5.2   2026-03-23 [1] CRAN (R 4.6.0)
       rappdirs        0.3.4   2026-01-17 [1] CRAN (R 4.6.0)
       RColorBrewer    1.1-3   2022-04-03 [1] CRAN (R 4.6.0)
       Rcpp            1.1.2   2026-07-05 [1] CRAN (R 4.6.1)
       readr           2.2.0   2026-02-19 [1] CRAN (R 4.6.0)
       readxl          1.5.0   2026-05-16 [1] CRAN (R 4.6.1)
       rematch         2.0.0   2023-08-30 [1] CRAN (R 4.6.0)
       rematch2        2.1.2   2020-05-01 [1] CRAN (R 4.6.0)
       reprex          2.1.1   2024-07-06 [1] CRAN (R 4.6.0)
       rlang           1.3.0   2026-07-05 [1] CRAN (R 4.6.1)
       rmarkdown       2.31    2026-03-26 [1] CRAN (R 4.6.0)
       rstudioapi      0.19.0  2026-06-11 [1] CRAN (R 4.6.1)
       rvest           1.0.5   2025-08-29 [1] CRAN (R 4.6.0)
       s2              1.1.11  2026-06-01 [1] CRAN (R 4.6.1)
       S7              0.2.2   2026-04-22 [1] CRAN (R 4.6.0)
       sass            0.4.10  2025-04-11 [1] CRAN (R 4.6.0)
       scales          1.4.0   2025-04-24 [1] CRAN (R 4.6.0)
       selectr         0.6-0   2026-06-23 [1] CRAN (R 4.6.1)
       sf              1.1-1   2026-05-06 [1] CRAN (R 4.6.1)
       stringi         1.8.7   2025-03-27 [1] CRAN (R 4.6.0)
       stringr         1.6.0   2025-11-04 [1] CRAN (R 4.6.0)
       sys             3.4.3   2024-10-04 [1] CRAN (R 4.6.0)
       systemfonts     1.3.2   2026-03-05 [1] CRAN (R 4.6.0)
       textshaping     1.0.5   2026-03-06 [1] CRAN (R 4.6.0)
       tibble          3.3.1   2026-01-11 [1] CRAN (R 4.6.0)
     R tidymodels      <NA>    <NA>       [?] <NA>
       tidyr           1.3.2   2025-12-19 [1] CRAN (R 4.6.0)
       tidyselect      1.2.1   2024-03-11 [1] CRAN (R 4.6.0)
       tidyverse       2.0.0   2023-02-22 [1] CRAN (R 4.6.0)
       timechange      0.4.0   2026-01-29 [1] CRAN (R 4.6.0)
       tinytex         0.60    2026-06-16 [1] CRAN (R 4.6.1)
       tzdb            0.5.0   2025-03-15 [1] CRAN (R 4.6.0)
       units           1.0-1   2026-03-11 [1] CRAN (R 4.6.0)
       utf8            1.2.6   2025-06-08 [1] CRAN (R 4.6.0)
       uuid            1.2-2   2026-01-23 [1] CRAN (R 4.6.0)
       vctrs           0.7.3   2026-04-11 [1] CRAN (R 4.6.0)
       viridisLite     0.4.3   2026-02-04 [1] CRAN (R 4.6.0)
       vroom           1.7.1   2026-03-31 [1] CRAN (R 4.6.0)
       withr           3.0.3   2026-06-19 [1] CRAN (R 4.6.1)
       wk              0.9.5   2025-12-18 [1] CRAN (R 4.6.0)
       xfun            0.59    2026-06-19 [1] CRAN (R 4.6.1)
       xml2            1.6.0   2026-06-22 [1] CRAN (R 4.6.1)
       yaml            2.3.12  2025-12-10 [1] CRAN (R 4.6.0)

     [1] C:/Users/jerem/AppData/Local/R/win-library/4.6
     [2] C:/Program Files/R/R-4.6.0/library

     R ── Package was removed from disk.

    ──────────────────────────────────────────────────────────────────────────────
