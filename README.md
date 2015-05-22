# getdata-PA1

####Project Details

The course project for the Getting and Cleaning course by JHU. The ReadME file explains the steps in the 
R file "run_analysis.R".The purpose of this project is to collect, work with,and clean a data set. The goal
is to prepare tidy data that can be used for later analysis. 

The data used for the project is collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the [site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 
where the data was obtained.

The R script contains code for downloading the dataset from the required URL or an alternative would be to 
download this repository which contains the dataset. Either ways, it is assumed that the working directory
is set to the top level folder containing the R code.

####Details about run_analysis.R

Initially, the names of all the files from the zip are loaded into a character vector "names" which is 
then looped through to extract the training and the test set along with their respective activity and subject
tables. These files' variable names are then renamed appropriately to increase readability. The variable
names for test and training set are extracted from the "features.txt" file. The other two files' variables are
renamed to subject_id (for dataframe containing subject identifier) and activity_id (for dataframe containing
activity identifier). Finally, the 3 files containing data about the training set(features,subject_id,
activity_id) are combined in the features table (file_31). This is done for the test set as well(file_17).
The files are copied to dataframes with more readable names, ie, trainset and testset. These 2 tables now
have for each subject and an activity, a list of various measurements (called features) over a particular
window. 

It is observed that the new training set (trainset)'s and the test set (testset)'s variable names do not
comply with valid R column names (presence of hyphens is not allowed) and hence are forced to valid names using
 "make.names" function. The new names are updated in the dataset. Next, the tables' are subset to include 
 only the columns which are containing mean or standard deviation of the basic measurements (taken from 
 accelerometer and gyroscope). This is done using the "matches" function on the variable names. The 2 datasets
 are now combined into a master dataset called mastertable which is sorted according to subject_id. 
 The activity_id column is updated such that it contains the activity name(refer activity_labels.txt) using ifelse
 and the variable name is changed to activity to reflect so. Lastly, the master table is 
collapsed by grouping first by subject_id and then by activity to give the mean of the features. This is done
using ddply function from plyr package. numwise function is used to ensure that all numeric columns are averaged
separately.

This new dataframe is stored as tidy and the output as "tidydata.txt" using write.table function.



