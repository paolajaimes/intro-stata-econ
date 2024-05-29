* Do file for Stata Workshop
* Exploratory Data Analysis with the 'auto' dataset
* Author: Paola Jaimes Santamaria
* Date: June 4, 2024

								/********** The Basics **********/

* Clear previous data from memory
clear all

* Set the global path for the data and log files
global path_data "/Users/paolajaimes/Library/CloudStorage/OneDrive-UniversityofOttawa/Stata workshop"

* Start logging the session to record all commands and outputs
log using "$path_data/exploring_data.log", replace

* Start the log file in plain text format
* log using "$path_data/exploring_data.txt", text replace

* Change directory to the specified path and open the 'auto' dataset
cd "$path_data"
use auto, clear

* View the structure and summary of each variable in the dataset
describe

* Create a detailed report for all variables with the 'codebook' command
codebook 

* Close the log file (I can do this anytime)
log close

* Display the first ten observations in the dataset
list in 1/10

* Get basic summary statistics for all variables
summarize

* Generate detailed summary statistics for the 'price' variable
summarize price, detail

* Tabulate the 'foreign' variable to see the frequency of domestic vs. foreign cars
tabulate foreign

* Cross-tabulation of repair record and car origin
tabulate rep78 foreign, chi2

* Comparison of average prices between domestic and foreign cars
by foreign: summarize price

* Produce a correlation matrix for selected variables
correlate price mpg weight length

								/********** Storing in Word **********/

* Store results in a Word document using the 'asdoc' command
* Make sure to install 'asdoc' before using these commands

* Store the basic summary statistics in 'MySummary.doc'
asdoc summarize, save(MySummary.doc) replace

* Append the frequency tabulation of 'foreign' variable to the Word document
asdoc tabulate foreign, save(MySummary.doc) append

* Append the codebook information of 'price' to the Word document
asdoc codebook price, append

								/********** Some Graphs **********/
								
* Visualize the data with graphs to better understand the distribution of variables

* Create and display a histogram of car prices showing the density distribution
histogram price, title("Histogram of Car Prices")

* Create and display a histogram of car prices with frequency count and set bin size to 10
histogram price, frequency bin(10) title("Histogram of Car Prices with Frequencies")

* Create and display a histogram with customized frequency intervals
histogram price, frequency bin(9) ylabel(0(5)30) ytitle("Frequency") title("Histogram of Car Prices with Frequencies")

* Generate a box plot comparing the distribution of prices by car origin
graph box price, over(foreign) title("Box Plot of Prices by Car Origin")

* Insight from the box plot
* The median price for domestic cars is lower than for foreign cars.
* There is more variability in the price of domestic cars compared to foreign cars.
* There are outliers indicating some domestic cars are priced significantly higher than the typical range.

* Create and display a scatter plot to explore the relationship between price and miles per gallon (mpg)
scatter price mpg, title("Scatter Plot of Price vs. MPG")

* Save the scatter plot as a file for later use
graph save price_vs_mpg, replace
