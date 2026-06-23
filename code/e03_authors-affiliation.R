# 1. Load packages ----

library(tidyverse)
library(glue)
library(readxl)

# 2. Load data ----

data_authors <- read_xlsx("data/authors_affiliations.xlsx") %>% 
  mutate(across(c("first_name", "last_name", "affiliation", "country"), ~replace_na(.x, "")),
         across(c("part", "subpart", "first_name", "last_name", "affiliation", "country", "email", "orcid"), ~str_squish(.x))) %>% 
  filter(part == "Part 2 - Regional synthesis")

# 3. Generate LaTeX code for list of authors ----

## 3.1 Create the function ----

export_authors_latex <- function(region_i) {
  
  data_authors_region <- data_authors %>% 
    filter(subpart == region_i)
  
  # List of affiliations
  data_list_affiliations <- data_authors_region %>%
    distinct(affiliation) %>%
    mutate(affil_id = row_number())
  
  # List of authors
  data_list_authors <- data_authors_region %>%
    left_join(data_list_affiliations, by = "affiliation") %>%
    arrange(position) %>%
    group_by(position, first_name, last_name, email, orcid, include_email) %>%
    summarise(
      affil_id = paste(sort(unique(affil_id)), collapse = ","),
      .groups = "drop"
    ) %>%
    arrange(position)
  
  latex_authors <- data_list_authors %>%
    mutate(
      email_tex = case_when(
        include_email == TRUE & !is.na(email) & email != "" ~
          glue("\\emailicon{{{email}}}"),
        TRUE ~ ""
      ),
      
      orcid_tex = case_when(
        !is.na(orcid) & orcid != "" ~
          glue("\\orcidicon{{{orcid}}}"),
        TRUE ~ ""
      ),
      
      latex = glue(
        "{first_name} \\textbf{{{last_name}}}\\textsuperscript{{{affil_id}}}{email_tex}{orcid_tex}"
      )
    )
  
  latex_output <- paste0(
    latex_authors$latex,
    if_else(
      seq_len(nrow(latex_authors)) == nrow(latex_authors),
      "",
      ",\n"
    ),
    collapse = ""
  )
  
  writeLines(
    latex_output,
    paste0(
      "figs/09_affiliations/authors_",
      str_replace_all(str_to_lower(region_i), " ", "-"),
      ".tex"
    )
  )
}

## 3.2 Map over the regions ----

walk(unique(data_authors$subpart),
     ~export_authors_latex(region_i = .x))

# 4. Generate LaTeX code for list of affiliations ----

## 4.1 Create the function ----

export_affiliations_latex <- function(region_i) {
  
  data_authors_region <- data_authors %>% 
    filter(subpart == region_i)
  
  data_list_affiliations <- data_authors_region %>%
    mutate(affiliation = paste0(affiliation, ", ", country)) %>% 
    distinct(affiliation) %>%
    mutate(affil_id = row_number())
  
  latex_affiliations <- data_list_affiliations %>%
    mutate(
      latex = glue(
        "\\textbf{{\\textsuperscript{{{affil_id}}}}}{affiliation}"
      )
    )
  
  latex_output <- paste0(
    latex_affiliations$latex,
    if_else(
      seq_len(nrow(latex_affiliations)) == nrow(latex_affiliations),
      "",
      " $\\mid$ \n"
    ),
    collapse = ""
  )
  
  writeLines(latex_output, paste0("figs/09_affiliations/affiliations_",
                                  str_replace_all(str_to_lower(region_i), " ", "-"),
                                  ".tex"))
  
}

## 4.2 Map over the regions ----

walk(unique(data_authors$subpart),
     ~export_affiliations_latex(region_i = .x))

# 5. Citations of regional chapters ----

data_authors <- left_join(data_authors, read_xlsx("data/chapters_doi.xlsx") %>% rename(subpart = region))

export_citation_latex <- function(region_i){
  
  latex_output <- data_authors %>%
    filter(subpart == region_i) %>% 
    select(position, first_name, last_name, region_nb, region_name, chapter_doi) %>% 
    distinct() %>% 
    filter(position <= 5) %>% 
    arrange(position) %>% 
    mutate(author = paste0(last_name, ", ", substr(first_name, 1, 1), "."),
           region_name = case_when(region_name %in% c("Australia", "Brazil") ~ region_name,
                                   TRUE ~ paste0("the ", region_name)),
           citation = paste(author, collapse = ", "),
           citation = glue("{citation}, \\textit{{et al.}} (2026). Chapter {region_nb} -- Status and Trends of Coral Reefs in {region_name}. \\textit{{In González-Rivero, M., \\textit{{et al.}} Status and Trends of Coral Reefs of the World: 2025. Global Coral Reef Monitoring Network.}} {chapter_doi}")) %>%
    select(citation) %>% 
    distinct(citation) %>% 
    pull(citation)
  
  writeLines(latex_output, paste0("figs/09_affiliations/citation_",
                                  str_replace_all(str_to_lower(region_i), " ", "-"),
                                  ".tex"))
  
}

walk(unique(data_authors$subpart),
     ~export_citation_latex(region_i = .x))
