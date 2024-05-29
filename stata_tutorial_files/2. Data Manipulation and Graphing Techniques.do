* Do file for Data Manipulation and Graphing Techniques
* Stata Workshop - Part 2
* Author: Paola Jaimes Santamaria
* Date: June 4

* Clear any existing data from memory
clear all

* Set the path for the data files (assuming you have the GSS dataset)
global path_data  "/Users/paolajaimes/Library/CloudStorage/OneDrive-UniversityofOttawa/Stata workshop"

* Load the GSS dataset \\ https://www.thearda.com/data-archive?fid=GSS2022&tab=3

use "${path_data}/GSS_2022.dta", clear

/********** Basic Data Exploration **********/

describe
codebook

/********** Data Manipulation Basics **********/


* Renaming variables for clarity

rename wrkstat work_status
rename OCC10 occupation

* ordering 

order mun_code year mun_code_m, first

* Creating new variables

* Creating dummy variables based on conditions
generate high_education = educ >= 16

* Generate the logarithm of inflation-adjusted personal income
* Before taking the log, replace 0 or negative values as they are not valid for log transformation
gen conrinc_log = log(conrinc) if conrinc > 0

* It's also good practice to label new variables for clarity
label variable conrinc_log "Log of Inflation-Adjusted Personal Income"

* Create an interaction term between age and education level
generate age_educ_interaction = age * educ

// Situation 1: Create a dummy variable for full-time work status & make work_status as a simpler measure. 

codebook work_status
generate full_time = (work_status == 1)

* Recoding work_status to a simpler category

* Recode work_status into three categories: Employed (1-3), Unemployed (4), and Other (5-8)

* First, generate a new numeric variable for the simplified work status
gen simple_work_status = .
replace simple_work_status = 1 if inrange(work_status, 1, 3) // Employed
replace simple_work_status = 2 if work_status == 4          // Unemployed
replace simple_work_status = 3 if inrange(work_status, 5, 8) // Other

* Now that simple_work_status is numeric, we can label it
label define work_status_label 1 "Employed" 2 "Unemployed" 3 "Other"
label values simple_work_status work_status_label

* Verify the creation of the new variable
tabulate simple_work_status


// Situation 2: Creating a categorical variable for income levels

* Define quintiles for the income variable
xtile income_quintile = conrinc, nq(5)

* Generate new numeric categorical income variable based on quintiles
gen income_category = 3 if income_quintile == 5
replace income_category = 2 if inrange(income_quintile, 3, 4)
replace income_category = 1 if inrange(income_quintile, 1, 2)

* Now that income_category is numeric, we can label it:
* This is done using 'label define' which creates a set of mappings from numeric codes to human-readable text labels.
label define income_cat_label 1 "Low" 2 "Medium" 3 "High"
* After defining the labels, 'label values' attaches these text labels to the values of 'income_category'.
label values income_category income_cat_label

* As a result, when we display or analyze 'income_category', Stata will show 'Low', 'Medium', and 'High' instead of 1, 2, and 3.
tabulate income_category


// Situation 3: Creating a composite score variable based on multiple criteria

* Suppose we want to create a "financial stability score" based on income and employment status
* Let's assume higher income and full-time work indicate higher stability

* Generate a stability score variable with initial value of 0
gen stability_score = 0

* Increase the stability score by 1 for each quintile above the lowest
replace stability_score = stability_score + income_quintile - 1

* Add 2 to the stability score if the individual is employed full-time
replace stability_score = stability_score + 2 if full_time == 1

* Label the stability score variable
label variable stability_score "Financial Stability Score"

* Inspect the new stability score
summarize stability_score

* The stability score ranges from 0 to 6, combining income and employment status: 0 for lowest income and not full-time, up to 6 for highest income and full-time employed

* Saving the manipulated dataset for future use
save "${path_data}/GSS_2022_manipulated.dta", replace

/********** Graphing Techniques **********/

* Graph 1: Pie charts

graph pie, over(work_status) title("Work Status in the US 2022")


* Graph 2: Create a bar graph showing the percentage vote by age group in 2020. I want to calculate the information in this table: 

tabulate I_AGE PRES20, rowva

* Drop observations where I_AGE or PRES20 is missing
drop if missing(I_AGE) | missing(PRES20)

* Calculate the total number of respondents in each age group
egen group_total = total(1), by(I_AGE)

* Calculate percentages within each age group
egen total_biden = total(PRES20 == 1), by(I_AGE)
egen total_trump = total(PRES20 == 2), by(I_AGE)
egen total_other = total(PRES20 == 3), by(I_AGE)
egen total_did_not_vote = total(PRES20 == 4), by(I_AGE)

* Generate percentage variables
gen pct_biden = 100 * total_biden / group_total
gen pct_trump = 100 * total_trump / group_total
gen pct_other = 100 * total_other / group_total
gen pct_did_not_vote = 100 * total_did_not_vote / group_total

* Collapse the dataset to unique age groups with these new variables
collapse (mean) pct_biden pct_trump pct_other pct_did_not_vote, by(I_AGE)

* Create a stacked bar graph
graph bar (asis) pct_biden pct_trump pct_other pct_did_not_vote, over(I_AGE) ///
    blabel(bar, format(%9.0g) position(outside)) ///
    legend(order(1 "Biden" 2 "Trump" 3 "Other" 4 "Didn't vote")) ///
    title("Voting Preferences by Age Group") ///
    ylabel(0(10)100, grid) ///
    ytitle("Percentage of Respondents") ///
    bargap(10)

* Save processed data (optional)
save "processed_voting_preferences.dta", replace

// Creating a panel data (2001-2022) and filling it with data // 

use "${path_data}/municipalities.dta", clear

// Step 1: Create a new variable that is the count of years (21 years from 2001 to 2022)
gen nyears = 22

// Step 2: Expand the dataset by the number of years
expand nyears

// Step 3: Generate the year variable
bysort mun_code: gen year = 2000 + _n

// Step 4: Drop the temporary variable used for expansion
drop nyears

// Step 5: Set the data as panel data structure
xtset mun_code year

save "mypanel.dta", replace 

// Reshapping my data (from wide to long): // 

// Coca crops in Colombia: from: https://www.datos.gov.co/Justicia-y-Derecho/Detecci-n-de-Cultivos-de-Coca-hect-reas-/acs4-3wgp/about_data.
// Observatorio de Drogas de Colombia, del Ministerio de Justicia y del Derecho.
// Each cell represents the number of coca cultivation in hectares per year/municipality.

// The stringcols(5) option specifies that the first 5 columns should be imported as strings
import delimited "${path_data}/coca_crops_2001-2022.csv", stringcols(5) clear

// Rename the variables representing coca cultivation for each year
// The variables v5 to v26 correspond to coca cultivation data from 2001 to 2022
foreach num of numlist 5/26 {
    rename v`num' coca`=`num' + 1996'
}

// Convert the coca cultivation variables from string to numeric
// The replace force option forces the conversion even if some data cannot be converted
destring coca2001-coca2022, replace force

// Reshape the data from wide format to long format
// i(coddepto departamento codmpio municipio) specifies the identifiers that remain constant
// j(year) specifies the variable whose values will become separate observations
reshape long coca, i(coddepto departamento codmpio municipio) j(year)

// Rename the municipality code variable to mun_code to match the primary dataset
rename codmpio mun_code

// Save the reshaped and processed coca crops data
save "coca_crops_2001-2022_modified.dta", replace

// Merging both datasets

// Load the primary dataset
use "mypanel.dta", clear

// Merge the datasets using mun_code and year as key variables
merge 1:1 mun_code year using "coca_crops_2001-2022_modified.dta", keepusing(coca)

// Drop the merge indicator variable if merge was successful
drop _merge

// Save the final merged dataset
save "mypanel_final.dta", replace


