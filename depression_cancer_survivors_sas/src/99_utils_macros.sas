/* =============================
   99_utils_macros.sas
   Set base path + helper macros
   ============================= */

%let base = /mnt/data/sas-health-portfolio/depression_cancer_survivors_sas;  /* <-- CHANGE THIS IN SAS */
%let years = 2019 2020 2021 2022 2023;

/* Output folder */
%let outdir = &base./outputs;

/* Ensure output directory exists (works in SAS on most OS if permissions ok) */
options dlcreatedir;
libname out "&outdir";

/* Macro: yes/no to 1/0 */
%macro bin01(var);
    (case when &var.=1 then 1
          when &var.=2 then 0
          else . end)
%mend;

/* Macro: Safe label for plots */
%macro safeLabel(s);
    %sysfunc(tranwrd(&s.,_,%str( )))
%mend;

/* Macro: Score logistic model into a probability (requires STORE from PROC PLM) */
%macro score_logistic(inp=, out=, store=work.log_model_store);
    proc plm restore=&store;
        score data=&inp out=&out pred=phat;
    run;
%mend;
