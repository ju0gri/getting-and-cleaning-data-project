# CodeBook

This document describes the code inside run_analysis.r.

The purpose of the script is to collect, work with, and clean this data set https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. 
The resulting data set is stored in this repository under TidyDataset.txt and is described below:

## Implementation

* download the original dataset if not already downloaded
* unzip original dataset if not already unzipped
* read test and train sets and rbind them
* read test and train labels and rbind them
* read activity labels
* read test and train subjects and rbind them
* read features set
* merge sets, labels and subjects into one table
* merge the resulting table with the features table by feature number
* merge the resulting table with the activity labels table
* melt the table
* merge with features table
* create factors for each feature with 1, 2 and 3 characteristics
* save the resulting table into a file

## Tidy data set

### Description
Dataset contains:	2310 obs. of  11 variables:

 * subject     : Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
 * activity    : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
 * timefreq    : Factor w/ 2 levels "time","freq": 1 1 1 1 1 1 1 1 1 1 ...
 * acceleration: Factor w/ 3 levels NA,"body","gravity": 1 1 1 1 1 1 1 1 1 1 ...
 * instrument  : Factor w/ 2 levels "accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
 * jerk        : Factor w/ 2 levels NA,"jerk": 1 1 1 1 1 1 1 1 2 2 ...
 * magnitude   : Factor w/ 2 levels NA,"magnitude": 1 1 1 1 1 1 2 2 1 1 ...
 * variable    : Factor w/ 2 levels "mean","std": 1 1 1 2 2 2 1 2 1 1 ...
 * axis        : Factor w/ 4 levels NA,"X","Y","Z": 2 3 4 2 3 4 1 1 2 3 ...
 * count       : int  347 347 347 347 347 347 347 347 347 347 ...
 * average     : num  -0.0113 -0.0874 0.155 -0.9546 -0.9598 ...


### Dataset summary
 | subject | activity | timefreq | acceleration | instrument | jerk | magnitude | variable | axis | count | average |
 | ------- |:---------|:---------|:-------------|:-----------|:-----|:----------|:---------|:-----|:-----:| -------:|
 | 11     : 132 | LAYING            :462 | time:1400    | NA     : 910    | accelerometer:1400    | NA  :1400    | NA  :1680    | mean:1155    | NA:630    | Min.   :  3.0    | Min.   :-0.9941 |
 | 12     : 132 | SITTING           :396    | freq: 910    | body   :1120    | gyroscope    : 910    | jerk: 910    | magnitude: 630    | std :1155    | X :560    | 1st Qu.:276.0    | 1st Qu.:-0.9632 |
 | 19     : 132 | STANDING          :396    || gravity: 280   ||||| Y :560    | Median :323.0    | Median :-0.4623  |
 | 26     : 132 | WALKING           :330 ||||||| Z :560    | Mean   :294.3    | Mean   :-0.5084  |
 | 30     : 132 | WALKING_DOWNSTAIRS:396 |||||||| 3rd Qu.:366.0    | 3rd Qu.:-0.1038 |
 | 1      :  66 | WALKING_UPSTAIRS  :330 |||||||| Max.   :409.0    | Max.   : 0.9620 | 
 
 ### Dataset features combinations
 
 | timefreq | | instrument |jerk |magnitude|variable|axis| N|
 | -------- |:-----------|:----|:--------|:-------|:---|:-:|
|     time |  |   gyroscope |   NA |        NA |     mean |    X |  35 |
 |     time |     gyroscope |   NA |        NA |     mean |    Y |  35 |
 |     time |     gyroscope |   NA |        NA |     mean |    Z |  35 |
 |     time |     gyroscope |   NA |        NA |      std |    X |  35 | 
 |     time |     gyroscope |   NA |        NA |      std |    Y |  35 |
 |     time |     gyroscope |   NA |        NA |      std |    Z |  35 |
 |     time |     gyroscope |   NA | magnitude |     mean |   NA | 35 |
  |      time |     gyroscope |   NA | magnitude |      std |   NA | 35|
  |      time |     gyroscope | jerk |        NA |     mean |    X |  35|
 |      time |     gyroscope | jerk |        NA |     mean |    Y |  35|
 |      time |     gyroscope | jerk |        NA |     mean |    Z |  35|
 |      time |     gyroscope | jerk |        NA |      std |    X |  35|
 |      time |     gyroscope | jerk |        NA |      std |    Y |  35|
 |      time |     gyroscope | jerk |        NA |      std |    Z |  35|
 |      time |     gyroscope | jerk | magnitude |     mean |   NA | 35|
 |      time |     gyroscope | jerk | magnitude |      std |   NA | 35 | 
 |      time | accelerometer |   NA |        NA |     mean |    X |  70 | 
 |      time | accelerometer |   NA |        NA |     mean |    Y |  70 | 
 |      time | accelerometer |   NA |        NA |     mean |    Z |  70 | 
 |      time | accelerometer |   NA |        NA |      std |    X |  70 | 
 |      time | accelerometer |   NA |        NA |      std |    Y |  70 | 
 |      time | accelerometer |   NA |        NA |      std |    Z |  70 | 
 |      time | accelerometer |   NA | magnitude |     mean |   NA | 70 | 
 |      time | accelerometer |   NA | magnitude |      std |   NA | 70 | 
 |      time | accelerometer | jerk |        NA |     mean |    X |  35 | 
 |      time | accelerometer | jerk |        NA |     mean |    Y |  35 | 
 |      time | accelerometer | jerk |        NA |     mean |    Z |  35 | 
 |      time | accelerometer | jerk |        NA |      std |    X |  35 | 
 |      time | accelerometer | jerk |        NA |      std |    Y |  35 | 
 |      time | accelerometer | jerk |        NA |      std |    Z |  35 | 
 |      time | accelerometer | jerk | magnitude |     mean |   NA | 35 | 
 |      time | accelerometer | jerk | magnitude |      std |   NA | 35 | 
 |      freq |     gyroscope |   NA |        NA |     mean |    X |  35 | 
 |      freq |     gyroscope |   NA |        NA |     mean |    Y |  35 | 
 |      freq |     gyroscope |   NA |        NA |     mean |    Z |  35 | 
 |      freq |     gyroscope |   NA |        NA |      std |    X |  35 | 
 |      freq |     gyroscope |   NA |        NA |      std |    Y |  35 | 
 |      freq |     gyroscope |   NA |        NA |      std |    Z |  35 | 
 |      freq |     gyroscope |   NA | magnitude |     mean |   NA | 35 | 
 |      freq |     gyroscope |   NA | magnitude |      std |   NA | 35 | 
 |      freq |     gyroscope | jerk | magnitude |     mean |   NA | 35 | 
 |      freq |     gyroscope | jerk | magnitude |      std |   NA | 35 | 
 |      freq | accelerometer |   NA |        NA |     mean |    X |  35 | 
 |      freq | accelerometer |   NA |        NA |     mean |    Y |  35 | 
 |      freq | accelerometer |   NA |        NA |     mean |    Z |  35 | 
 |      freq | accelerometer |   NA |        NA |      std |    X |  35 | 
 |      freq | accelerometer |   NA |        NA |      std |    Y |  35 | 
 |      freq | accelerometer |   NA |        NA |      std |    Z |  35 | 
 |      freq | accelerometer |   NA | magnitude |     mean |   NA | 35 | 
 |      freq | accelerometer |   NA | magnitude |      std |   NA | 35 | 
 |      freq | accelerometer | jerk |        NA |     mean |    X |  35 | 
 |      freq | accelerometer | jerk |        NA |     mean |    Y |  35 | 
 |      freq | accelerometer | jerk |        NA |     mean |    Z |  35 | 
 |      freq | accelerometer | jerk |        NA |      std |    X |  35 | 
 |      freq | accelerometer | jerk |        NA |      std |    Y |  35 | 
 |      freq | accelerometer | jerk |        NA |      std |    Z |  35 | 
 |      freq | accelerometer | jerk | magnitude |     mean |   NA | 35 | 
 |      freq | accelerometer | jerk | magnitude |      std |   NA | 35 |
