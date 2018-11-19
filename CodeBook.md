# Introduction
The run_analysis.R script reads and processes the data, as follows:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity (e.g. walking, sitting) and each subject (or the person who did the experiment).

#  Steps for run_analysis

### A. Read and Tidy the HAR Data (readAndTidyHarData)
```R
  harData <- readAndTidyHarData()
```
(see details below)

### B. Summarise HAR Data (summariseHarData)
```R
  avgHarData <- data %>% 
                    group_by(subject, activity) %>% 
                      summarise_all(funs(mean))
```

### C. Export the tidy & analyses data into text files
```R
  write.table(harData, file = "./data/harData.txt",  row.name=FALSE, sep = ",")
  write.table(avgHarData, file = "./data/avgHarData.txt", row.name=FALSE, sep = ",")
```
---
### Steps for A: readAndTidyHarData()
#### A.1. get the activity labels
```R
  #e.g. 1:WALKING, 4:SITTING
  activity_labels <- read.delim("./data/ucihar/activity_labels.txt", header = FALSE, sep = " ")
  names(activity_labels) <- c("id","activity")
```

#### A.2. get the feature labels
```R
  "tBodyAcc-mean()-X","tBodyAcc-mean()-Y"
  all_feature_names <- read.delim("./data/ucihar/features.txt", header = FALSE, sep = " ")
  names(all_feature_names) <- c("id","name")
  feature_names <- all_feature_names[grep(".*(mean|std)\\(.*", all_feature_names$name),]
  
  #rename feature names into understandable names
  feature_names$name<-gsub("std()", "SD", feature_names$name)
  feature_names$name<-gsub("mean()", "MEAN", feature_names$name)
  feature_names$name<-gsub("^t", "time", feature_names$name)
  feature_names$name<-gsub("^f", "frequency", feature_names$name)
  feature_names$name<-gsub("Acc", "Accelerometer", feature_names$name)
  feature_names$name<-gsub("Gyro", "Gyroscope", feature_names$name)
  feature_names$name<-gsub("Mag", "Magnitude", feature_names$name)
  feature_names$name<-gsub("BodyBody", "Body", feature_names$name)
```

#### A.3. get the data, and apply the activity and feature labels (getDataFromFolder)
```R
  test <- getDataFromFolder("test", activity_labels, feature_names)
  train <- getDataFromFolder("train", activity_labels, feature_names)
```
(see details below)

#### A.4. combine the two data frames into one
```R
  final_data <- rbind(test, train)
```
---
#### Steps for A.3: getDataFromFolder()
##### A.3.i. get the subject labels
```R
  # 1) get the subjects
  # e.g. "./data/ucihar/test/subject_test.txt"
  subject <- read.csv(paste("./data/ucihar/",type,"/subject_",type,".txt", sep = ""), header = FALSE)
  names(subject) <- c("subject")
```
##### A.3.ii. get the activities, and apply the appropriate label
```R
  # 2) get the activities done by the subjects; add the label "WALKING" or "LAYING"
  # e.g. "./data/ucihar/test/y_test.txt"
  activity_row <- read.csv(paste("./data/ucihar/",type,"/y_",type,".txt", sep = ""), header = FALSE)
  names(activity_row) <- c("id")
  activity <- merge(activity_row, activity_labels, by.x="id", by.y="id")
```
##### A.3.iii. get the data needed: means & sds of the measurements.
```R
  # 3) get the measurements of the activities done by the subjects
  # e.g. "./data/ucihar/test/X_test.txt"
  colwidths <- rep(16,561) #561 columns, 16 characters each column
  set <- read.fwf(paste("./data/ucihar/",type,"/X_",type,".txt", sep = ""), header = FALSE, fill = TRUE, widths = colwidths)
  
  # 3.b) filter the set, only get the mean & std measurements
  features <- set[, feature_names$id]
  names(features) <- feature_names$name
```
at this point the features to be selected are filtered already

##### A.3.iv. combine the subject, activity, and data columns
```R
  # 4.) combine all data into one data frame: subject, activity, data set
  data <- cbind(subject, as.character(activity$activity), features)
  colnames(data)[2] <- "activity" #rename column
```





## Expected Output

### harData.txt
The tidy data set from steps 1-4 of the script written on a text file.

### avgHarData.txt
The averages of the data set per measure grouped by subject and activity.


