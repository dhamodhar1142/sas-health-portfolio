/* =====================================
   01_data_cleaning.sas
   - Imports NHIS files for listed years
   - Harmonizes to canonical vars
   - Filters to cancer survivors cohort
   ===================================== */

%include "&base./src/99_utils_macros.sas";

/* Example: read CSVs or XPTs; replace with your local filenames. 
   We'll assume per-year CSVs named nhis_YYYY.csv in data/. */

%macro import_year(y);
    proc import datafile="&base./data/nhis_&y..csv"
        out=nhis_&y dbms=csv replace;
        guessingrows=max;
    run;

    data nhis_&y;
        set nhis_&y;

        /* Map/standardize variables; adjust as needed if names differ by year */
        /* Depression ever */
        if missing(DEPEV_A) and not missing(depression_ever) then DEPEV_A = depression_ever;

        /* Cancer ever */
        if missing(CANCEREV_A) and not missing(cancer_ever) then CANCEREV_A = cancer_ever;

        /* Anxiety ever */
        if missing(ANXEV_A) and not missing(anxiety_ever) then ANXEV_A = anxiety_ever;

        /* Poverty ratio or category */
        if missing(RATCAT_A) and not missing(poverty_ratio_cat) then RATCAT_A = poverty_ratio_cat;

        /* General health */
        if missing(GENHLTH_A) and not missing(general_health) then GENHLTH_A = general_health;

        /* Age */
        if missing(AGEP_A) and not missing(age) then AGEP_A = age;

        /* Sex */
        if missing(SEX_A) and not missing(sex) then SEX_A = sex;

        /* Survey design */
        if missing(WTFA_SA) and not missing(weight) then WTFA_SA = weight;
        if missing(STRATA)  and not missing(strata) then STRATA = strata;
        if missing(PSU)     and not missing(psu) then PSU = psu;
    run;
%mend;

%macro import_all;
    %local i y;
    %do i=1 %to %sysfunc(countw(&years));
        %let y = %scan(&years,&i);
        %import_year(&y);
    %end;

    data nhis_all;
        set %sysfunc(tranwrd(&years,%str( ),%str( nhis_)));
        /* cohese all years; add year var if needed */
    run;
%mend;

%import_all;

/* Keep only cancer survivors (CANCEREV_A=1) and non-missing depression */
data nhis_prep;
    set nhis_all;
    where CANCEREV_A=1 and not missing(DEPEV_A);
    /* Recode/derive analysis variables */
    dep01 = %bin01(DEPEV_A);
    anx01 = %bin01(ANXEV_A);
    female = (SEX_A=2);
    /* General health: reverse-score so higher=poorer health if needed */
    genhlth = GENHLTH_A; 

    /* Poverty ratio category as ordinal (if 1..5, adjust to your data) */
    ratcat = RATCAT_A;
run;

/* Basic QC tables */
proc freq data=nhis_prep;
    tables dep01*CANCEREV_A / missing;
run;

proc means data=nhis_prep n mean std;
    var AGEP_A;
run;
