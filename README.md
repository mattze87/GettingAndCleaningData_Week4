GOAL OF THE R SCRIPT 
========================================================

Goal of the R script is to do the following. The script: 

1) merges the training and the test sets to create one data set.
2) extracts only the measurements on the mean and standard deviation for each measurement. 
3) uses descriptive activity names to name the activities in the data set
4) appropriately labels the data set with descriptive variable names. 
5) creates creates a second, independent tidy data set with the average of each variable for each activity and each subject.

All the described steps are written in one R script called run_analysis.R. 



RAW DATA USED
========================================================

For each record it is provided:
===============================
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The raw data used for this excercise are: 
=========================================
- x_test.txt: Test set 
- y_test.txt: Test labels
- subject_test.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- x_train.txt: Training set 
- y_train.txt: Training labels 
- subject_train.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- features.txt: List of all features 
- features_info.txt: Shows information about the variables used on the feature vector.

The column names of the x_test.txt/y_test.txt datasets are fully listed in features.txt. A description and derivation of the column names 
can be found in features_info.txt.

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.



PROGRAMMING STEPS
========================================================

The script run_analysis.R performs the following steps: 

1) At first, all required raw data are read in and saved in separate datasets. 

  	xtest <- read.table("X_test.txt")
  	ytest <- read.table("y_test.txt")
  	stest <- read.table("subject_test.txt")
  
  	xtrain <- read.table("X_train.txt")
  	ytrain <- read.table("y_train.txt")
  	strain <- read.table("subject_train.txt")
 
  	features <- read.table("features.txt")

The test and train data are then merged by first merging the columns of the test data (subject_test, y_test and x_test) and the train data 
(subject_train, y_train, x_train) separately and then combining the the merged datasets into one dataset (merged_data). 

  	test_merged <- cbind(stest,ytest,xtest) # extend test data by two columns indicating subject and activity
  	train_merged <- cbind(strain,ytrain,xtrain)
  
  	merged_data <- rbind(test_merged,train_merged) # merge test and train data 

2) Next, only those columns of the dataset merged_data are kept which contain the Means or Standard Deviations of measurements. Furthermore, for technical
reasons the first two columns have to be renamed. The outcome dataset is named selected_data.   

  	names(merged_data)[1] = "subject_id" # rename columns 
  	names(merged_data)[2] = "activity_name"
  
 	### select only columns with mean() and std() 
  
  	select_ms <-c(1,2,grep("mean()|std()",features$V2)+2) # keep column 1 and 2, therefore set grep index + 2 
  
  	selected_data <- merged_data[,select_ms]

3) The numeric values indicating the activity are now replaced with its String equivalent. 

 	selected_data$activity_name <-as.character(selected_data$activity_name) # change data type for activity_name to "character" in order to replace numeric values by its text equivalent  

  	for (i in 1:dim(selected_data)[1]) { # replace numeric values 
    		if (selected_data$activity_name[i] == "1") {selected_data$activity_name[i] <- "WALKING"} 
    		else if (selected_data$activity_name[i] == "2") {selected_data$activity_name[i] <- "WALKING_UPSTAIRS"} 
    		else if (selected_data$activity_name[i] == "3") {selected_data$activity_name[i] <- "WALKING_DOWNSTAIRS"} 
    		else if (selected_data$activity_name[i] == "4") {selected_data$activity_name[i] <- "SITTING"} 
    		else if (selected_data$activity_name[i] == "5") {selected_data$activity_name[i] <- "STANDING"} 
    		else  {selected_data$activity_name[i] <- "LAYING"}
  	} 

4) Until now the column names only contain numeric values. These are replaced with its description in the table features. Furthermore, the "t" and "f"
in the beginning of the descriptions are replaced with their longer form "time" and "frequency".  

	names(selected_data) <- sub("V","",names(selected_data)) # remove "V", necessary for looking up names in features table 
  
  	names(selected_data) = features$V2[match(names(selected_data),features$V1)] # find corresponding names in features table 
  
  	names(selected_data)[1] = "subject_id"
  	names(selected_data)[2] = "activity_name"
  
  	names(selected_data) <- sub("^t","time",names(selected_data)) # change t to time
  	names(selected_data) <- sub("^f","freq",names(selected_data)) # change f to freq

5) As a last step, an independent data set (final_data) is created contining the average of each variable for each activity and each subject. 
For technical reasons the first two column names have to be renamed. 

	final_data <- aggregate(selected_data[,3:dim(selected_data)[2]],list(selected_data$subject_id,selected_data$activity_name),mean)
  
  	names(final_data)[1] <- "subject_id" # rename group 1 (necessary because of aggregate function)
  	names(final_data)[2] <- "activity_name" # rename group 2 (necessary because of aggregate function)



FINAL DATASET
========================================================

The final data produced by the code has the following structure, where column 3-81 contain the average of the respective variable for the subject_id 
and activity_name which are numeric values in [-1,1] 

subject_id 
  	subject who performed the activity, values: 1-30
	
activity_name
	name of the activity the subject is performing, values: "WALKING", "WALKING UPSTAIRS", "WALKING DOWNSTAIRS", "SITTING", "STANDING"     
                                  
timeBodyAcc-mean()-X               
timeBodyAcc-mean()-Y              
timeBodyAcc-mean()-Z               
timeBodyAcc-std()-X                
timeBodyAcc-std()-Y                
timeBodyAcc-std()-Z             
timeGravityAcc-mean()-X            
timeGravityAcc-mean()-Y            
timeGravityAcc-mean()-Z            
timeGravityAcc-std()-X            
timeGravityAcc-std()-Y             
timeGravityAcc-std()-Z             
timeBodyAccJerk-mean()-X           
timeBodyAccJerk-mean()-Y          
timeBodyAccJerk-mean()-Z           
timeBodyAccJerk-std()-X            
timeBodyAccJerk-std()-Y            
timeBodyAccJerk-std()-Z           
timeBodyGyro-mean()-X              
timeBodyGyro-mean()-Y              
timeBodyGyro-mean()-Z              
timeBodyGyro-std()-X              
timeBodyGyro-std()-Y               
timeBodyGyro-std()-Z               
timeBodyGyroJerk-mean()-X
timeBodyGyroJerk-mean()-Y         
timeBodyGyroJerk-mean()-Z          
timeBodyGyroJerk-std()-X           
timeBodyGyroJerk-std()-Y           
timeBodyGyroJerk-std()-Z          
timeBodyAccMag-mean()
timeBodyAccMag-std()               
timeGravityAccMag-mean()           
timeGravityAccMag-std()           
timeBodyAccJerkMag-mean()          
timeBodyAccJerkMag-std()           
timeBodyGyroMag-mean()             
timeBodyGyroMag-std()             
timeBodyGyroJerkMag-mean()         
timeBodyGyroJerkMag-std()          
freqBodyAcc-mean()-X               
freqBodyAcc-mean()-Y              
freqBodyAcc-mean()-Z               
freqBodyAcc-std()-X                
freqBodyAcc-std()-Y                
freqBodyAcc-std()-Z               
freqBodyAcc-meanFreq()-X           
freqBodyAcc-meanFreq()-Y           
freqBodyAcc-meanFreq()-Z           
freqBodyAccJerk-mean()-X          
freqBodyAccJerk-mean()-Y           
freqBodyAccJerk-mean()-Z           
freqBodyAccJerk-std()-X            
freqBodyAccJerk-std()-Y
freqBodyAccJerk-std()-Z            
freqBodyAccJerk-meanFreq()-X       
freqBodyAccJerk-meanFreq()-Y       
freqBodyAccJerk-meanFreq()-Z      
freqBodyGyro-mean()-X              
freqBodyGyro-mean()-Y              
freqBodyGyro-mean()-Z              
freqBodyGyro-std()-X              
freqBodyGyro-std()-Y               
freqBodyGyro-std()-Z               
freqBodyGyro-meanFreq()-X          
freqBodyGyro-meanFreq()-Y         
freqBodyGyro-meanFreq()-Z          
freqBodyAccMag-mean()              
freqBodyAccMag-std()               
freqBodyAccMag-meanFreq()         
freqBodyBodyAccJerkMag-mean()      
freqBodyBodyAccJerkMag-std()       
freqBodyBodyAccJerkMag-meanFreq()  
freqBodyBodyGyroMag-mean()        
freqBodyBodyGyroMag-std()          
freqBodyBodyGyroMag-meanFreq()     
freqBodyBodyGyroJerkMag-mean()     
freqBodyBodyGyroJerkMag-std()     
freqBodyBodyGyroJerkMag-meanFreq()