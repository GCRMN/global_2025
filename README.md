
<!-- README.md is generated from README.Rmd. Please edit that file -->

# **Status of Coral Reefs of the World: 2025**

## 1. Introduction [<img src='misc/2025-11-17_report-page-cover.jpg' align="right" height="300" />](https://doi.org/10.59387/LFPR6347)

Coral reefs are increasingly threatened by anthropogenic activities,
from climate change-induced disturbances such as marine heatwaves to
local stressors including overfishing, pollution, and coastal
development. The cumulative impacts of these stressors have profoundly
altered the structure, function, and composition of coral reef
ecosystems worldwide. One of the most widely documented consequences is
the decline in hard coral cover, largely driven by the global coral
bleaching events recorded in 1998, 2010, 2016, and 2024. Beyond their
ecological consequences, the degradation of coral reefs undermines the
capacity of these ecosystems to provide essential services to human
populations, including coastal protection, food security through
fisheries, and income from tourism.

Established in 1995 as an operational network of the International Coral
Reef Initiative ([ICRI](https://icriforum.org/)), the Global Coral Reef
Monitoring Network ([GCRMN](https://gcrmn.net/)) plays a central role in
coordinating and strengthening coral reef monitoring worldwide. Working
through ten regional nodes, the GCRMN produces regular assessments of
the status and trends of coral reefs based on harmonised scientific data
collected by monitoring programmes around the world. Its mission is to
improve understanding of coral reef condition and change, support
evidence-based policy and management, and strengthen the technical and
human capacity for reef monitoring at local, national, regional, and
global scales. GCRMN global and regional reports are designed to provide
policymakers, managers, researchers, and international organisations
with robust scientific evidence to inform coral reef conservation and
management and to support countries in meeting national and
international biodiversity commitments. Since its establishment, the
GCRMN has published seven global reports, complemented by numerous
regional and thematic assessments documenting the status and trends of
coral reefs across its ten regions.

## 2. About this repository

This GitHub repository accompanies the GCRMN report [***Status of Coral
Reefs of the World: 2025***](https://doi.org/10.59387/LFPR6347), which
provides a comprehensive assessment of the status and trends of
shallow-water coral reefs worldwide from 1980 to 2024. The report
examines changes in key benthic components - hard coral, macroalgae, and
turf algae - and assesses how major pressures affecting coral reef
ecosystems have evolved over the past four decades. The report is
organised into two main parts. **Part 1** provides a global assessment
of coral reef status and trends, while **Part 2** presents assessments
for each of the ten GCRMN regions. The report also includes **nine case
studies**, which complement the main findings by exploring specific
aspects of coral reef ecology, monitoring, and management, and **four
boxes**, which provide additional context for interpreting the results
and highlight some of the challenges associated with producing
large-scale ecological syntheses.

This repository contains the code used to process and analyse the data
and produce the results presented in the [***Status of Coral Reefs of
the World: 2025***](https://doi.org/10.59387/LFPR6347). It is intended
to support transparency, reproducibility, and reuse of the analytical
approaches developed for the global assessment. This repository is
complemented by another GitHub repository, the
[gcrmn_model_alt](https://github.com/GCRMN/gcrmn_model_alt) repository,
which contains scripts for comparing different approaches to modeling
benthic cover.

The report’s Online Supplementary Materials, including modelled temporal
trends in benthic cover and associated outputs, are archived on
[Zenodo](https://zenodo.org/records/21824430).

## 3. Code

The [**`code`**](code) directory contains the scripts used to prepare
and analyse the data and to generate the figures and tables presented in
the report. Scripts are organised according to the main steps of the
analytical workflow.

### Cleaning and selection (`a_`)

- [**`a01_select_benthic-data.R`**](code/a01_select_benthic-data.R)
  Select and filter the benthic cover data used in the report from
  [gcrmndb_benthos](https://github.com/GCRMN/gcrmndb_benthos).
- [**`a02_clean_intersect-reefs.R`**](code/a02_clean_intersect-reefs.R)
  Intersect the global coral reef distribution with GCRMN subregions to
  produce the reef spatial layer used in subsequent analyses.
- [**`a03_benthic-data_sources.R`**](code/a03_benthic-data_sources.R)
  Compile dataset sources, datasetIDs, contributor information,
  acknowledgements, and citations used in the report and supplementary
  materials.
- [**`a04_clean_buffer-reefs.js`**](code/a04_clean_buffer-reefs.js)
  Create 5, 20, 50, and 100 km buffers around coral reefs using Google
  Earth Engine.
- [**`a05_clean_cyclones.R`**](code/a05_clean_cyclones.R) Download,
  clean, and format IBTrACS tropical cyclone data, including cyclone
  tracks, wind speeds, and Saffir–Simpson categories.
- [**`a06_download_crw-year.R`**](code/a06_download_crw-year.R) Download
  annual NOAA Coral Reef Watch SST, SSTA, and Degree Heating Week
  datasets used in the analyses.

### Indicators’ extraction (`b_`)

- [**`b01_extract_population.js`**](code/b01_extract_population.js)
  Extract human population indicators around coral reefs using the
  Gridded Population of the World dataset in Google Earth Engine.
- [**`b02_extract_crw.R`**](code/b02_extract_crw.R) Extract NOAA Coral
  Reef Watch sea surface temperature and Degree Heating Week indicators
  for GCRMN regions and subregions.
- [**`b03_extract_cyclones.R`**](code/b03_extract_cyclones.R) Identify
  and characterise tropical cyclones passing within 100 km of coral
  reefs in each GCRMN subregion.
- [**`b04_region-characteristics.R`**](code/b04_region-characteristics.R)
  Calculate geographic characteristics of GCRMN regions, including the
  number of countries and territories and their latitudinal and
  longitudinal extents.
- [**`b05_region-maritime-area.js`**](code/b05_region-maritime-area.js)
  Estimate the maritime area and geographic extent of each GCRMN region
  using Google Earth Engine.

### Benthic-cover modelling (`c_`)

- [**`c01_explo_benthic-data.qmd`**](code/c01_explo_benthic-data.qmd)
  Perform exploratory analyses of the benthic cover dataset, including
  its spatial, temporal, and taxonomic coverage.
- [**`c02_model_data-preparation.R`**](code/c02_model_data-preparation.R)
  Combine benthic observations with spatial, environmental, climatic,
  and anthropogenic predictors and prepare the datasets used for
  modelling.
- [**`c03_format-results.R`**](code/c03_format-results.R) Combine and
  format hierarchical Bayesian model outputs across global, regional,
  subregional, and ecoregional levels for subsequent analyses and
  figures.

### Figures and tables (`d_`)

- [**`d01_geography-maps.R`**](code/d01_geography-maps.R) Generate the
  global and regional geographic maps used throughout the report.
- [**`d02_spatio-temporal.R`**](code/d02_spatio-temporal.R) Generate
  figures and summary statistics describing the spatial and temporal
  distribution of coral reef monitoring data.
- [**`d03_cyclones.R`**](code/d03_cyclones.R) Generate figures and
  summary statistics describing tropical cyclone exposure across GCRMN
  regions.
- [**`d04_crw.R`**](code/d04_crw.R) Generate figures and summary
  statistics describing sea surface temperature, thermal anomalies, and
  heat stress.
- [**`d05_population.R`**](code/d05_population.R) Generate figures and
  summary statistics describing human population around coral reefs.
- [**`d06_reef-extent.R`**](code/d06_reef-extent.R) Calculate and export
  coral reef extent and the relative contribution of each GCRMN region
  and subregion to global reef area.
- [**`d07_benthic-cover_trends.R`**](code/d07_benthic-cover_trends.R)
  Generate figures and tables describing modelled temporal trends in
  benthic cover at global and regional scales.
- [**`d08_case-studies_boxes.R`**](code/d08_case-studies_boxes.R)
  Generate figures and analyses used in the case studies and boxes
  presented throughout the report.
- [**`d09_materials-methods.R`**](code/d09_materials-methods.R) Generate
  methodological figures illustrating the spatial weighting and
  reef-area components of the modelling framework.
- [**`d10_coral-cover-scenarios.r`**](code/d10_coral-cover-scenarios.r)
  Simulate future global hard coral cover under different disturbance
  and recovery scenarios and generate the corresponding figure.
- [**`d11_executive-summary.R`**](code/d11_executive-summary.R) Generate
  figures for the Executive Summary.

### Functions

The [**`code/function`**](code/function) directory contains functions
and graphical parameters reused across scripts.

- [**`data_descriptors.R`**](code/function/data_descriptors.R) Calculate
  key descriptors of benthic monitoring data, including numbers of
  datasets, sites and surveys, and monitoring period.
- [**`extract_coeff.R`**](code/function/extract_coeff.R) Extract the
  intercept and slope from a linear regression.
- [**`graphical_par.R`**](code/function/graphical_par.R) Define common
  graphical parameters, including fonts, colour palettes, and figure
  resolution.
- [**`map_region_geography.R`**](code/function/map_region_geography.R)
  Generate geographic maps for individual GCRMN regions.
- [**`map_region_monitoring.R`**](code/function/map_region_monitoring.R)
  Generate regional maps showing the spatial distribution and monitoring
  history of benthic survey sites.
- [**`map_sphere.R`**](code/function/map_sphere.R) Generate orthographic
  globe maps highlighting individual GCRMN regions.
- [**`plot_trends_model.R`**](code/function/plot_trends_model.R) Plot
  modelled benthic-cover trends and credible intervals at global,
  regional, subregional, and ecoregional scales.
- [**`plot_trends_raw.R`**](code/function/plot_trends_raw.R) Plot
  temporal trends directly from observed benthic-cover data.
- [**`prepare_benthic_data.R`**](code/function/prepare_benthic_data.R)
  Aggregate and format benthic observations into the main benthic
  categories used for exploration and modelling.
- [**`script_case-study_mgr.R`**](code/function/script_case-study_mgr.R)
  Generate the multi-panel figure used for the case study examining
  changes in coral reef condition and community composition.
- [**`theme_graph.R`**](code/function/theme_graph.R) Define the common
  *ggplot2* theme used for graphs throughout the report.
- [**`theme_map.R`**](code/function/theme_map.R) Define the common
  *ggplot2* theme used for maps throughout the report.
- [**`transform_ribbons.R`**](code/function/transform_ribbons.R)
  Transform model outputs to control the display of uncertainty ribbons
  according to the temporal availability of observed data.

## 4. Reproducibility parameters

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
     date     2026-08-19
     pandoc   3.8.3 @ C:/Users/jerem/AppData/Local/Programs/RStudio/resources/app/bin/quarto/bin/tools/ (via rmarkdown)
     quarto   1.9.38 @ C:\\Users\\jerem\\AppData\\Local\\Programs\\RStudio\\RESOUR~1\\app\\bin\\quarto\\bin\\quarto.exe

    ─ Packages ───────────────────────────────────────────────────────────────────
     package       * version    date (UTC) lib source
     askpass         1.2.1      2024-10-04 [1] CRAN (R 4.6.0)
     backports       1.5.1      2026-04-03 [1] CRAN (R 4.6.0)
     base64enc       0.1-6      2026-02-02 [1] CRAN (R 4.6.0)
     bit             4.6.0      2025-03-06 [1] CRAN (R 4.6.0)
     bit64           4.8.2      2026-05-19 [1] CRAN (R 4.6.1)
     blob            1.3.0      2026-01-14 [1] CRAN (R 4.6.0)
     broom           1.0.13     2026-05-14 [1] CRAN (R 4.6.1)
     bslib           0.12.0     2026-08-04 [1] CRAN (R 4.6.1)
     cachem          1.1.0      2024-05-16 [1] CRAN (R 4.6.0)
     callr           3.8.0      2026-06-05 [1] CRAN (R 4.6.1)
     cellranger      1.1.0      2016-07-27 [1] CRAN (R 4.6.0)
     class           7.3-24     2026-08-03 [1] CRAN (R 4.6.1)
     classInt        0.4-11     2025-01-08 [1] CRAN (R 4.6.0)
     cli             3.6.6      2026-04-09 [1] CRAN (R 4.6.0)
     clipr           0.8.1      2026-05-25 [1] CRAN (R 4.6.1)
     clock           0.7.4      2026-01-13 [1] CRAN (R 4.6.1)
     codetools       0.2-20     2024-03-31 [2] CRAN (R 4.6.0)
     colorspace      2.1-3      2026-07-12 [1] CRAN (R 4.6.1)
     commonmark      2.0.0      2025-07-07 [1] CRAN (R 4.6.0)
     conflicted      1.2.0      2023-02-01 [1] CRAN (R 4.6.0)
     cpp11           0.5.5      2026-05-06 [1] CRAN (R 4.6.1)
     crayon          1.5.3      2024-06-20 [1] CRAN (R 4.6.0)
     curl            7.1.0      2026-04-22 [1] CRAN (R 4.6.0)
     data.table      1.18.4     2026-05-06 [1] CRAN (R 4.6.1)
     DBI             1.3.0      2026-02-25 [1] CRAN (R 4.6.0)
     dbplyr          2.6.0      2026-06-17 [1] CRAN (R 4.6.1)
     diagram         1.6.5      2020-09-30 [1] CRAN (R 4.6.0)
     dials           1.4.4      2026-06-22 [1] CRAN (R 4.6.1)
     DiceDesign      1.10       2023-12-07 [1] CRAN (R 4.6.1)
     digest          0.6.39     2025-11-19 [1] CRAN (R 4.6.0)
     dplyr           1.2.1      2026-04-03 [1] CRAN (R 4.6.0)
     dtplyr          1.3.3      2026-02-11 [1] CRAN (R 4.6.0)
     e1071           1.7-17     2025-12-18 [1] CRAN (R 4.6.0)
     evaluate        1.0.5      2025-08-27 [1] CRAN (R 4.6.0)
     farver          2.1.2      2024-05-13 [1] CRAN (R 4.6.0)
     fastmap         1.2.0      2024-05-15 [1] CRAN (R 4.6.0)
     fontawesome     0.5.3      2024-11-16 [1] CRAN (R 4.6.0)
     forcats         1.0.1      2025-09-25 [1] CRAN (R 4.6.0)
     fs              2.1.0      2026-04-18 [1] CRAN (R 4.6.0)
     furrr           0.4.0      2026-03-31 [1] CRAN (R 4.6.0)
     future          1.75.0     2026-07-20 [1] CRAN (R 4.6.1)
     future.apply    1.20.2     2026-02-20 [1] CRAN (R 4.6.1)
     gargle          1.6.1      2026-01-29 [1] CRAN (R 4.6.0)
     GauPro          0.2.17     2025-11-21 [1] CRAN (R 4.6.1)
     generics        0.1.4      2025-05-09 [1] CRAN (R 4.6.0)
     ggplot2         4.0.3      2026-04-22 [1] CRAN (R 4.6.0)
     ggtext          0.1.2      2022-09-16 [1] CRAN (R 4.6.0)
     globals         0.19.1     2026-03-13 [1] CRAN (R 4.6.0)
     glue            1.8.1      2026-04-17 [1] CRAN (R 4.6.0)
     googledrive     2.1.2      2025-09-10 [1] CRAN (R 4.6.0)
     googlesheets4   1.1.2      2025-09-03 [1] CRAN (R 4.6.0)
     gower           1.0.2      2024-12-17 [1] CRAN (R 4.6.0)
     gridtext        0.1.6      2026-02-19 [1] CRAN (R 4.6.0)
     gtable          0.3.6      2024-10-25 [1] CRAN (R 4.6.0)
     hardhat         1.4.3      2026-04-04 [1] CRAN (R 4.6.1)
     haven           2.5.5      2025-05-30 [1] CRAN (R 4.6.0)
     highr           0.12       2026-03-06 [1] CRAN (R 4.6.0)
     hms             1.1.4      2025-10-17 [1] CRAN (R 4.6.0)
     htmltools       0.5.9      2025-12-04 [1] CRAN (R 4.6.0)
     httr            1.4.8      2026-02-13 [1] CRAN (R 4.6.0)
     ids             1.0.1      2017-05-31 [1] CRAN (R 4.6.0)
     infer           1.1.0      2025-12-18 [1] CRAN (R 4.6.1)
     ipred           0.9-15     2024-07-18 [1] CRAN (R 4.6.1)
     isoband         0.3.0      2025-12-07 [1] CRAN (R 4.6.0)
     jpeg            0.1-11     2025-03-21 [1] CRAN (R 4.6.0)
     jquerylib       0.1.4      2021-04-26 [1] CRAN (R 4.6.0)
     jsonlite        2.0.0      2025-03-27 [1] CRAN (R 4.6.0)
     KernSmooth      2.23-27    2026-08-12 [1] CRAN (R 4.6.1)
     knitr           1.51       2025-12-20 [1] CRAN (R 4.6.0)
     labeling        0.4.3      2023-08-29 [1] CRAN (R 4.6.0)
     lattice         0.23-1     2026-08-12 [1] CRAN (R 4.6.1)
     lava            1.9.2      2026-06-30 [1] CRAN (R 4.6.1)
     lbfgs           1.2.1.2    2022-06-23 [1] CRAN (R 4.6.1)
     lifecycle       1.0.5      2026-01-08 [1] CRAN (R 4.6.0)
     listenv         1.0.0      2026-06-22 [1] CRAN (R 4.6.0)
     litedown        0.10       2026-07-11 [1] CRAN (R 4.6.1)
     lubridate       1.9.5      2026-02-04 [1] CRAN (R 4.6.0)
     lwgeom          0.2-17     2026-07-19 [1] CRAN (R 4.6.1)
     magrittr        2.0.5      2026-04-04 [1] CRAN (R 4.6.0)
     markdown        2.0        2025-03-23 [1] CRAN (R 4.6.0)
     MASS            7.3-66     2026-07-15 [1] CRAN (R 4.6.1)
     Matrix          1.7-6      2026-07-25 [1] CRAN (R 4.6.1)
     memoise         2.0.1      2021-11-26 [1] CRAN (R 4.6.0)
     mime            0.13       2025-03-17 [1] CRAN (R 4.6.0)
     mixopt          0.1.3      2024-09-15 [1] CRAN (R 4.6.1)
     modeldata       1.5.1      2025-08-22 [1] CRAN (R 4.6.1)
     modelenv        0.2.0      2024-10-14 [1] CRAN (R 4.6.1)
     modelr          0.1.11     2023-03-22 [1] CRAN (R 4.6.0)
     nnet            7.3-21     2026-08-03 [1] CRAN (R 4.6.1)
     numDeriv        2016.8-1.1 2019-06-06 [1] CRAN (R 4.6.0)
     openssl         2.4.2      2026-06-09 [1] CRAN (R 4.6.1)
     otel            0.2.0      2025-08-29 [1] CRAN (R 4.6.0)
     parallelly      1.48.0     2026-06-29 [1] CRAN (R 4.6.1)
     parsnip         1.6.0      2026-05-14 [1] CRAN (R 4.6.1)
     patchwork       1.3.2      2025-08-25 [1] CRAN (R 4.6.0)
     pillar          1.11.1     2025-09-17 [1] CRAN (R 4.6.0)
     pkgconfig       2.0.3      2019-09-22 [1] CRAN (R 4.6.0)
     png             0.1-9      2026-03-15 [1] CRAN (R 4.6.0)
     prettyunits     1.2.0      2023-09-24 [1] CRAN (R 4.6.0)
     processx        3.9.0      2026-04-22 [1] CRAN (R 4.6.0)
     prodlim         2026.03.11 2026-03-11 [1] CRAN (R 4.6.1)
     progress        1.2.3      2023-12-06 [1] CRAN (R 4.6.0)
     progressr       1.0.0      2026-07-04 [1] CRAN (R 4.6.1)
     proxy           0.4-29     2025-12-29 [1] CRAN (R 4.6.0)
     ps              1.9.3      2026-04-20 [1] CRAN (R 4.6.0)
     purrr           1.2.2      2026-04-10 [1] CRAN (R 4.6.0)
     R6              2.6.1      2025-02-15 [1] CRAN (R 4.6.0)
     ragg            1.5.2      2026-03-23 [1] CRAN (R 4.6.0)
     rappdirs        0.3.4      2026-01-17 [1] CRAN (R 4.6.0)
     RColorBrewer    1.1-3      2022-04-03 [1] CRAN (R 4.6.0)
     Rcpp            1.1.2      2026-07-05 [1] CRAN (R 4.6.1)
     RcppArmadillo   15.4.2-1   2026-07-25 [1] CRAN (R 4.6.1)
     RcppRoll        0.3.2      2026-03-28 [1] CRAN (R 4.6.0)
     readr           2.2.0      2026-02-19 [1] CRAN (R 4.6.0)
     readxl          1.5.0      2026-05-16 [1] CRAN (R 4.6.1)
     recipes         1.3.3      2026-05-30 [1] CRAN (R 4.6.1)
     rematch         2.0.0      2023-08-30 [1] CRAN (R 4.6.0)
     rematch2        2.1.2      2020-05-01 [1] CRAN (R 4.6.0)
     reprex          2.1.1      2024-07-06 [1] CRAN (R 4.6.0)
     rlang           1.3.0      2026-07-05 [1] CRAN (R 4.6.1)
     rmarkdown       2.31       2026-03-26 [1] CRAN (R 4.6.0)
     rpart           4.1.27     2026-03-27 [2] CRAN (R 4.6.0)
     rsample         1.3.2      2026-01-30 [1] CRAN (R 4.6.1)
     rstudioapi      0.19.0     2026-06-11 [1] CRAN (R 4.6.1)
     rvest           1.0.5      2025-08-29 [1] CRAN (R 4.6.0)
     s2              1.1.11     2026-06-01 [1] CRAN (R 4.6.1)
     S7              0.2.2      2026-04-22 [1] CRAN (R 4.6.0)
     sass            0.4.10     2025-04-11 [1] CRAN (R 4.6.0)
     scales          1.4.0      2025-04-24 [1] CRAN (R 4.6.0)
     selectr         0.6-0      2026-06-23 [1] CRAN (R 4.6.1)
     sf              1.1-2      2026-07-23 [1] CRAN (R 4.6.1)
     sfd             0.1.0      2024-01-08 [1] CRAN (R 4.6.1)
     shape           1.4.6.1    2024-02-23 [1] CRAN (R 4.6.0)
     slider          0.3.3      2025-11-14 [1] CRAN (R 4.6.1)
     sparsevctrs     0.3.6      2026-01-27 [1] CRAN (R 4.6.1)
     splitfngr       0.1.2      2019-01-30 [1] CRAN (R 4.6.1)
     SQUAREM         2026.1     2026-03-12 [1] CRAN (R 4.6.1)
     stringi         1.8.9      2026-08-04 [1] CRAN (R 4.6.1)
     stringr         1.6.0      2025-11-04 [1] CRAN (R 4.6.0)
     survival        3.8-9      2026-07-08 [1] CRAN (R 4.6.1)
     sys             3.4.3      2024-10-04 [1] CRAN (R 4.6.0)
     systemfonts     1.3.2      2026-03-05 [1] CRAN (R 4.6.0)
     tailor          0.1.0      2025-08-25 [1] CRAN (R 4.6.1)
     terra           1.9-34     2026-06-19 [1] CRAN (R 4.6.1)
     textshaping     1.0.5      2026-03-06 [1] CRAN (R 4.6.0)
     tibble          3.3.1      2026-01-11 [1] CRAN (R 4.6.0)
     tidymodels      1.5.0      2026-04-23 [1] CRAN (R 4.6.1)
     tidyr           1.3.2      2025-12-19 [1] CRAN (R 4.6.0)
     tidyselect      1.2.1      2024-03-11 [1] CRAN (R 4.6.0)
     tidyverse       2.0.0      2023-02-22 [1] CRAN (R 4.6.0)
     timechange      0.4.0      2026-01-29 [1] CRAN (R 4.6.0)
     timeDate        4052.112   2026-01-28 [1] CRAN (R 4.6.1)
     tinytex         0.60       2026-06-16 [1] CRAN (R 4.6.1)
     tune            2.1.0      2026-04-17 [1] CRAN (R 4.6.1)
     tzdb            0.5.0      2025-03-15 [1] CRAN (R 4.6.0)
     units           1.0-1      2026-03-11 [1] CRAN (R 4.6.0)
     utf8            1.2.6      2025-06-08 [1] CRAN (R 4.6.0)
     uuid            1.2-2      2026-01-23 [1] CRAN (R 4.6.0)
     vctrs           0.7.3      2026-04-11 [1] CRAN (R 4.6.0)
     viridisLite     0.4.3      2026-02-04 [1] CRAN (R 4.6.0)
     vroom           1.7.1      2026-03-31 [1] CRAN (R 4.6.0)
     warp            0.2.3      2026-01-13 [1] CRAN (R 4.6.1)
     withr           3.0.3      2026-06-19 [1] CRAN (R 4.6.1)
     wk              0.9.5      2025-12-18 [1] CRAN (R 4.6.0)
     workflows       1.3.0      2025-08-27 [1] CRAN (R 4.6.1)
     workflowsets    1.1.1      2025-05-27 [1] CRAN (R 4.6.1)
     xfun            0.60       2026-07-09 [1] CRAN (R 4.6.1)
     xml2            1.6.0      2026-06-22 [1] CRAN (R 4.6.1)
     yaml            2.3.12     2025-12-10 [1] CRAN (R 4.6.0)
     yardstick       1.4.0      2026-04-07 [1] CRAN (R 4.6.1)

     [1] C:/Users/jerem/AppData/Local/R/win-library/4.6
     [2] C:/Program Files/R/R-4.6.0/library

    ──────────────────────────────────────────────────────────────────────────────
