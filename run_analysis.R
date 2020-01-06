run_analysis <- function() {
  
  ############################################################################################################
  ########## READ IN DATA ####################################################################################
  ############################################################################################################

  xtest <- read.table("X_test.txt")
  ytest <- read.table("y_test.txt")
  stest <- read.table("subject_test.txt")
  
  xtrain <- read.table("X_train.txt")
  ytrain <- read.table("y_train.txt")
  strain <- read.table("subject_train.txt")
 
  features <- read.table("features.txt")
  
  ############################################################################################################
  ##########  MERGE DATA AND SELECT ONLY SPECIFIC COLUMNS #################################################### 
  ############################################################################################################
  
  test_merged <- cbind(stest,ytest,xtest) # extend test data by two columns indicating subject and activity
  train_merged <- cbind(strain,ytrain,xtrain)
  
  merged_data <- rbind(test_merged,train_merged) # merge test and train data 
  
  names(merged_data)[1] = "subject_id" # rename columns 
  names(merged_data)[2] = "activity_name"
  
  ### select only columns with mean() and std() 
  
  select_ms <-c(1,2,grep("mean()|std()",features$V2)+2) # keep column 1 and 2, therefore set grep index + 2 
  
  selected_data <- merged_data[,select_ms]
  
  
  ############################################################################################################
  ########## REPLACE ACTIVITY_ID BY ACTIVITY_NAME ############################################################
  ############################################################################################################
  
  selected_data$activity_name <-as.character(selected_data$activity_name) # change data type for activity_name to "character" in order to replace numeric values by its text equivalent  

  for (i in 1:dim(selected_data)[1]) { # replace numeric values 
    if (selected_data$activity_name[i] == "1") {selected_data$activity_name[i] <- "WALKING"} 
    else if (selected_data$activity_name[i] == "2") {selected_data$activity_name[i] <- "WALKING_UPSTAIRS"} 
    else if (selected_data$activity_name[i] == "3") {selected_data$activity_name[i] <- "WALKING_DOWNSTAIRS"} 
    else if (selected_data$activity_name[i] == "4") {selected_data$activity_name[i] <- "SITTING"} 
    else if (selected_data$activity_name[i] == "5") {selected_data$activity_name[i] <- "STANDING"} 
    else  {selected_data$activity_name[i] <- "LAYING"}
  }
  
  
  ############################################################################################################
  ########## LABEL DATA SET WITH DESCRIPTIVE VARIABLE NAMES ##################################################
  ############################################################################################################
  
  names(selected_data) <- sub("V","",names(selected_data)) # remove "V", necessary for looking up names in features table 
  
  names(selected_data) = features$V2[match(names(selected_data),features$V1)] # find corresponding names in features table 
  
  names(selected_data)[1] = "subject_id"
  names(selected_data)[2] = "activity_name"
  
  names(selected_data) <- sub("^t","time",names(selected_data)) # change t to time
  names(selected_data) <- sub("^f","freq",names(selected_data)) # change f to freq
  
  
  ############################################################################################################
  ########## CREATE INDEPENDENT DATA SET WITH AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND SUBJECT #########
  ############################################################################################################
  
  final_data <- aggregate(selected_data[,3:dim(selected_data)[2]],list(selected_data$subject_id,selected_data$activity_name),mean)
  
  names(final_data)[1] <- "subject_id" # rename group 1 (necessary because of aggregate function)
  names(final_data)[2] <- "activity_name" # rename group 2 (necessary because of aggregate function)
  
  return(final_data)
  
}