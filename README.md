# Stata Tutorial for Second-Year PhD Students in Economics

Welcome to the Stata Tutorial repository. This tutorial is designed for second-year PhD students in economics. It contains all the materials you'll need for our introductory Stata course, including DO files with well-commented code, datasets, and instructions for using Stata effectively. By following this tutorial, you will develop a solid foundation in using Stata for your research projects.

## Getting Started

### Prerequisites

- Stata (version 16 or later)
- Basic knowledge of econometrics

### Installation

#### Downloading Stata

Stata is a licensed software; however, as students of the University of Ottawa and Carleton University, you have free access through your respective institutions:

**University of Ottawa:**
[Download Stata here](https://fssapps.uottawa.ca/forms/StataSoftware/Information)

**Carleton University:**
[Download Stata here](https://carleton.ca/its/all-services/computers/site-licensed-software/)

### Downloading Files

1. Download the DO files and datasets from this repository located in `stata_tutorial_files`.
2. Save them in a folder named `stata_workshop`.

## Repository Contents

### DO Files

#### `Data Exploration.do`

This DO file covers the following topics:

- **Basic Commands:**
  - Clearing previous data
  - Setting global paths
  - Starting and closing log files

- **Data Preparation:**
  - Changing directory and loading datasets
  - Viewing and summarizing dataset structure
  - Generating detailed reports for variables
  - Displaying specific observations and generating summary statistics
  - Tabulating categorical variables and performing cross-tabulations
  - Comparing means and creating correlation matrices

- **Storing Results in Word:**
  - Saving summary statistics, frequency tabulations, and codebook information using the `asdoc` command

- **Graphical Analysis:**
  - Creating histograms and box plots
  - Generating scatter plots and saving them for later use

#### `Data Manipulation and Graphing Techniques.do`

This DO file includes:

- **Basic Data Exploration:**
  - Loading and describing datasets
  - Creating detailed reports using the `codebook` command

- **Data Manipulation:**
  - Renaming variables and reordering columns
  - Creating new variables, including dummy variables and interaction terms
  - Recoding variables into simpler categories
  - Defining and labeling categorical variables
  - Creating composite score variables based on multiple criteria

- **Graphing Techniques:**
  - Creating pie charts and bar graphs
  - Calculating percentages and generating stacked bar graphs
  - Creating panel datasets and reshaping data from wide to long format
  - Merging datasets and saving the final merged dataset

#### `Regressions and Post-estimations.do`

This DO file focuses on:

- **Cross-Sectional Data Analysis:**
  - Running basic regressions and reviewing diagnostic plots
  - Testing for heteroscedasticity and addressing it through various methods
  - Transforming dependent variables to stabilize variance

- **Panel Data Regression:**
  - Setting panel data structure and running fixed-effects and random-effects models
  - Performing the Hausman test to choose between fixed and random effects
  - Exporting regression results to Excel and LaTeX

- **Using Margins:**
  - Fitting regression models and using the `margins` command for interaction effects
  - Plotting predicted margins and interpreting the results

### Datasets

- `auto.dta`: Contains the 'auto' dataset used for exploratory data analysis.
- `GSS_2022.dta`: Used for data manipulation and graphing techniques.
- `municipalities.dta`: Used for creating panel datasets.
- `coca_crops_2001-2022.csv`: Contains coca crop cultivation data in Colombia.

## Instructions for Use

1. Open Stata and set the working directory to the location of the `stata_workshop` folder.
2. Run the DO files in sequential order:
   - `Data Exploration.do`
   - `Data Manipulation and Graphing Techniques.do`
   - `Regressions and Post-estimations.do`
3. Follow the comments and instructions within each DO file for detailed guidance on each step.
