## The following  script reads the data to be analyzed from the current working directory and 
 ## writes a tidy data set 
 

 ## First we need two load the following 2 packages that will be used for this assigment
 library(dplyr) 
 library(tidyr) 
 
 setwd("C:/Users/penajes2/Documents/UCI HAR Dataset")
 
 
 y_train <- read.table("train/y_train.txt", quote="\"")
 X_train <- read.table("train/X_train.txt", quote="\"")
 subject_train <- read.table("train/subject_train.txt", quote="\"")
 ysub_train <- cbind(subject_train, y_train) 
 

 
 X_test <- read.table("test/X_test.txt", quote="\"")
 y_test <- read.table("test/y_test.txt", quote="\"")
 subject_test <- read.table("test/subject_test.txt", quote="\"")
 ysub_test <- cbind(subject_test, y_test) 
 
 X <- rbind(X_train, X_test) 
 ysub <- rbind(ysub_train, ysub_test) 
 
 
 ## Convert to dplyr table format 
 X <- tbl_df(X) 
 ysub <- tbl_df(ysub) 
 
 
 
 features <- read.table("features.txt", quote="\"")
 features <- tbl_df(features) 
 alabel <- read.table("activity_labels.txt", quote="\"")
 names(alabel) <- c("activity_labels", "activity")  ##to give a  name to alabel columns


 ## split features to obtain the indices of the required measurement    separa cada actividad 
 featsep <- separate(features, V2, c("activity", "stat", "coord"), sep = "-",  
                        	extra ="merge") 
 

 ## Find the index that contains the information  
 featms <- filter(featsep, stat == "mean()"| stat == "std") 
 dindex <- featms$V1 
 

 ## Extract the information from the X data 
 Xsel <- select(X, dindex) 
 

 ## Name the Selected Data 
 names(Xsel) <- features$V2[dindex] 
 

 ## Name the subject id and activity label 
 names(ysub) <- c("subject_id", "activity_labels") 
 data <- cbind(ysub, Xsel) 
 

 ## Merge with alabel to replace activity_labels with activity 
 

 fdata <- 
     data %>%  
     merge(alabel) %>% 
     arrange(subject_id) %>% 
     mutate(activity_labels = activity) %>% 
     select(subject_id, activity_labels, 3:35, -activity) 
 oldname <- names(fdata) 
 oldname[2] <- "activity" 
 names(fdata) <- oldname 
 

 ## Write the "fdata" file in the working directory 
 write.table(fdata, file = "run_analysis.txt", row.name = FALSE) 
