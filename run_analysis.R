library(data.table)

## data should be in folders (/train and /test) in working directory/folders = /UCI HAR Dataset/


## activity names read and prepared
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity) <- c("actkeyid", "activity")

## traindata read and transformed with keys
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(trainData) <- read.table("./UCI HAR Dataset/features.txt")[,2]  
trainData[,"subjectId"] <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainData[,"keyid"] <- read.table("./UCI HAR Dataset/train/Y_train.txt")

## testdata read with and transformed with keys 
testData <- read.table("./UCI HAR Dataset/test/X_test.txt") 
colnames(testData) <- read.table("./UCI HAR Dataset/features.txt")[,2]  
testData[,"subjectId"] <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testData[,"keyid"] <- read.table("./UCI HAR Dataset/test/Y_test.txt")

## traindata and testdata put in same table
samsungDataAll <- rbind(trainData, testData)

## wanted columns extracted
subjectId <- samsungDataAll[, grep("subjectId", colnames(samsungDataAll))]
actkeyid <- samsungDataAll[, grep("keyid", colnames(samsungDataAll))]
samsungDataMean <- samsungDataAll[, grep("mean()", colnames(samsungDataAll))]
samsungDataStd <- samsungDataAll[, grep("std()", colnames(samsungDataAll))]

## wanted columns put together af activity names added
samsungDataSelect <- cbind(subjectId, actkeyid, samsungDataMean, samsungDataStd)
samsungData_FirstDataset <- merge(samsungDataSelect, activity, by="actkeyid")
samsungData_FirstDataset <- samsungData_FirstDataset[ c(2,82,3:81)]

## wanted calcaltion done and acivity namnes addet
samsungData_SecondDataset <- aggregate(samsungDataSelect, by= list(subjectId, actkeyid), FUN=mean)
samsungData_SecondDataset <- merge(samsungData_SecondDataset, activity, by="actkeyid")
samsungData_SecondDataset <- samsungData_SecondDataset[ c(4,84,5:83)]

# tables wrote to files
write.table(samsungData_FirstDataset, file="samsungData_FirstDataset.txt", sep= "\t")
write.table(samsungData_SecondDataset, file="samsungData_SecondDataset.txt", sep= "\t")

# finished
