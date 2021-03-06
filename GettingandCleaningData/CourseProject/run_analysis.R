############################################### QUICK README #######################################################
#                                                                                                                  #
# @author: Dipanjan Sarkar                                                                                         #
#                                                                                                                  #  
# This script works on the UCI HAR Dataset and produces two tidy data sets as a part of                            #  
# the requirements for the course project of "Getting and Cleaning Data" of the JHU Data                           #
# Science Specialization track.                                                                                    #  
#                                                                                                                  #
# Important Instructions: Please place this file inside the UCI HAR Dataset folder after extracting it             #    
# ----------------------- from the zip file with the link provided in the Coursera page or you can go              #  
# here and download it from the following link given below.                                                        #
# [ https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ]                       #
#                                                                                                                  #  
# The final folder structure should be as follows.                                                                 #
#                                                                                                                  #    
#   UCI HAR Dataset                                                                                                #
#   |                                                                                                              #
#   |---------- activity_labels.txt                                                                                #
#   |---------- features.txt                                                                                       #
#   |---------- features_info.txt                                                                                  #
#   |---------- README.txt                                                                                         #
#   |---------- run_analysis.R                                                                                     #
#   |                                                                                                              #
#   |---------- test                                                                                               #
#   |             |---------- Inertial Signals                                                                     #  
#   |             |               |---------- Other Files...                                                       #
#   |             |                                                                                                #
#   |             |---------- X_test.txt                                                                           #
#   |             |---------- y_test.txt                                                                           #
#   |             |---------- subject_test.txt                                                                     #
#   |                                                                                                              #  
#   |---------- train                                                                                              #    
#   |             |---------- Inertial Signals                                                                     #
#   |             |               |---------- Other Files...                                                       #
#   |             |                                                                                                #
#   |             |---------- X_train.txt                                                                          #  
#   |             |---------- y_train.txt                                                                          #
#   |             |---------- subject_train.txt                                                                    #
#                                                                                                                  #
#                                                                                                                  #
#   1. If you open this file in RStudio please remember to execute the following commands in the                   #
#      R console below to run this script                                                                          #
#        >  setwd("Drive name:/Path_to_your_directory/UCI HAR Dataset")                                            #
#        >  source("run_analysis.R",chdir=TRUE)                                                                    #
#                                                                                                                  #
#                                                                                                                  #
#   2. Else if executing script from the terminal, go to the UCI HAR Dataset directory using cd                    #    
#      command and execute the following command from the terminal                                                 #
#      bash$  Rscript run_analysis.R                                                                               #
#                                                                                                                  #  
#   NOTE: You need to use any one of the above methods to execute the script and the output tidy data              #
#         will be created in the UCI HAR Dataset directory itself.                                                 #
#                                                                                                                  #
#   Output:                                                                                                        #
#   -------                                                                                                        #
#   1st dataset - clean_data.csv \ clean_data.txt [ contains features which are only mean and std ]                #
#   2nd dataset - tidy_data.csv \ tidy_data.txt   [ contains avg of mean & std features per person per activity ]  #
#                                                                                                                  #
####################################################################################################################



dirPath <- getwd()

cat("\n\n\t\t=========================== Running Script Please Wait ===========================\n\n")

# Reading the feature data from necessary files
cat("\t\t\t\t\t> Reading Feature Data from files...\n")
xTrain <- read.table(paste(dirPath, "./train/X_train.txt", sep=""))
xTest <- read.table(paste(dirPath, "./test/X_test.txt", sep=""))
featureData <- rbind(xTrain, xTest)     # combining train and test data into one data frame

# Reading the activity identifiers from necessary files
cat("\t\t\t\t\t> Reading Activity Label Data from files...\n")
yTrain <- read.table(paste(dirPath, "./train/y_train.txt", sep=""))
yTest <- read.table(paste(dirPath, "./test/y_test.txt", sep=""))
activityLabels <- rbind(yTrain, yTest)  # combining train and test data into one data frame
names(activityLabels) <- "activityid"   # giving a proper name to the variable

# Reading the subject identifiers from necessary files
cat("\t\t\t\t\t> Reading Subject Id Data from files...\n")
sTrain <- read.table(paste(dirPath, "./train/subject_train.txt", sep=""))
sTest <- read.table(paste(dirPath, "./test/subject_test.txt", sep=""))
subjectLabels <- rbind(sTrain, sTest)   # combining train and test data into one data frame
names(subjectLabels) <- "subjectid"     # giving a proper name to the variable

# Reading the feature names from necessary files
cat("\t\t\t\t\t> Reading Feature Names from file...\n")
featureNames <- read.table(paste(dirPath, "./features.txt", sep=""));
featureNames <- featureNames[,2]   # getting only the names

# Getting required feature subset from original feature set
cat("\t\t\t\t\t> Getting required feature subset...\n")
reqdfeatureIndices <- grep("-mean\\(\\)|-std\\(\\)", featureNames)  # getting only variables with mean() and std() in them
featureData <- featureData[,reqdfeatureIndices]
names(featureData) <- featureNames[reqdfeatureIndices]
# Transforming variable names to follow conventions
names(featureData) <- gsub("\\(|\\)", "", names(featureData)) 
names(featureData) <- tolower(names(featureData))

# Getting the activity names 
cat("\t\t\t\t\t> Reading Activity Names from file...\n")
activityNames <- read.table(paste(dirPath, "./activity_labels.txt", sep="")); 
activityNames[, 2] <- gsub("_", "", tolower(as.character(activityNames[, 2])))

# Transforming activity identifiers into names
cat("\t\t\t\t\t> Transforming Activity IDs to  Activity Names...\n")
activityData <- data.frame(activityname=activityNames[activityLabels[,],2])

# Combining all the data frames into one single data frame
cat("\t\t\t\t\t> Combining all data frames...\n")
cleanData <- cbind(subjectLabels,activityData,featureData)

# Writing our first tidy dataset into files
cat("\t\t\t\t\t> Writing 1st clean dataset to file...\n")
write.csv(cleanData,"clean_data.csv",row.names=FALSE)
write.table(cleanData,"clean_data.txt",sep="\t",row.names=FALSE)
cat("\t\t\t\t\t> Write complete...\n")

# loading the `reshape2` package
cat("\t\t\t\t\t> Loading required packages...\n")
if (!is.element("reshape2", installed.packages()[,1])){
  install.packages("reshape2")
} else{
  library(reshape2)
}

# Setting the required identifier and measure variables
cat("\t\t\t\t\t> Setting up ID and Measure variables...\n")
idVars <- c("subjectid","activityname")
measureVars <- setdiff(colnames(cleanData), idVars)

# Melting the data frame now
cat("\t\t\t\t\t> Melting the data frame...\n")
meltedData <- melt(cleanData, id=idVars, measure.vars=measureVars)

# Decasting the molten data frame based on required criteria
cat("\t\t\t\t\t> Decasting molten data into aggregated data frame...\n")
tidyData <- dcast(meltedData,subjectid+activityname ~ variable,mean)

# Writing our final tidy dataset into files
cat("\t\t\t\t\t> Writing 2nd tidy dataset to file...\n\n")
write.csv(tidyData,"tidy_data.csv",row.names=FALSE)
write.table(tidyData,"tidy_data.txt",sep="\t",row.names=FALSE)


cat("\t\t==================================== All Done ====================================\n")