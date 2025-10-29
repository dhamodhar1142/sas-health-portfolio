# Project Report Template (for docs/ or copying into ODS preface)

**Title:** Predicting Depression in U.S. Cancer Survivors (NHIS 2019–2023, SAS)  
**Author:** <Your Name>  
**Date:** <Auto from ODS>  

## Abstract
We developed a survey-weighted logistic regression model to predict the probability of depression among U.S. cancer survivors using NHIS 2019–2023 data. The model identifies socioeconomic and clinical correlates of risk and produces deployable score code.

## Data & Methods
- Data: NHIS public microdata (2019–2023)
- Outcome: Depression ever (`DEPEV_A`)
- Key predictors: cancer history, anxiety diagnosis, poverty ratio, general health, age, sex
- Model: `PROC SURVEYLOGISTIC` with PSU/strata/weights
- Validation: ROC/AUC and calibration statistics

## Results
- AUC ≈ 0.84 (example)
- Anxiety and poor general health are strong positive predictors
- Higher poverty risk correlates with higher depression odds

## Discussion
Implications for screening workflows in survivorship clinics, limitations (cross-sectional design), and next steps (external validation, temporal modeling).

## Appendix
- Variable codebook
- Model specification
- Score macro usage
