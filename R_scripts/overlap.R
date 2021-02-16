################
# Project: Non-overlapping climatic niches and biogeographic barriers explain
#          disjunct distributions of continental Urania moths
# Authors: Claudia Nunez-Penichet, Marlon Cobos, Jorge Soberon
# Process: Niche overlap analyses
# Date: 16/02/2021
################

#Loading packages
library(ellipsenm)
library(raster)
library(rgdal)

#Working directory
setwd("YOUR/DIRECTORY/Data")


#####
#Preparing data
#Reading occurrence data
u_ful <- read.csv("Urania_fulgens.csv")
u_lei <- read.csv("Urania_leilus.csv")

#Reading M layers
M_uful <- readOGR("M_layers", layer = "M_fulgens")
M_ulei <- readOGR("M_layers", layer = "M_leilus")

#Reading varaiables
##Current
vars <- stack(list.files(path ="Current_variables_ura", 
                         pattern = ".tif$", full.names = T))

##Past
vlgm <- stack(list.files(path ="Var_project_ura/LGM", 
                         pattern = ".tif$", full.names = T))
vmh <- stack(list.files(path ="Var_project_ura/MH", 
                        pattern = ".tif$", full.names = T)) 

#Masking variables
##Current
var_ful <- mask(crop(vars, M_uful), M_uful)
var_lei <- mask(crop(vars, M_ulei), M_ulei)

##Past
var_ful_lgm <- mask(crop(vlgm, M_uful), M_uful)
var_lei_lgm <- mask(crop(vlgm, M_ulei), M_ulei)

var_ful_mh <- mask(crop(vmh, M_uful), M_uful)
var_lei_mh <- mask(crop(vmh, M_ulei), M_ulei)

#Extracting values of current variables on occurrences
u_ful_all <- raster::extract(var_ful, u_ful[, 2:3])
u_ful_all <- na.omit(cbind(u_ful, u_ful_all))

u_lei_all <- raster::extract(var_lei, u_lei[, 2:3])
u_lei_all <- na.omit(cbind(u_lei, u_lei_all))

#Transforming raster layers to matrices
ful <- rasterToPoints(var_ful)[,-c(1, 2)]
lei <- rasterToPoints(var_lei)[,-c(1, 2)]

ful_lgm <- rasterToPoints(var_ful_lgm)[,-c(1, 2)]
lei_lgm <- rasterToPoints(var_lei_lgm)[,-c(1, 2)]

ful_mh <- rasterToPoints(var_ful_mh)[,-c(1, 2)]
lei_mh <- rasterToPoints(var_lei_mh)[,-c(1, 2)]


#####
#Current period
#Creating objects needed for niche overlap
niche_ful <- overlap_object(u_ful_all, species = "name", longitude = "Longitude", 
                            latitude = "Latitude", method = "covmat", level = 95, 
                            variables = ful)
niche_lei <- overlap_object(u_lei_all, species = "name", longitude = "Longitude", 
                            latitude = "Latitude", method = "covmat", level = 95, 
                            variables = lei)

#Full overlap analyses
overlapfull <- ellipsoid_overlap(niche_ful, niche_lei, overlap_type = "full")

summary(overlapfull)
                                 
#Background overlap analyses (It can take a long time)
overlap <- ellipsoid_overlap(niche_ful, niche_lei, overlap_type = "back_union",
                             significance_test = TRUE, replicates = 1000)

summary(overlap)

#Saving results
save(overlapfull, overlap, file = "overlap_results_current.RData")


#Visualizing overlap results
plot_overlap(overlap, background = T, proportion = 1, 
             background_type = "back_union")

#Plot for significance test (make sure you asked for it in ellipsoid overlap)
par(mar = c(4.5, 4.5, 0.5, 0))
par(cex = 0.85)
hist(overlap@significance_results$union_random[[1]]$overlap,
     main = "", xlab = "Overlap", xlim = c(0, 1))
abline(v = quantile(overlap@significance_results$union_random[[1]]$overlap, 0.05), 
       col = "darkgreen", lwd = 2, lty = 2)
abline(v = overlap@union_overlap$overlap, col = "green", lwd = 2)
legend("topleft", bty = "n", legend = c("Observed", "5% CL"), 
       col = c("green", "darkgreen"), lty = c(1, 2), lwd = 2, cex = 0.8)



#####
#Past periods

#####
#LGM
#Creating objects needed for niche overlap
niche_ful_lgm <- overlap_object(u_ful_all, species = "name", longitude = "Longitude", 
                                latitude = "Latitude", method = "covmat", level = 95, 
                                variables = ful_lgm)
niche_lei_lgm <- overlap_object(u_lei_all, species = "name", longitude = "Longitude", 
                                latitude = "Latitude", method = "covmat", level = 95, 
                                variables = lei_lgm)

#Background overlap analyses
overlap_lgm <- ellipsoid_overlap(niche_ful_lgm, niche_lei_lgm, 
                                 overlap_type = "back_union", 
                                 significance_test = TRUE, replicates = 1000)

summary(overlap_lgm)


#####
#MH
#Creatting objects need it for niche overlap
niche_ful_mid<- overlap_object(u_ful_all, species = "name", longitude = "Longitude", 
                               latitude = "Latitude", method = "covmat", level = 95, 
                               variables = ful_mh)
niche_lei_mid <- overlap_object(u_lei_all, species = "name", longitude = "Longitude", 
                                latitude = "Latitude", method = "covmat", level = 95, 
                                variables = lei_mh)

#Background overlap analyses
overlap_mh <- ellipsoid_overlap(niche_ful_mid, niche_lei_mid, overlap_type = "back_union",
                                significance_test = F, replicates = 1000)

summary(overlap_mh)


#Saving results
save(overlap_lgm, overlap_mh, file = "overlap_results_past.RData")


#Plotting results
##overlap
###LGM
plot_overlap(overlap_lgm, background = T, proportion = 1, 
             background_type = "back_union")

###MH
plot_overlap(overlap_mh, background = T, proportion = 1, 
             background_type = "back_union")


##Statistical significance
###LGM
par(mar = c(4.5, 4.5, 0.6, 0))
par(cex = 0.85)
hist(overlap_lgm@significance_results$union_random[[1]]$overlap,
     main = "", xlab = "Overlap", xlim = c(0, 1), breaks = 20)
abline(v = quantile(overlap_lgm@significance_results$union_random[[1]]$overlap, 0.05), 
       col = "darkgreen", lwd = 2, lty = 2)
abline(v = overlap_lgm@union_overlap$overlap, col = "green", lwd = 2)
legend("topleft", bty = "n", legend = c("Observed", "5% CL"), 
       col = c("green", "darkgreen"), lty = c(1, 2), lwd = 2, cex = 0.8)

###MH
par(mar = c(4.5, 4.5, 0.6, 0))
par(cex = 0.85)
hist(overlap_mh@significance_results$union_random[[1]]$overlap,
     main = "", xlab = "Overlap", xlim = c(0, 1), breaks = 20)
abline(v = quantile(overlap_mh@significance_results$union_random[[1]]$overlap, 0.05), 
       col = "darkgreen", lwd = 2, lty = 2)
abline(v = overlap_mh@union_overlap$overlap, col = "green", lwd = 2)
legend("topleft", bty = "n", legend = c("Observed", "5% CL"), 
       col = c("green", "darkgreen"), lty = c(1, 2), lwd = 2, cex = 0.8)
