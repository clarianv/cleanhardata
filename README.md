# Introduction

The data from Center for Machine Learning and Intelligent System represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

This project aims to put together this Human Activity Recognition data into one tidy data set ready for analysis.


## What's included this package
```
|   run_analysis.R
|
\---data
    |
    \---ucihar
        |   README.txt
```
But when the input data set from the site above is downloaded, the file structure should look like this
```
|   run_analysis.R
|
\---data
    |
    \---ucihar
        |   activity_labels.txt
        |   features.txt
        |   features_info.txt
        |   README.txt
        |
        +---test
        |   |   subject_test.txt
        |   |   X_test.txt
        |   |   y_test.txt
        |
        \---train
            |   subject_train.txt
            |   X_train.txt
            |   y_train.txt
```
### run_analysis.R
This script reads and processes the data, as follows:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity (e.g. walking, sitting) and each subject (or the person who did the experiment).

## Input
The files in the "ucihar" folder


## Expected Output
```
\---data
    |   avgHarData.txt
    |   harData.txt
```
### harData.txt
The tidy data set from steps 1-4 of the script written on a text file.

### avgHarData.txt
The averages of the data set per measure grouped by subject and activity.
	
## How to use
run_analysis()
