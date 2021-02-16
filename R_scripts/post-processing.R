################
# Project: Non-overlapping climatic niches and biogeographic barriers explain
#          disjunct distributions of continental Urania moths
# Authors: Claudia Nunez-Penichet, Marlon Cobos, Jorge Soberon
# Process: Post-processing
# Date: 16/02/2021
################

#Load package
library(raster)

#Working directory
setwd("YOUR/DIRECTORY/Data")

#Reading model results
u_ful <- raster("ellipsenm_model_uful/mean_suitability_calibration_Urania_fulgens.tif.tif")
u_lei <- raster("ellipsenm_model_ulei/mean_suitability_calibration_Urania_leilus.tif.tif")
omp <- raster("ellipsenm_model_omp/mean_suitability_calibration_Omphalea_brasiliensis.tif.tif")

#Create folder for results
dir.create("Binary")

#Binarize
u_fulB <- u_ful > 0
plot(u_fulB)

u_leiB <- u_lei > 0
plot(u_leiB)

ompB <- omp > 0
plot(ompB)

#Overlap u.ful and u.lei
ove <- u_fulB * u_leiB
plot(ove)

#Save
writeRaster(ove, filename = "Binary/SpatialOverlap.tif", format = "GTiff")
writeRaster(ompB, filename = "Binary/Omphalea.tif", format = "GTiff")
writeRaster(u_fulB, filename = "Binary/U.fulgens.tif", format = "GTiff")
writeRaster(u_leiB, filename = "Binary/U.leilus.tif", format = "GTiff")

#Area comparison
uu_union <- (u_fulB + u_leiB) > 0 
plot(uu_union)
ove_omp <- ove * ompB
plot(ove_omp)

p_ove_m <- sum(na.omit(ove[]) == 1) / sum(na.omit(ove[]) >= 0)
p_ove_union <- sum(na.omit(ove[]) == 1) / sum(na.omit(uu_union[]) == 1) 
p_ove_uful <- sum(na.omit(ove[]) == 1) / sum(na.omit(u_fulB[]) == 1)
p_ove_ulei <- sum(na.omit(ove[]) == 1) / sum(na.omit(u_leiB[]) == 1)
p_ove_omp <- sum(na.omit(ove_omp[]) == 1) / sum(na.omit(ompB[]) == 1)

#Final table
overlaps_g <- data.frame(Overlap_type = c("Overlap/M", "Overlap/Union_Uranias", "Overlap/U_fulgens", 
                                          "Overlap/U_leilus", "Overlap/Omphalea"),
                         Proportions = c(p_ove_m, p_ove_union, p_ove_uful, p_ove_ulei, p_ove_omp),
                         Percentages = c(p_ove_m, p_ove_union, p_ove_uful, p_ove_ulei, p_ove_omp) * 100)

#Save table
write.csv(overlaps_g, "Binary/Overlap_proportions.csv", row.names = FALSE)



#Area proportions
p_uu_nion_m <- sum(na.omit(uu_union[]) == 1) / sum(na.omit(uu_union[]) >= 0)
p_uful_m <- sum(na.omit(u_fulB[]) == 1) / sum(na.omit(uu_union[]) >= 0)
p_ulei_m <- sum(na.omit(u_leiB[]) == 1) / sum(na.omit(uu_union[]) >= 0)
p_omp_m <- sum(na.omit(ompB[]) == 1) / sum(na.omit(uu_union[]) >= 0)

#Final table
proportions_g <- data.frame(Overlap_type = c("Union_Uranias/M","U_fulgens/M", "U_leilus/M", "Omphalea/M"),
                            Proportions = c(p_uu_nion_m, p_uful_m, p_ulei_m, p_omp_m),
                            Percentages = c(p_uu_nion_m, p_uful_m, p_ulei_m, p_omp_m) * 100)

#Save table
write.csv(proportions_g, "Binary/Area_proportions.csv", row.names = FALSE)