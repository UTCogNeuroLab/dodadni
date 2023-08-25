# TRACULA stats
# conduct tract stats after running trac-all processing steps
# Makenna McGill

# source freesurfer
export FREESURFER_HOME=/Applications/freesurfer/7.3.2
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export ANTSPATH=/Applications/ANTs/bin/
export PATH=${ANTSPATH}:$PATH
export bids_dir=/Volumes/schnyer/Makenna/DODADNI/BIDS
export SUBJECTS_DIR=$bids_dir/derivatives/t1prep
export stats_out_dir=$bids_dir/derivatives/tracula/stats_outputs
cd $SUBJECTS_DIR


# run tracula stats
trac-all -stat -c $bids_dir/derivatives/tracula/config/tracula_config.txt

# check for outliers
stats/<tract>.avg<nsubj>_<inter>_<intra>.log
# this log file contains information about which inputs were flagged as outliers (potential failed pathway reconstructions) and excluded from the group tables

# create directories
cd /Volumes/schnyer/Makenna/DODADNI/BIDS/derivatives/tracula/stats_outputs
mkdir tbi tbi_covar tbi_age tbi_ptsd tbi_vas vas vas_covar vas_ptsd vas_age ptsd ptsd_covar ptsd_age

tract=$1
### for tract in `cat /Volumes/schnyer/Makenna/DODADNI/BIDS/derivatives/tracula/stats_outputs/tract_stat_list.txt`; do sh /Volumes/schnyer/Makenna/DODADNI/Scripts/tracula_stats.sh $tract; done
echo $tract

# health condition: tbi

# max FA
printf "\n \n *************** starting tbi tract stats for max FA in "$tract" *************** \n \n"
# run generalized linear model using maximum a posteriori path
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi.txt --o $stats_out_dir/tbi/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, controlling for ptsd, age, and vas burden
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi_covar.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi_covar.txt --o $stats_out_dir/tbi_covar/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi_covar/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling age
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi_age.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi_age_int.txt --o $stats_out_dir/tbi_age/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi_age/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling ptsd
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi_ptsd.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi_ptsd_int.txt --o $stats_out_dir/tbi_ptsd/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi_ptsd/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling vas burden
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi_vas.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi_vas_int.txt --o $stats_out_dir/tbi_vas/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi_vas/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs
printf "*************** tbi tract stats complete for max FA in "$tract" *************** \n \n"

# max MD
printf "\n \n *************** starting tbi tract stats for max MD in "$tract" *************** \n \n"
# run generalized linear model using maximum a posteriori path
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi.txt --o $stats_out_dir/tbi/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, controlling for ptsd, age, and vas burden
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi_covar.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi_covar.txt --o $stats_out_dir/tbi_covar/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi_covar/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling age
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi_age.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi_age_int.txt --o $stats_out_dir/tbi_age/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi_age/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling ptsd
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi_ptsd.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi_ptsd_int.txt --o $stats_out_dir/tbi_ptsd/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi_ptsd/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling vas burden
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_tbi_vas.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_tbi_vas_int.txt --o $stats_out_dir/tbi_vas/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/tbi_vas/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs
printf "*************** tbi tract stats complete for max MD in "$tract" *************** \n \n";


# health condition: vascular burden

# first run models for max FA
printf "\n \n *************** starting vas burden tract stats for max FA in "$tract" *************** \n \n"
# run generalized linear model using maximum a posteriori path, without covariates
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_vas.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_vas.txt --o $stats_out_dir/vas/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/vas/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, controlling for tbi, ptsd, and age
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_vas_covar.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_vas_covar.txt --o $stats_out_dir/vas_covar/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/vas_covar/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling tbi status
# for vas X tbi interaction, see results from tbi_vas/matrix_tbi_vas_int

# run generalized linear model using maximum a posteriori path, modeling ptsd
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_vas_ptsd.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_vas_ptsd_int.txt --o $stats_out_dir/vas_ptsd/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/vas_ptsd/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling age
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_vas_age.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_vas_age_int.txt --o $stats_out_dir/vas_age/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/vas_age/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs
printf "*************** vas burden tract stats complete for max FA in "$tract" *************** \n \n"

# repeat the process for max MD
printf "\n \n *************** starting vas burden tract stats for max MD in "$tract" *************** \n \n"
# run generalized linear model using maximum a posteriori path, without covariates
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_vas.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_vas.txt --o $stats_out_dir/vas/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/vas/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, controlling for tbi, ptsd, and age
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_vas_covar.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_vas_covar.txt --o $stats_out_dir/vas_covar/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/vas_covar/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling tbi status
# for vas X tbi interaction, see results from tbi_vas/matrix_tbi_vas_int

# run generalized linear model using maximum a posteriori path, modeling ptsd
# contrast: is there an interaction between vas burden and ptsd?
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_vas_ptsd.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_vas_ptsd_int.txt --o $stats_out_dir/vas_ptsd/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/vas_ptsd/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling age
# contrast: is there an interaction between vas burden and age?
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_vas_age.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_vas_age_int.txt --o $stats_out_dir/vas_age/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/vas_age/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs
printf "*************** vas burden tract stats complete for max MD in "$tract" *************** \n \n";


# health condition: ptsd

# first run models for max FA
printf "\n \n *************** starting ptsd tract stats for max FA in "$tract" *************** \n \n"
# run generalized linear model using maximum a posteriori path, without covariates
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_ptsd.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_ptsd.txt --o $stats_out_dir/ptsd/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/ptsd/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, controlling for tbi, vas burden, and age
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_ptsd_covar.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_ptsd_covar.txt --o $stats_out_dir/ptsd_covar/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/ptsd_covar/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling tbi status
# for ptsd X tbi interaction, see results from tbi_ptsd/matrix_tbi_ptsd_int

# run generalized linear model using maximum a posteriori path, modeling vas burden
# for ptsd X vas interaction, see results from vas_ptsd/matrix_vas_ptsd_int

# run generalized linear model using maximum a posteriori path, modeling age
# contrast: is there an interaction between ptsd and age?
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.FA.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_ptsd_age.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_ptsd_age_int.txt --o $stats_out_dir/ptsd_age/"$tract".FA_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/ptsd_age/"$tract".FA_max.glmdir --cwp .05 --perm 1000 1.3 abs
printf "*************** ptsd tract stats complete for max FA in "$tract" *************** \n \n"

# repeat the process for max MD
printf "\n \n *************** starting ptsd tract stats for max MD in "$tract" *************** \n \n"
# run generalized linear model using maximum a posteriori path, without covariates
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_ptsd.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_ptsd.txt --o $stats_out_dir/ptsd/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/ptsd/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, controlling for tbi, vas burden, and age
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_ptsd_covar.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_ptsd_covar.txt --o $stats_out_dir/ptsd_covar/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/ptsd_covar/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs

# run generalized linear model using maximum a posteriori path, modeling tbi status
# for ptsd X tbi interaction, see results from tbi_ptsd/matrix_tbi_ptsd_int

# run generalized linear model using maximum a posteriori path, modeling vas burden
# for ptsd X vas interaction, see results from vas_ptsd/matrix_vas_ptsd_int

# run generalized linear model using maximum a posteriori path, modeling age
# contrast: is there an interaction between ptsd and age?
mri_glmfit --y $bids_dir/derivatives/tracula/stats/"$tract".avg16_syn_bbr.MD.nii.gz --fsgd $bids_dir/derivatives/tracula/fsgd/fsgd_ptsd_age.txt dods --C $bids_dir/derivatives/tracula/fsgd/matrix_ptsd_age_int.txt --o $stats_out_dir/ptsd_age/"$tract".MD_max.glmdir --eres-save
# correct for multiple comparisons
mri_glmfit-sim --glmdir $stats_out_dir/ptsd_age/"$tract".MD_max.glmdir --cwp .05 --perm 1000 1.3 abs
printf "*************** ptsd tract stats complete for max MD in "$tract" *************** \n \n";
