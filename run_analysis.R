## This script reads the data to be analyzed from the working directory  
 	##and write the final tidy data into the data folder 
 

 ## Load needed packages 
 library(dplyr) 
 library(tidyr) 
 
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 ## Find working directory and read in files 
 wd <- getwd() 
 wd <- paste(wd, "getdata-projectfiles-UCI HAR Dataset\UCI HAR Dataset", 
                	sep="") 
 

 ## Read train data 
 fwd <- paste(wd,"/train/",sep="") 
 setwd(fwd) 
 
 
 
 ##setwd("C:/Users/penajes2/Documents/UCI HAR Dataset")
 
 
 X_train <- read.table("X_train.txt") 
 y_train <- read.table("y_train.txt") 
 subject_train <- read.table("subject_train.txt") 
 ysub_train <- cbind(subject_train, y_train) 
 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

 
 
 ------------------------------------------------
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
------------------------------------------------------- 

   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
 ## Read test data 
 fwd <- paste(wd,"/test/",sep="") 
 setwd(fwd) 
 X_test <- read.table("X_test.txt") 
 y_test <- read.table("y_test.txt") 
 subject_test <- read.table("subject_test.txt") 
 ysub_test <- cbind(subject_test, y_test) 
 
 ## Combine X test/train 
 X <- rbind(X_train, X_test) 
 ysub <- rbind(ysub_train, ysub_test) 
 

 ## Convert to dplyr table format 
 X <- tbl_df(X) 
 ysub <- tbl_df(ysub) 
 

 ## Read-in the "feature.txt" and "activity_labels.txt" files  
 setwd(wd) 
 features <- read.table("features.txt") 
 features <- tbl_df(features) 
 alabel <- read.table("activity_labels.txt") 
 names(alabel) <- c("activity_labels", "activity") 
 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

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
