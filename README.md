# dodadni
code for white matter analysis of Department of Defense Alzheimer's Disease Neuroimaging Initiative (DoD-ADNI) data  

**White matter microstructure analyses:**  
Analyses were conducted using FreeSurfer's TRACULA  
_Statistics_  
See /tracula_stats.sh for use of along-tract statistics and mri_glmfit  
See /tracula_stats_matrices.zip for matrices used in glms  
_Visualization_  
See /concatenate_tracula_profile_data_max.py for concatenation of along-tract data to be used for data visualization  
See /tract_profile_plot.py for creation of tract profile plots  

**White matter macrostructure analyses:**  
Robust regression was conducted in R using the MASS package  
See /dodadni_regressions.R  

**Cognitive performance analyses:**  
Elastic net regressions were conducted in R using the beset package  
See /dodadni_regressions.R  
