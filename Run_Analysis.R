##PeerGraded Assignment Notes: 
x <- readline()

C:\Users\sreel\Downloads\Data Science Data\GettingAndCleaningData\UCI HAR Dataset
##Specify the working directory here

setwd(x)

##Read the files from the working directory
PeerGradedTest <- read.table("test/X_test.txt", header = FALSE, sep = "\n")
PeerGradedTrain <- read.table("train/X_train.txt", header = FALSE, sep = "\n")

MergedDataSet <- rbind(PeerGradedTest,PeerGradedTrain)

##To remove all extra spaces 
fd3 <- as.data.frame(apply(MergedDataSet,2, function(x)gsub("\\s+"," ",x)))

##To split the rows into columns.
fd4 <- data.frame(do.call('rbind', strsplit(as.character(fd3$V1), " " , fixed = TRUE)))

##Remove the first empty column
fd4 <- subset(fd4,select = c(-1))

##Import the featre labels
featureLabels <-  read.table("features.txt")

##Ectracts the columns on mean and standard deviation.
MeasuresOnMeanAndStd <- fd4[,grep('(*mean\\(+\\)+)|*std*', featureLabels$V2)]

colnames(MeasuresOnMeanAndStd) <- featureLabels[grep('(*mean\\(+\\)+)|*std*', featureLabels$V2),]$V2

##Read the test and train subject data
subjectTest <- read.table("test/subject_test.txt")
subjectTrain <- read.table("train/subject_train.txt")

##Merge Subject Data into MeasesOnMeanAndStd dataframe
MeasuresOnMeanAndStd[67] <- rbind(subjectTest,subjectTrain)

colnames(MeasuresOnMeanAndStd)[67] <- "IDOfTheSubjectedPerson"

##Read the test and train activity data
activityTest <- read.table("test/y_test.txt")
activityTrain <- read.table("train/y_train.txt")

##Merge activity data into MEasuresOnMEanAndStd

MeasuresOnMeanAndStd[68] <- rbind(activityTest,activityTrain)
colnames(MeasuresOnMeanAndStd)[68] <- "ActivityDoneByThePerson"

##Convert columns to numeric

MeasuresOnMeanAndStd <- as.data.frame(sapply(MeasuresOnMeanAndStd, as.numeric))

##Final independent tidy data set with the average of each variable for each activity and each subject 
MeasuresOnMeanAndStd <- aggregate(MeasuresOnMeanAndStd, list(MeasuresOnMeanAndStd$IDOfTheSubjectedPerson,MeasuresOnMeanAndStd$ActivityDoneByThePerson), FUN = "mean")
MeasuresOnMeanAndStd <- MeasuresOnMeanAndStd[,-c(1:2)]

##Renaming the activity column
MeasuresOnMeanAndStd$ActivityDoneByThePerson <- ifelse(MeasuresOnMeanAndStd$ActivityDoneByThePerson == 1,"Walking", ifelse(MeasuresOnMeanAndStd$ActivityDoneByThePerson == 2,"Walking Upstairs",ifelse(MeasuresOnMeanAndStd$ActivityDoneByThePerson == 3,"Walking Downstairs",ifelse(MeasuresOnMeanAndStd$ActivityDoneByThePerson == 4,"Sitting",ifelse(MeasuresOnMeanAndStd$ActivityDoneByThePerson == 5,"Standing","Laying")))))

##Printing the tidy dataset
MeasuresOnMeanAndStd

