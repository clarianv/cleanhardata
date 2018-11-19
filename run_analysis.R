
#run_analysis()

################################################################################################################
# This function summarises the dataframe by grouping into each subject and each activity, 
# then getting the mean from the measurements, and finally returns the summarised dataframe.
################################################################################################################
run_analysis <- function()
{
  #1.) Prepare the tidy data
  harData <- readAndTidyHarData()
  
  #2.) summarise with a mean
  avgHarData <- summariseHarData(harData)
  
  #3.) Export the tidy & analyses data into text files
  write.table(harData, file = "./data/harData.txt",  row.name=FALSE, sep = ",")
  write.table(avgHarData, file = "./data/avgHarData.txt", row.name=FALSE, sep = ",")
  
  harData
}


################################################################################################################
# This function summarises the dataframe by grouping into each subject and each activity, 
# then getting the mean from the measurements, and finally returns the summarised dataframe.
################################################################################################################
summariseHarData <- function(data)
{
  #1.) Group by the subject and activity, then summarise with the mean
  data %>% 
    group_by(subject, activity) %>% 
      summarise_all(funs(mean))
}



################################################################################################################
# This function reads the activity and feature labels, then the actual data, then puts them all together 
# in one data frame
################################################################################################################
readAndTidyHarData <- function()
{
  library(tidyr)
  library(dbplyr)
  library(dplyr)
  
  #1.) get the activity labels
  #e.g. 1:WALKING, 4:SITTING
  activity_labels <- read.delim("./data/ucihar/activity_labels.txt", header = FALSE, sep = " ")
  names(activity_labels) <- c("id","activity")
  
  #2.) get the feature labels
  #e.g. "tBodyAcc-mean()-X","tBodyAcc-mean()-Y"
  all_feature_names <- read.delim("./data/ucihar/features.txt", header = FALSE, sep = " ")
  names(all_feature_names) <- c("id","name")
  feature_names <- all_feature_names[grep(".*(mean|std)\\(.*", all_feature_names$name),]
  #2.b) rename feature names into understandable names
  feature_names$name<-gsub("std()", "SD", feature_names$name)
  feature_names$name<-gsub("mean()", "MEAN", feature_names$name)
  feature_names$name<-gsub("^t", "time", feature_names$name)
  feature_names$name<-gsub("^f", "frequency", feature_names$name)
  feature_names$name<-gsub("Acc", "Accelerometer", feature_names$name)
  feature_names$name<-gsub("Gyro", "Gyroscope", feature_names$name)
  feature_names$name<-gsub("Mag", "Magnitude", feature_names$name)
  feature_names$name<-gsub("BodyBody", "Body", feature_names$name)
  
  
  #3.) get the data; use the activity and feature labels
  test <- getDataFromFolder("test", activity_labels, feature_names)
  train <- getDataFromFolder("train", activity_labels, feature_names)
  
  #4.) put the two data frames into one
  final_data <- rbind(test, train)
  final_data
}

################################################################################################################
# This function reads either the train or test data, and put them into a dataframe
################################################################################################################
getDataFromFolder <- function(type, activity_labels, feature_names)
{
  # 1) get the subjects
  # e.g. "./data/ucihar/test/subject_test.txt"
  subject <- read.csv(paste("./data/ucihar/",type,"/subject_",type,".txt", sep = ""), header = FALSE)
  names(subject) <- c("subject")
  
  # 2) get the activities done by the subjects; add the label "WALKING" or "LAYING"
  # e.g. "./data/ucihar/test/y_test.txt"
  activity_row <- read.csv(paste("./data/ucihar/",type,"/y_",type,".txt", sep = ""), header = FALSE)
  names(activity_row) <- c("id")
  activity <- merge(activity_row, activity_labels, by.x="id", by.y="id")
  
  # 3) get the measurements of the activities done by the subjects
  # e.g. "./data/ucihar/test/X_test.txt"
  colwidths <- rep(16,561) #561 columns, 16 characters each column
  set <- read.fwf(paste("./data/ucihar/",type,"/X_",type,".txt", sep = ""), header = FALSE, fill = TRUE, widths = colwidths)
  
  # 3.b) filter the set, only get the mean & std measurements
  features <- set[, feature_names$id]
  names(features) <- feature_names$name
  
  # 4.) combine all data into one data frame: subject, activity, data set
  data <- cbind(subject, as.character(activity$activity), features)
  colnames(data)[2] <- "activity" #rename column
  
  data
}
