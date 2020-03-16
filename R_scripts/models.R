################
# Project: Disjunct distributions of continental Urania 
# Authors: Marlon Cobos, Claudia Nunez-Penichet
# Process: Ecological Niche Modeling
# Date: 03/14/2020
################

#Instaling packages
#install.packages("devtools")
#devtools::install_github("marlonecobos/ellipsenm")
library(ellipsenm)
library(raster)

#####

##Omphalea
#Establishing working directory
setwd("C:/8.ellipse_enm/Omphalea/All")

#Reading occurrence data
omp <- read.csv("omph_joint.csv")

#Reading varaiables
vari <- list.files(path = "Set_2", pattern = ".asc$", full.names = T)
variables <- stack(vari)

#Creating the models
el <- ellipsoid_model(data = omp, species = "name", longitude = "Longitude", latitude = "Latitude", 
                      raster_layers = variables,
                      method = "covmat", level = 95, replicates = 10,
                      replicate_type = "bootstrap", bootstrap_percentage = 75,
                      projection_variables = NULL, prvariables_format = NULL,
                      prediction = "suitability", return_numeric = TRUE,
                      tolerance = 1e-60, format = "GTiff", overwrite = TRUE,
                      color_palette = viridis::magma, output_directory = "ellipsenm_model")

#####

##Urania fulgens
#Establishing working directory
setwd("C:/8.ellipse_enm/Urania/U.fulgens")

#Reading occurrence data
u.ful <- read.csv("u.fulge_joint.csv")

#Reading varaiables
vari <- list.files(path = "Set_2", pattern = ".asc$", full.names = T)
variables <- stack(vari)

#Creating the models
el <- ellipsoid_model(data = u.ful, species = "name", longitude = "Longitude", latitude = "Latitude", 
                      raster_layers = variables,
                      method = "covmat", level = 95, replicates = 10,
                      replicate_type = "bootstrap", bootstrap_percentage = 75,
                      projection_variables = NULL, prvariables_format = NULL,
                      prediction = "suitability", return_numeric = TRUE,
                      tolerance = 1e-60, format = "GTiff", overwrite = FALSE,
                      color_palette = viridis::magma, output_directory = "ellipsenm_model")

#####

##Urania leilus
#Establishing working directory
setwd("C:/8.ellipse_enm/Urania/U.leilus")

#Reading occurrence data
u.lei <- read.csv("u.lei_joint.csv")

#Reading varaiables
vari <- list.files(path = "Set_1", pattern = ".asc$", full.names = T)
variables <- stack(vari)

#Creating the models
el <- ellipsoid_model(data = u.lei, species = "name", longitude = "Longitude", latitude = "Latitude", 
                      raster_layers = variables,
                      method = "covmat", level = 95, replicates = 10,
                      replicate_type = "bootstrap", bootstrap_percentage = 75,
                      projection_variables = NULL, prvariables_format = NULL,
                      prediction = "suitability", return_numeric = TRUE,
                      tolerance = 1e-60, format = "GTiff", overwrite = T,
                      color_palette = viridis::magma, output_directory = "ellipsenm_model")


