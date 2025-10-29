/* ==============================
   02_model_building.sas
   - Survey-weighted logistic model
   - Saves key outputs for reporting
   ============================== */

%include "&base./src/99_utils_macros.sas";

ods graphics on;

/* Survey-aware logistic */
proc surveylogistic data=nhis_prep;
    strata STRATA; cluster PSU; weight WTFA_SA;
    class female(ref='0') / param=ref;
    model dep01(event='1') = AGEP_A female anx01 ratcat genhlth
                              / rsquare lackfit;
    ods output ROCcurve=roc_pts ROCAssociation=roc_stats ParameterEstimates=param_est FitStatistics=fit_stats;
    store work.log_model_store;
run;

/* Unweighted comparison (optional) */
proc logistic data=nhis_prep plots(only)=roc;
    class female(ref='0') / param=ref;
    model dep01(event='1') = AGEP_A female anx01 ratcat genhlth / lackfit outroc=roc_unw;
    ods output ROCAssociation=roc_stats_unw;
run;

/* Save AUC to dataset */
data auc_summary;
    length model $20;
    set roc_stats(in=a where=(label2='c')) /* survey */
        roc_stats_unw(in=b where=(label2='c')); /* unweighted */
    if a then model='survey';
    if b then model='unweighted';
    keep model nvalue2;
    rename nvalue2=AUC;
run;

proc sort data=auc_summary; by descending AUC; run;

proc print data=auc_summary; title "AUC Summary"; run;

/* Example scoring (in-memory) */
%score_logistic(inp=nhis_prep, out=scored);
proc means data=scored n mean std min p50 max;
    var phat;
    title "Predicted Probabilities Summary";
run;

ods graphics off;
