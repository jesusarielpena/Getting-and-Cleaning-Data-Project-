## The following  script reads the data to be analyzed from the current working directory and 
 ## writes a tidy data set 
 

 ## First we need two load the following 2 packages that will be used for this assigment
 library(dplyr) 
 library(tidyr) 
 
 #set your working directory in the folder where you downloaded the data.
 setwd("C:/Users/penajes2/Documents/UCI HAR Dataset")
 
 ##start reading the different tables and named them accordingly.
 y_train <- read.table("train/y_train.txt", quote="\"")
 X_train <- read.table("train/X_train.txt", quote="\"")
 subject_train <- read.table("train/subject_train.txt", quote="\"")
 
 #cbind the subject_train table with y_train
 ysub_train <- cbind(subject_train, y_train) 
 

 #continue reading the next tables
 X_test <- read.table("test/X_test.txt", quote="\"")
 y_test <- read.table("test/y_test.txt", quote="\"")
 subject_test <- read.table("test/subject_test.txt", quote="\"")
 
 #cbind subject_test with y_test
 ysub_test <- cbind(subject_test, y_test) 
 
 
 X <- rbind(X_train, X_test) 
 ysub <- rbind(ysub_train, ysub_test) 
 

 ## Convert to tbl_Df
 X <- tbl_df(X) 
 ysub <- tbl_df(ysub) 
 
 
 features <- read.table("features.txt", quote="\"")
 features <- tbl_df(features) 
 characteristics <- read.table("activity_labels.txt", quote="\"")
 names(characteristics) <- c("activity_labels", "activity")  ##to give a  name to characteristics columns


 ## then we need to split the  features to obtain the indices  measurement  
 featsep <- separate(features, V2, c("activity", "stat", "coord"), sep = "-", 	extra ="merge") 
 
 ##   we need to find   index that contains the measurements of meand and standars deviation
 featms <- filter(featsep, stat == "mean()"| stat == "std") 
 dindex <- featms$V1 
 
 
 ## Extract the information from the X data 
 Xsel <- select(X, dindex) 
 

 ## give a name to the selected data
 names(Xsel) <- features$V2[dindex] 
 

 ## give a name to the subject id and activity label 
 names(ysub) <- c("subject_id", "activity_labels") 
 data <- cbind(ysub, Xsel) 
 

 ## Merge with characteristics to replace activity_labels with activity 
 
 fdata <- 
     data %>%  
     merge(characteristics) %>% 
     arrange(subject_id) %>% 
     mutate(activity_labels = activity) %>% 
     select(subject_id, activity_labels, 3:35, -activity) 
 oldname <- names(fdata) 
 oldname[2] <- "activity" 
 names(fdata) <- oldname 
 

 ## Finally write a Tidy data set in the working director in .txt file
 write.table(fdata, file = "tidy.txt", row.name = FALSE) 
