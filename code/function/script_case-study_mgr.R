# 1. Load packages ----

library(tidyverse)
library(ggtext)
library(scales)
require(RColorBrewer)
library(geomtextpath)
require(elementalist) # devtools::install_github("teunbrand/elementalist")

# 2. Source functions ----

source("code/function/graphical_par.R")
source("code/function/data_descriptors.R")
source("code/function/theme_map.R")
source("code/function/theme_graph.R")

# 3. Load data ----

load("data/14_case-studies/beyond_coral/indices.RData")

# 4. Load functions ----

# Template configuration ----
cfg <- list(
  title = "GCRMN Case Study Figure",
  summary = "Four-panel case study figure with time-series and radial condition panels.",
  author = "Manuel Gonzalez Rivero",
  version = "1.0.0",
  run_date = as.character(Sys.Date()),
  conf_thsld = 0.8,
  ref = "Combined_adjusted",
  indices_paths = "data/indices.RData",
  hard_coral_path = "data/GCRMN_CaseStudy_HC_reefs.RData",
  output_dir = "Fig",
  output_basename = "GCRMN_CaseStudy_Figure",
  output_width_cm = 35,
  output_height_cm = 25,
  site_1 = list(
    domain_name = "SNAPPER ISLAND",
    reef_name = "Snapper North",
    year = 2018,
    depth_filter = "shallow slope",
    shelf_override = NULL,
    depth_override = NULL,
    title_fill_hex = "#a059a0"
  ),
  site_2 = list(
    domain_name = "LADY MUSGRAVE ISLAND",
    reef_name = "Lady Musgrave Island",
    year = 2012,
    depth_filter = NULL,
    shelf_override = "Inshore",
    depth_override = "Deep slope",
    title_fill_hex = "#3288bd"
  )
)

comp_plot<-function(comp, i.df.r, y, s){
  if(s=="All"){s=c("Inshore","Offshore")}
  comp.d<-comp%>%
    filter(k==6,REPORT_YEAR==y, REEF.d %in% (i.df.r%>%pull(Name)%>%unique()))%>%
    # REEF %in% (i.df.r%>%filter(Year==y, Indicator=="Community.composition", Reference=="Baseline",Median<0.5, Shelf %in% s)%>%pull(Name)))%>%
    group_by(COMP_2021_DESCRIPTION)%>%
    summarise(meanDiff=mean(meanDiff), varDiff=mean(varDiff, na.rm=TRUE)) %>% 
    
    # summarise(meanDiff=median(meanDiff), se=ifelse(is.na(sd(meanDiff)/sqrt(length(meanDiff))), 0,sd(meanDiff)/sqrt(length(meanDiff)))) %>%
    mutate(taxa=factor(COMP_2021_DESCRIPTION, levels=COMP_2021_DESCRIPTION[order(meanDiff)]),
           c=case_when(meanDiff<0 ~ "Loss",
                       .default="Gain"),
           lower=case_when(c=="Loss" ~ meanDiff+varDiff,
                           .default=meanDiff-varDiff),
           upper=case_when(c=="Loss" ~ meanDiff-varDiff,
                           .default=meanDiff+varDiff)
    )%>%
    arrange(-abs(meanDiff))%>%
    head()%>%
    droplevels()
  
  nreefs=length(i.df.r%>%filter(Year==y, Indicator=="Community.composition", Reference=="Baseline",Median<0.5, Shelf %in% s)%>%pull(Name))
  
  if (nreefs==0){
    dat=data.frame(x=0.5,y=0.5, lab="No\nsignficant changes\nobserved in the\n community composition")
    comp.d=ggplot(dat, aes(x,y,label=lab))+geom_text(size=10, color="grey55")+
      theme_void()+
      theme(
        legend.background = element_rect_round(radius = unit(0.2, "snpc")),
        legend.key = element_rect_round(radius = unit(0.4, "snpc")),
        panel.background = element_rect_round(radius = unit(1, "cm"), fill = "grey97",color = "grey78"),
        strip.background = element_rect_round(radius = unit(8, "pt")),
        plot.background  = element_rect_round(fill = "grey97")
      )
  }else{
    comp.d<-comp.d%>%
      ggplot()+
      geom_bar(aes(x=taxa, y=meanDiff*100, fill=c), stat="identity")+
      geom_errorbar(aes(x=taxa,ymin=lower*100, ymax=upper*100), width=0.2)+
      scale_x_discrete(labels = function(x) 
        stringr::str_wrap(x, width = 20))+
      coord_flip()+
      labs(x="Top taxa that changed", y=sprintf("Change in cover from %s reefs\nwhere composition has changed\n(%%, mean +/- se)", nreefs))+
      scale_fill_manual(values=c("blue","red"))+
      theme_bw()+
      guides(fill="none")
  }
  comp.d
  
}

Cond.Class<-function(df,conf){
  
  #High-Level classification of Reef Habitat condition
  cond.crit=data.frame(Class=c("Insuficient data",
                               "Critical","Critical",
                               "Warning II","Warning II","Warning II",
                               "Warning I","Warning I","Warning I",
                               "Watch","Watch","Watch",
                               "Good"),
                       criteria=c(
                         ##No all indicators are calculated
                         'all.na>0',
                         #Critical
                         'Coral.cover=="No" & Recovery.performance=="No" & Processes=="All.No"',
                         'Coral.cover=="No" & Recovery.performance=="No" & Processes=="AtLeastOne.No"',
                         
                         #Warning II
                         'Coral.cover=="No" & Recovery.performance=="No" & Processes=="All.Yes"',
                         'Coral.cover=="No" & Recovery.performance=="Yes" & Processes=="All.No"',
                         'Coral.cover=="Yes" & Recovery.performance=="No" & Processes=="All.No"',
                         
                         #Warning I
                         'Coral.cover=="No" & Recovery.performance=="Yes" & Processes=="AtLeastOne.No"',
                         'Coral.cover=="Yes" & Recovery.performance=="No" & Processes=="AtLeastOne.No"',
                         'Coral.cover=="Yes" & Recovery.performance=="Yes" & Processes=="All.No"',
                         
                         #Watch
                         'Coral.cover=="No" & Recovery.performance=="Yes" & Processes=="All.Yes"',
                         'Coral.cover=="Yes" & Recovery.performance=="Yes" & Processes=="AtLeastOne.No"',
                         'Coral.cover=="Yes" & Recovery.performance=="No" & Processes=="All.Yes"',
                         
                         #Good
                         'Coral.cover=="Yes" & Recovery.performance=="Yes" & Processes=="All.Yes"'
                       )
  )
  
  if (dim(df)[1]==0){
    c.df=NA
  }else{
    ##Agregate indicators for high-level criteria per Reef
    c.df<-df%>%
      group_by(Name,Depth,Year,Indicator)%>%
      # rename(Score=Median)%>%
      mutate(
        crit=case_when(
          ((Indicator %in% c("Macroalgae","Juvenile.density", "Coral.cover")) &
             p_below_0.5>= conf) ~T, ##at or Below threshold for most of the indicators
          ((Indicator %in% c("Community.composition","Recovery.performance")) &
             p_below_0.5>= conf) ~ T,##[TODO:REview this] Below threshold for Recovery
          is.na(Median) ~NA,
          .default=F
        ),
        Ind.g=case_when(
          Indicator %in% c("Community.composition","Macroalgae","Juvenile.density") ~ "Processes",
          .default=Indicator
        )
      )%>%
      group_by(Name, Depth,Year, Ind.g)%>%
      summarise(crit.no=sum(crit))%>%
      mutate(
        # crit.yes=case_when(
        #   Surveyed==FALSE ~NA,
        #   .default=crit.yes
        # ),
        crit=case_when(
          ((Ind.g =="Coral.cover") & crit.no==1) ~ "No",
          ((Ind.g =="Coral.cover")  &  crit.no==0) ~ "Yes",
          ((Ind.g =="Recovery.performance")  &  crit.no==1) ~ "No",
          ((Ind.g =="Recovery.performance")  &  crit.no==0) ~ "Yes",
          ((Ind.g %in% c("Processes")  &  crit.no==3)) ~ "All.No",
          ((Ind.g %in% c("Processes")  &  crit.no==0)) ~ "All.Yes",
          ((Ind.g %in% c("Processes")  & crit.no %in% (c(1,2)))) ~ "AtLeastOne.No",
          .default = NA)
      )%>%
      select(-crit.no)%>%
      spread(key=Ind.g, val=crit)%>%
      mutate(all.na=sum(c(is.na(Coral.cover),is.na(Recovery.performance),is.na(Processes))))
    
    c.df$Class=apply(
      do.call(rbind, 
              Map(function(x, y) with(c.df, ifelse(eval(parse(text = x)), y, NA)), 
                  cond.crit$criteria, cond.crit$Class)), 2, function(x) toString(x[!is.na(x)]))
    
  }
  
  return(c.df)
  
}

radial.plot.summary<-function(dat,ref){
  
  if(dim(dat)[1]==0){ #Display "no data" box if the reef/region are not surveyed
    dat=data.frame(x=0.5,y=0.5, lab="No Survey\ndata available")
    p.eg=ggplot(dat, aes(x,y,label=lab))+geom_text(size=14, color="grey55")+
      theme_void()+
      theme(
        legend.background = element_rect_round(radius = unit(0.2, "snpc")),
        legend.key = element_rect_round(radius = unit(0.4, "snpc")),
        panel.background = element_rect_round(radius = unit(1, "cm"), fill = "grey97",color = "grey78"),
        strip.background = element_rect_round(radius = unit(8, "pt")),
        plot.background  = element_rect_round(fill = "grey97")
      )
    
  }else{
    # dat<-dat%>%
    #   group_by(Name,Year, Indicator, Classification)%>%
    #   summarise(Score=mean(Score, na.rm = T))%>%
    #   ungroup()%>%
    #   mutate(Classification=case_when(
    #     Score > 0.5 ~ "Good",
    #     Score > 0.4 & Score <= 0.5 ~ "Moderate",
    #     Score <= 0.4 & Score > 0.2 ~ "Poor",
    #     # Score < 0.2 ~ "Very Poor",
    #     TRUE ~ "Very Poor")
    #   )%>%
    #   mutate(Classification=factor(Classification, levels=c("Very Poor","Poor","Moderate","Good")))
    
    p.eg<-dat%>%
      ungroup%>%
      filter(Reference==ref)%>%
      mutate(Indicator=recode(Indicator, 
                              Coral.cover="Coral Cover",
                              Macroalgae="Macroalgal Prevalence",
                              Recovery.performance="Recovery Rate",
                              Juvenile.density="Coral Juvenile Density",
                              Community.composition="Community Composition"))%>%
      # mutate(Indicator=str_replace(Indicator, "[.]", " "))%>%
      ggplot()+
      geom_col(
        aes(
          # x = str_wrap(Indicator, 5, whitespace_only = T),
          x=Indicator,
          y = Median,
          fill = Classification
        ),
        position = "dodge2",
        show.legend = FALSE,
        alpha = .9
      ) +
      # Make custom panel grid
      geom_hline(
        aes(yintercept = seq(0,1,0.25)), 
        color = "gray87"
      ) + 
      geom_hline(
        aes(yintercept = 0.5), 
        color = "black",
        linewidth=0.5,
        linetype="dashed"
      ) +
      geom_errorbar(
        aes(
          x=Indicator,
          ymin = Lower,
          ymax=Upper,
        ),
        position = "dodge2",
        show.legend = FALSE,
        alpha = .9,
        width=0.2
      ) +
      geom_vline(xintercept = 1:6 - 0.5, color = "gray90") +
      # Add bars to represent the cumulative track lengths
      # str_wrap(region, 5) wraps the text so each line has at most 5 characters
      # (but it doesn't break long words!)
      
      # # Lollipop shaft for mean gain per region
      #   geom_segment(
      #     aes(
      #       x = str_wrap(Indicator, 5),
      #       y = 0,
      #       xend = str_wrap(Indicator, 5, whitespace_only = T),
      #       yend = 1
      #     ),
      #     linetype = "dashed",
      #     color = "gray87"
      #   ) + 
      
      # Make it circular!
      coord_curvedpolar()+
      theme_bw()+
      theme(panel.border = element_blank(),
            axis.text.x = element_text(size = 14),
            axis.title.x = element_blank(),
            plot.margin = margin(0, 0, 0, 0),
            panel.grid.major = element_blank())
    # coord_polar()
    
    
    ##Add Annotations and Legend
    
    p.eg <- p.eg +
      # Annotate custom scale inside plot
      # annotate(
      #   x = 0.5, 
      #   y = 1, 
      #   label = "1", 
      #   geom = "text", 
      #   color = "gray80", 
      #   family = font_choose_graph
      # ) +
      # annotate(
      #   x = 0.5, 
      #   y = 0.5, 
      #   label = "0.5", 
      #   geom = "text", 
      #   color = "gray80", 
      #   family = font_choose_graph,
      #   fontface=2
      #   
      # ) +
      # annotate(
      #   x = 0.5,
      #   y =0.75,
      #   label = "0.75",
      #   geom = "text",
      #   color = "gray80",
      #   family = font_choose_graph
      # ) +
      # Scale y axis so bars don't start in the center
      scale_y_continuous(
        limits = c(-0.1, 1.1),
        expand = c(0, 0),
        breaks = c(0, 0.25, 0.5, 0.75, 1)
      ) + 
      # New fill and legend title for number of tracks per region
      scale_fill_class.c()+
      #   "Condition",
      #   values = brewer.pal(name="RdYlGn", n=3)
      # ) +
      # Make the guide for the fill discrete
      # guides(
      #   fill = guide_colorsteps(
      #     barwidth = 15, barheight = .5, title.position = "top", title.hjust = .5
      #   )
      # ) +
      theme(
        # Remove axis ticks and text
        axis.title = element_blank(),
        # axis.ticks = element_blank(),
        # axis.text.y = element_blank(),
        # Use gray text for the region names
        axis.text.x = element_text(color = "gray20", size = 12 ),
        # Move the legend to the bottom
        legend.position = 'none',
      )
    p.eg
    p.eg<- p.eg + 
      # Add labels
      # labs(
      #   title = sprintf("%s: %i", dat$Name[1], dat$Year[1])
      # )+
      theme(
        
        # Set default color and font family for the text
        text = element_text(color = "gray12", family = font_choose_graph),
        
        # Customize the text in the title, subtitle, and caption
        plot.title = element_text(face = "bold", size = 25, hjust = 0.05),
        plot.subtitle = element_text(size = 14, hjust = 0.05),
        plot.caption = element_text(size = 10, hjust = .5),
        
        # Make the background white and remove extra grid lines
        panel.background = element_rect(fill = "white", color = "white"),
        panel.grid = element_blank(),
        panel.grid.major.x = element_blank()
      )
  }
  # Use `ggsave("plot.png", p.eg, width=9, height=12.6)` to save it as in the output
  p.eg
  
}

scores <- indices %>%
  filter(Level == "reef") %>%
  mutate(
    fYEAR = Year,
    Reference=case_when(
      (Reference=="Baseline") & 
        (Indicator %in% c("Community.composition")) ~ "Combined_adjusted",
      .default=Reference),
    Year = as.numeric(as.character(Year)),
    Median=ifelse(is.na(Median), 0.5, Median),
    Upper=ifelse(is.na(Upper), 0.5, Upper),
    Lower=ifelse(is.na(Lower), 0.5, Lower))

# Plot styling ----
scale_fill_class.c <- function(...) {
  scale_fill_manual(
    values = c("Below" = "#d53e4f", "Within" = "#3288bd", "Above" = "#3288bd"),
    drop = FALSE,
    ...
  )
}

make_radial_panel <- function(df, title_fill_hex) {
  class_df <- Cond.Class(
    df %>%
      filter(Reference == cfg$ref) %>%
      mutate(across(c(Median, Lower, Upper), ~ case_when(is.na(.x) ~ 0.5, .default = .x))),
    conf = cfg$conf_thsld
  )
  
  radial.plot.summary(df, cfg$ref) +
    scale_fill_class.c() +
    scale_x_discrete(labels = label_wrap_gen(width = 15)) +
    labs(title = class_df %>% pull(Class)) +
    theme_graph() +
    theme(
      axis.text = element_text(size = 16, vjust = 0.5, family = font_choose_graph),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA),
      axis.title = element_text(
        size = 18,
        face = "bold",
        family = font_choose_graph,
        margin = margin(r = 10, unit = "mm")),
      axis.text.x = element_text(hjust = 0.5, vjust = 0.5, size = 9),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.title.y = element_blank(),
      axis.title.x = element_blank(),
      axis.line.x = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.margin = margin(2, 2, 2, 2),
      plot.title = element_textbox_simple(
        fill = title_fill_hex,
        color = "white",
        box.color = NULL,
        r = unit(8, "pt"),
        padding = unit(c(5, 5, 5, 5), "pt"),
        width = NULL,
        size = 14,
        margin = unit(c(0, 0, 0, 0), "pt"),
        halign = 0.5,
        hjust = 1
      )
    )
}

build_radial_df <- function(site_cfg) {
  radial_df <- scores %>%
    filter(Level == "reef", Year == site_cfg$year, Name == site_cfg$reef_name, Reference == cfg$ref)
  
  if (!is.null(site_cfg$depth_filter)) {
    radial_df <- radial_df %>% filter(Depth == site_cfg$depth_filter)
  }
  
  radial_df <- radial_df %>%
    mutate(
      Lower = ifelse(is.na(Lower), 0.5, Lower),
      Upper = ifelse(is.na(Upper), 0.5, Upper),
      Median = ifelse(is.na(Median), 0.5, Median),
      Classification = case_when(
        Lower > 0.5 ~ "Above",
        Upper < 0.5 ~ "Below",
        is.na(Lower) ~ NA,
        .default = "Within"
      )
    )
  
  if (!is.null(site_cfg$shelf_override)) {
    radial_df <- radial_df %>% mutate(Shelf = site_cfg$shelf_override)
  }
  
  if (!is.null(site_cfg$depth_override)) {
    radial_df <- radial_df %>% mutate(Depth = site_cfg$depth_override)
  }
  
  radial_df
}

# 5. Produce the figures ----

df2b <- build_radial_df(cfg$site_1)
plot_b <- make_radial_panel(df = df2b, title_fill_hex = cfg$site_1$title_fill_hex)

df2d <- build_radial_df(cfg$site_2)
plot_d <- make_radial_panel(df = df2d, title_fill_hex = cfg$site_2$title_fill_hex)

rm(build_radial_df, make_radial_panel, scale_fill_class.c, Cond.Class,
   radial.plot.summary, comp_plot, scores, cfg, df2b, df2d, indices)
