# DODADNI statistical analyses
# Makenna McGill

# tract cluster windows ---------------------------------------------------------

# significant clusters were produced by along-tract analyses conducted using FS glm
# determine windows of significance for visualization purposes

# tbi vs con (w/ covariates) for node around the significant cluster (for fa in rh cst, this is node 67)
{
rhcst_65 <- lm(FA_65_rh.cst~tbi_group+vas_burden+ptsd+age, data=dftract)
summary(rhcst_65) # not sig
rhcst_66 <- lm(FA_66_rh.cst~tbi_group+vas_burden+ptsd+age, data=dftract)
summary(rhcst_66) # sig
rhcst_67 <- lm(FA_67_rh.cst~tbi_group+vas_burden+ptsd+age, data=dftract)
summary(rhcst_67) # sig
rhcst_68 <- lm(FA_68_rh.cst~tbi_group+vas_burden+ptsd+age, data=dftract)
summary(rhcst_68) # sig
rhcst_69 <- lm(FA_69_rh.cst~tbi_group+vas_burden+ptsd+age, data=dftract)
summary(rhcst_69) # sig
rhcst_70 <- lm(FA_70_rh.cst~tbi_group+vas_burden+ptsd+age, data=dftract)
summary(rhcst_70) # sig
rhcst_71 <- lm(FA_71_rh.cst~tbi_group+vas_burden+ptsd+age, data=dftract)
summary(rhcst_71) # sig
rhcst_72 <- lm(FA_72_rh.cst~tbi_group+vas_burden+ptsd+age, data=dftract)
summary(rhcst_72) # not sig
# fa rh cst cluster spans from node 66 to node 71
}

# vascular burden (w/ covariates) for fa in ccbodyc at node 42
{
bodyc_36 <- lm(FA_36_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_36) # not sig
bodyc_37 <- lm(FA_37_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_37) # sig
bodyc_38 <- lm(FA_38_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_38) # sig
bodyc_39 <- lm(FA_39_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_39) # sig
bodyc_40 <- lm(FA_40_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_40) # sig
bodyc_41 <- lm(FA_41_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_41) # sig
bodyc_42 <- lm(FA_42_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_42) # sig
bodyc_43 <- lm(FA_43_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_43) # sig
bodyc_44 <- lm(FA_44_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_44) # sig
bodyc_45 <- lm(FA_45_cc.bodyc~vas_burden+tbi_group+ptsd+age, data=dftract)
summary(bodyc_45) # not sig
# fa ccbodyc cluster spans from node 37 to node 44
}


# wmh robust regression -------------------------------------------------------
library(tidyverse)
library(beset)
library(MASS)
library(sfsmisc)

# for the rlm function in MASS, Huber weighting is the default
robust_wmh_hub <- rlm(logwmh~age+vas+ptsd+tbi, data=dfwmhreg)
summary(robust_wmh_hub)
# view the huber weights
hweights <- data.frame(logwmh=dfwmhreg$logwmh, age=dfwmhreg$age, vas=dfwmhreg$vas, ptsd=dfwmhreg$ptsd, tbi=dfwmhreg$tbi, resid=robust_wmh_hub$resid, weight=robust_wmh_hub$w)
hweights2 <- hweights[order(robust_wmh_hub$w), ]
hweights2
# try running with bisquare weighting
robust_wmh_bi <- rlm(logwmh~age+vas+ptsd+tbi, data=dfwmhreg, psi=psi.bisquare)
summary(robust_wmh_bi)
# view the bisquare weights
bweights <- data.frame(logwmh=dfwmhreg$logwmh, age=dfwmhreg$age, vas=dfwmhreg$vas, ptsd=dfwmhreg$ptsd, tbi=dfwmhreg$tbi, resid=robust_wmh_bi$resid, weight=robust_wmh_bi$w)
bweights2 <- bweights[order(robust_wmh_bi$w), ]
bweights2
# compare residual std errors of models
# ols
ols_wmh <- lm(logwmh~age+vas+ptsd+tbi, data=dfwmhreg)
summary(ols_wmh)$sigma
# huber
summary(robust_wmh_hub)$sigma
# bisquare
summary(robust_wmh_bi)$sigma
# robust reg with bisquare weighting has lower residual std error
# using the bisquare model...
# identify p values
f.robftest(robust_wmh_bi, var = "age") # sig
f.robftest(robust_wmh_bi, var = "vas") # sig
f.robftest(robust_wmh_bi, var = "tbi") # not sig
f.robftest(robust_wmh_bi, var = "ptsd") # not sig
# calculate standardized betas
library(QuantPsyc)
dfwmhreg_z <- as.data.frame(Make.Z(dfwmhreg))
robust_wmh_bi_z <- rlm(logwmh~age+vas+ptsd+tbi, data=dfwmhreg_z, psi=psi.bisquare)
summary(robust_wmh_bi_z)
# cross validate using beset package
validate(robust_wmh_bi)

# cognition elastic net regressions -------------------------------------------------

library(tidyverse)
library(beset)

# run elastic net predicting aef
{
aef_elnet <- beset_elnet(aef~., data = dfcogreg[, c(1:4, 8:65)], nest_cv = TRUE)
summary(aef_elnet, robust = FALSE)
# primarily lasso (alpha = 0.970, lambda = 0.470)
validate(aef_elnet)
# CV-Test Holdout Variance explained is 0.052, MAE = 0.625
imp_aef_elnet <- importance(aef_elnet)
importance(aef_elnet)
# wmh most important
# plot
predictors <- c("logwmh","vas_md_66_lhaf","vas_md_78_lhaf","vas_md_42_ccbodyc","vas_md_50_lhilf","vas_md_8_acomm","vas_md_62_lhslf2","vas_md_59_rhaf")
labels <- c("WMH volume","MD left arcuate fasciculus node 66","MD left arcuate fasciculus node 78","MD corpus callosum body node 42","MD left inferior long. fasciculus node 50","MD anterior commissure node 8","MD left superior long. fasciculus node 62","MD right arcuate fasciculus node 59")
dflabel_aef <- data.frame(predictors, labels)
plot_aef_elnet <- plot(imp_aef_elnet, p_max=8, labels=dflabel_aef)
plot_aef_elnet
}

# run elastic net predicting vl
{
vl_elnet <- beset_elnet(vl~., data = dfcogreg[, c(1:3, 5, 8:65)], nest_cv = TRUE)
summary(vl_elnet, robust = FALSE)
validate(vl_elnet)
# CV-Test Holdout Variance explained is -0.018, MAE = 1.834
# negative variance; not meaningful prediction
}

# run elastic net predicting vm
{
vm_elnet <- beset_elnet(vm~., data = dfcogreg[, c(1:3, 6, 8:65)], nest_cv = TRUE)
summary(vm_elnet, robust = FALSE)
validate(vm_elnet)
# CV-Test Holdout Variance explained is -0.026, MAE = 0.637
# negative variance; not meaningful prediction
}

