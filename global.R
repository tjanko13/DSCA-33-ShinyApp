library('tidyverse')
library('caret')
library('plotly')

dat_class_unfiltered = readRDS('all_cluster_data.RDS')
model_rf = readRDS('tj_model_rf.RDS')
model_pp = readRDS('tj_model_pp.RDS')
craft_beer_app = readRDS('tj_craft_beer_app.RDS')
