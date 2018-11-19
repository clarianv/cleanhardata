### Introduction
Use the run_analysis.R to process the input data


##  Steps for run_analysis
# 1. Read and Tidy the HAR Data (readAndTidyHarData)
1.a. get the activity labels
```R
  activity_labels <- read.delim("./data/ucihar/activity_labels.txt", header = FALSE, sep = " ")
  names(activity_labels) <- c("id","activity")
```

1.b. get the feature labels

# 2. Summarise HAR Data (summariseHarData)




This script reads and processes the data, as follows:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity (e.g. walking, sitting) and each subject (or the person who did the experiment).


## Expected Output

# harData.txt
The tidy data set from steps 1-4 of the script written on a text file.

# avgHarData.txt
The averages of the data set per measure grouped by subject and activity.


