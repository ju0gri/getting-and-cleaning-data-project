# getting-and-cleaning-data-project

This is the implementation of the project requirement for the Getting and Cleaning Data course on Coursera according to the requirements stated here:

## Project description
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Implementation plan

* downloads the original dataset if not already downloaded
* unzips original dataset if not already unzipped
* reads test and train sets and rbind them
* reads test and train labels and rbind them
* reads activity labels
* reads test and train subjects and rbind them
* reads features set
* merges sets, labels and subjects into one table
* merges the resulting table with the features table by feature number
* merges the resulting table with the activity labels table
* melts the table
* merges with features table
* creates factors for each feature with 1, 2 and 3 characteristics
* save the resulting table into a file

The resulting tidy dataset is available in this repository and its structure is described in the Codebook file.
