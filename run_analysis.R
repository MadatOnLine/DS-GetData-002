#Getting and cleaning data Assignment

##WHAT THIS SCRIPT DOES ::
##Merged training and test sets
##Extracted mean and standard deviation measurements 
##Used descriptive activity names in the data set
##Labeled the data set with descriptive activity names 
##Created tidy data set with the average of each variable for each activity and each subject. 

##ABOUNT THE DATA SET ::
#collected from accelerometers in Samsung smartphones
#Link to Data https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


##path to data file
setwd(file.path(getwd(), "data/getdata/UCI_HAR"))

##Merge subject files
subject <- rbind(read.table("train/subject_train.txt", col.names = "Subject"), 
                 read.table("test/subject_test.txt", col.names = "Subject"))

##Merge X files
x <- rbind(read.table("train/X_train.txt"),
           read.table("test/X_test.txt"))

##Merge y files
y <- rbind(read.table("train/y_train.txt", col.names = "Code"), 
           read.table("test/y_test.txt",  col.names = "Code"))  

##Get Descriptive Labels and apply to y dataset
labels <- read.table("activity_labels.txt", col.names = c("Code", "Label"))
y$Name <- lebels$Label[y$Code]

##Prepare tidy dataset
yTide <- cbind(subject, y)  
features <- read.table("features.txt", col.names = c("Index", "Name"), colClasses = c("integer", "character"))

##Get Mean & STD column Names
selected <- features[grep("mean|std", features$Name, ignore.case = TRUE), ]

##ONLY Add Mean & STD columns to Tidy Dataset
for (i in seq(nrow(selected))) {
  tmp <- data.frame(x[, selected$Index[i]])
  colnames(tmp) <- selected$Name[i]
  yTide <- cbind(yTide, tmp)
}

##Compute average of each variable for each activity and each subject
yTideFinal<- aggregate(yTide, list(Subject = yTide$Subject, Activity = yTide$Name), mean)

##Create Tidy Data file 
yTideFinal<-as.data.frame(yTideFinal)
write.table(yTideFinal, "tidy_data.txt")

