################
# Project: Disjunct distributions of continental Urania 
# Authors: Marlon Cobos, Claudia Nunez-Penichet
# Process: Niche overlap analyses
# Date: 03/14/2020
################

#Instaling packages
#install.packages("devtools")
#devtools::install_github("marlonecobos/ellipsenm")
library(ellipsenm)
library(raster)
library(rgdal)

#Establishing working directory
setwd("Z:/Claudia/2.Publications/3.Continental_Urania/8.ellipse_enm/Urania")

#Reading occurrence data
u_ful <- read.csv("U.fulgens/u.fulge_joint.csv")
u_lei <- read.csv("U.leilus/u.lei_joint.csv")

#Reading varaiables
Var_ful <- stack(list.files(path = "U.fulgens/Set_2", pattern = ".asc$", full.names = T)[-3])
var_lei <- stack(list.files(path = "U.leilus/Set_1", pattern = ".asc$", full.names = T))

#Reading species Ms
mful <- readOGR("Z:/Claudia/2.Publications/3.Continental_Urania/4.M/M", layer = "M_fulgens")
mlei <- readOGR("Z:/Claudia/2.Publications/3.Continental_Urania/4.M/M", layer = "M_leilus")

#Masking variables with species Ms
Var_ful <- mask(crop(Var_ful, mful), mful)
var_lei <- mask(crop(var_lei, mlei), mlei)

#Creatting objects need it for niche overlap
niche_ful <- overlap_object(u_ful, species = "name", longitude = "Longitude", 
                            latitude = "Latitude", method = "covmat", level = 95, variables = stack(Var_ful))
niche_lei <- overlap_object(u_lei, species = "name", longitude = "Longitude", 
                            latitude = "Latitude", method = "covmat", level = 95, variables = stack(var_lei))

#Full overlap analyses
overlapfull <- ellipsoid_overlap(niche_ful, niche_lei, overlap_type = "full")
                                 
#Background overlap analyses
overlap <- ellipsoid_overlap(niche_ful, niche_lei, overlap_type = "back_union",
                             significance_test = TRUE, replicates = 1000)

#Saving results
save(overlapfull, overlap, file = "overlap_results.RData")


#Visualizing overlap results
plot_overlap(overlap)
plot_overlap(overlapfull, background = T, proportion = 1, background_type = "full")
plot_overlap(overlap, background = T, proportion = 1, background_type = "back_union")

par(mar = c(4.5, 4.5, 0.5, 0))
par(cex = 0.85)
hist(overlap@significance_results$union_random[[1]]$overlap,
     main = "", xlab = "Overlap", xlim = c(0, 1))
abline(v = quantile(overlap@significance_results$union_random[[1]]$overlap, 0.05), 
       col = "darkgreen", lwd = 2, lty = 2)
abline(v = overlap@union_overlap$overlap, col = "green", lwd = 2)
legend("topleft", bty = "n", legend = c("Observed", "95% CL"), 
       col = c("green", "darkgreen"), lty = c(1, 2), lwd = 2, cex = 0.8)
