/* ============================
   03_reporting.sas
   - ODS PDF report with tables/figures
   ============================ */

%include "&base./src/99_utils_macros.sas";

ods listing close;
ods pdf file="&outdir./Depression_Model_Report.pdf" dpi=300 notoc;
ods noproctitle;

title1 "Predicting Depression in U.S. Cancer Survivors (NHIS 2019–2023)";
footnote1 j=r "Generated on %sysfunc(date(),worddate.)";

proc document name=work.rpt; run; quit;

/* Descriptives */
proc freq data=nhis_prep;
    tables dep01 female anx01 ratcat genhlth / missing;
    title2 "Descriptive Statistics (Key Variables)";
run;

/* Model fit stats (requires prior run of 02_model_building.sas in same session) */
proc print data=fit_stats label; 
    title2 "Model Fit Statistics (Survey-Weighted Logistic)";
run;

proc print data=param_est label;
    title2 "Parameter Estimates (Survey-Weighted Logistic)";
run;

proc sgplot data=roc_pts;
    title2 "ROC Curve (Survey-Weighted)";
    series x=_1MSPEC_ y=_SENSIT_;
    xaxis label="1 - Specificity"; yaxis label="Sensitivity";
run;

proc print data=auc_summary; 
    title2 "AUC Comparison (Survey vs. Unweighted)";
run;

ods pdf close;
ods listing;
