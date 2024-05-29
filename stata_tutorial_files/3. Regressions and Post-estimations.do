* Do file for Regressions and Post-estimations
* Stata Workshop - Part 3
* Author: Paola Jaimes Santamaria
* Date: June 4

// Load necessary libraries
clear all

// Set the working directory to where your datasets are located
cd "/Users/paolajaimes/Library/CloudStorage/OneDrive-UniversityofOttawa/Stata workshop"

// 1.  Cross-sectional data

webuse auto, clear

// Running a basic regression
regress price weight foreign##c.mpg

// After estimation, we can review diagnostic plots: 

//  avplots command for augmented component-plus-residual (partial regression) plots. These plots show the partial relationship between each predictor and the dependent variable after accounting for the effects of other predictors.

avplots

// rvfplot command (residuals versus fitted values plot) to create a residuals versus fitted values plot for diagnosing heteroscedasticity. In this plot, the spread of residuals increases with the fitted values, suggesting the presence of heteroscedasticity.
rvfplot


// Test for heteroscedasticity using the Breusch-Pagan/Cook-Weisberg test
// This test examines whether the variance of the residuals is constant (homoscedasticity) or varies (heteroscedasticity). // Since the p-value (0.0108) is less than 0.05, we reject the null hypothesis of constant variance, indicating the presence of heteroscedasticity. 

estat hettest

// There are several ways to address heteroscedasticity:

regress price weight foreign##c.mpg, robust

// Transform the dependent variable (e.g., log transformation) to stabilize the variance:

gen log_price = log(price)
regress log_price weight foreign##c.mpg


// 2. Panel Data Regression

// Load the panel data
webuse nlswork, clear

// Setting the panel data structure
xtset idcode year

// Fixed-effects model
// The fixed-effects model (FE) controls for time-invariant characteristics of the individuals. It allows for correlation between the individual-specific effects and the regressors.
xtreg ln_wage age tenure, fe
// Save the fixed-effects estimation results
estimates store fe

// Random-effects model
// The random-effects model (RE) assumes that the individual-specific effects are uncorrelated with the regressors. 
xtreg ln_wage age tenure, re
// Save the random-effects estimation results
estimates store re

// Hausman test to decide between FE and RE
// The Hausman test compares the FE and RE estimators to test whether the individual-specific effects are correlated with the regressors.
// Null hypothesis (H0): The RE model is appropriate (individual effects are uncorrelated with the regressors).
// Alternative hypothesis (H1): The FE model is appropriate (individual effects are correlated with the regressors).
// If the p-value is less than 0.05, reject H0, suggesting that the FE model is more appropriate.
hausman fe re

// Saving/exporting my results: 

// Additional Regressions with Different Specifications

// 1. Fixed-effects model with robust standard errors
xtreg ln_wage age tenure, fe robust
// Save the fixed-effects estimation results with robust standard errors
estimates store fe_robust

// 2. Random-effects model with clustered standard errors by idcode
xtreg ln_wage age tenure, re vce(cluster idcode)
// Save the random-effects estimation results with clustered standard errors
estimates store re_cluster

// 3. Fixed-effects model with additional controls (grade, not_smsa)
xtreg ln_wage age tenure grade not_smsa, fe
// Save the fixed-effects estimation results with additional controls
estimates store fe_controls

// 4. Random-effects model with additional controls and robust standard errors
xtreg ln_wage age tenure grade not_smsa, re robust
// Save the random-effects estimation results with additional controls and robust standard errors
estimates store re_controls_robust

// 5. Fixed-effects model with time fixed effects
xtreg ln_wage age tenure i.year, fe
// Save the fixed-effects estimation results with time fixed effects
estimates store fe_time

// Exporting the Results to Excel
// The outreg2 command is used to export regression results to an Excel file.
// Ensure outreg2 is installed: ssc install outreg2
// to install: ssc install outreg2
// Export the results
outreg2 [fe re fe_robust re_cluster fe_controls re_controls_robust fe_time] using "regression_results.xlsx", replace excel

// Exporting the Results to LaTeX
// Use outreg2 to export the regression results to a LaTeX file
outreg2 [fe re fe_robust re_cluster fe_controls re_controls_robust fe_time] using "regression_results.tex", replace tex

// You can also save them by doing: 

xtreg ln_wage age tenure grade not_smsa, fe
outreg2 using "regression_results.tex", replace tex

xtreg ln_wage age tenure grade not_smsa, re
outreg2 using "regression_results.tex", append tex

// 3. Using margins: 

// Dataset: National Longitudinal Survey of Youth (NLSY). 

* Load the dataset
sysuse nlsw88, clear

* Inspect the data
describe
summarize

* Recode race variable for easier interpretation
label define race 1 "White" 2 "Black" 3 "Other"
label values race race

* Fit a regression model 
regress wage collgrad##race age

* Use the margins command to analyze interaction effects.  
* This command calculates the predicted wages for each race category
* at different levels of collgrad (0 = non-graduate, 1 = graduate).
margins race, at(collgrad=(0 1))

* Predicted wages increase with college graduation for all races (not too clear for Other).
* The largest increase is observed for Black individuals, who also have the highest predicted wages with a college degree. White non-graduates have higher predicted wages compared to Black and Other non-graduates.

* Plot the margins
marginsplot, x(race) plot1opts(msymbol(O) mcolor(red)) ///
             plot2opts(msymbol(S) mcolor(blue)) ///
             title("Predicted Wages by Race and College Graduation") ///
             ytitle("Predicted Wage") xtitle("Race") ///
             legend(order(1 "Non-Graduate" 2 "Graduate"))

* Additional margins for interpretation * This command calculates the average marginal effect of college graduation (collgrad) on wages for each race. 
margins, dydx(collgrad) at(race=(1 2 3))


