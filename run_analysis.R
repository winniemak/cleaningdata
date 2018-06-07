
library("reshape2")

# Read all data files

subtrain <-  read.table("C:/Users/wmak/Downloads/FUCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
subtest <-  read.table("C:/Users/wmak/Downloads/FUCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
xtrain <- read.table("C:/Users/wmak/Downloads/FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
xtest <- read.table("C:/Users/wmak/Downloads/FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
ytrain <- read.table("C:/Users/wmak/Downloads/FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
ytest <- read.table("C:/Users/wmak/Downloads/FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

activity_labels <- read.table("C:/Users/wmak/Downloads/FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
features <- read.table("C:/Users/wmak/Downloads/FUCI HAR Dataset/UCI HAR Dataset/features.txt")

# merge the training and the test sets to create one data set

xData <- rbind(xtrain,xtest)
yData <- rbind(ytrain,ytest)

# Extracts only measurements on the mean and standard deviation for each measurement

mean_std_Data <- xData[, grep("mean()|std()",features[, 2])]
#print(mean_std_Data)


# combine test and train of subject data and activity data, give descriptive lables
subject <- rbind(subtrain, subtest)
names(subject) <- 'subject'
activity <- rbind(ytrain, ytest)
names(activity) <- 'activity'

# combine subject, activity, and mean and std only data set to create final data set.
dataSet <- cbind(subject,activity, mean_std_Data)
print(dataSet)


# Uses descriptive activity names to name the activities in the data set
# group the activity column of dataSet, re-name lable of levels with activity_levels, and apply it to dataSet.

act_group <- factor(dataSet$activity)
levels(act_group) <- activity_labels[,2]
dataSet$activity <- act_group


# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

baseData <- melt(dataSet,(id.vars=c("subject","activity")))
secondDataSet <- dcast(baseData, subject + activity ~ variable, mean)
names(secondDataSet)[-c(1:2)] <- paste("[mean of]" , names(secondDataSet)[-c(1:2)] )
write.table(secondDataSet, "tidy_data.txt", sep = ",")

