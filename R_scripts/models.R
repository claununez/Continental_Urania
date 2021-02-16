################
# Project: Non-overlapping climatic niches and biogeographic barriers explain
#          disjunct distributions of continental Urania moths
# Authors: Claudia Nunez-Penichet, Marlon Cobos, Jorge Soberon
# Process: Ecological Niche Modeling
# Date: 16/02/2021
################

#Installing and loading packages
#install.packages("remotes")
#remotes::install_github("marlonecobos/ellipsenm")
library(ellipsenm)
library(raster)

#Working directory
setwd("YOUR/DIRECTORY/Data")


#####
##Omphalea
#Reading occurrence data
omp <- read.csv("Omphalea_spp.csv")

#Reading varaiables
vari <- list.files(path = "Current_variables_omp", pattern = ".tif$",
                   full.names = TRUE)
variables <- stack(vari)

#Creating the models
el <- ellipsoid_model(data = omp, species = "name", longitude = "Longitude",
                      latitude = "Latitude", raster_layers = variables,
                      method = "covmat", level = 95, replicates = 10,
                      replicate_type = "bootstrap", bootstrap_percentage = 75,
                      projection_variables = "Var_project_omp",
                      prvariables_format = "GTiff",
                      prediction = "suitability", return_numeric = TRUE,
                      tolerance = 1e-60, format = "GTiff",
                      color_palette = viridis::magma,
                      output_directory = "ellipsenm_model_omp")



#####
#Urania species

##Urania fulgens
#Reading occurrence data
u.ful <- read.csv("Urania_fulgens.csv")

#Reading varaiables
vari <- list.files(path = "Current_variables_ura", pattern = ".tif$",
                   full.names = TRUE)
variables <- stack(vari)


#Creating the models
el <- ellipsoid_model(data = u.ful, species = "name", longitude = "Longitude",
                      latitude = "Latitude", raster_layers = variables,
                      method = "covmat", level = 95, replicates = 10,
                      replicate_type = "bootstrap", bootstrap_percentage = 75,
                      projection_variables = "Var_project_ura",
                      prvariables_format = "GTiff",
                      prediction = "suitability", return_numeric = TRUE,
                      tolerance = 1e-60, format = "GTiff",
                      color_palette = viridis::magma,
                      output_directory = "ellipsenm_model_uful")



##Urania leilus
#Reading occurrence data
u.lei <- read.csv("Urania_leilus.csv")

#Creating the models
el <- ellipsoid_model(data = u.lei, species = "name", longitude = "Longitude",
                      latitude = "Latitude", raster_layers = variables,
                      method = "covmat", level = 95, replicates = 10,
                      replicate_type = "bootstrap", bootstrap_percentage = 75,
                      projection_variables = "Var_project_ura",
                      prvariables_format = "GTiff",
                      prediction = "suitability", return_numeric = TRUE,
                      tolerance = 1e-60, format = "GTiff",
                      color_palette = viridis::magma,
                      output_directory = "ellipsenm_model_ulei")
