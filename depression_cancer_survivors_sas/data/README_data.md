# Where to put data

Place NHIS microdata files (2019–2023) here, preferably CSV or XPT (SAS transport). 
The scripts expect (or recode to) the following canonical variables:
- Depression ever: `DEPEV_A` (1=yes, 2=no)
- Cancer history:  `CANCEREV_A` (1=yes, 2=no)
- Anxiety dx:     `ANXEV_A` (1=yes, 2=no)
- Poverty ratio:  `RATCAT_A` (or continuous `POVRAT` where available)
- General health: `GENHLTH_A` (1=Excellent ... 5=Poor or similar scale)
- Age:            `AGEP_A`
- Sex:            `SEX_A` (1=Male, 2=Female)
- Survey: PSU `PSU`, strata `STRATA`, weight `WTFA_SA` (or year-specific weight)

If your local variable names differ by year, `01_data_cleaning.sas` includes mappings.
