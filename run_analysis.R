library(dplyr)

# Download and unzip data

if (!file.exists("./data")) { dir.create("./data") }
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipUrl, "data/dataset.zip", "curl")
unzip("data/dataset.zip", exdir = "data")

# Read data

setwd("data/UCI HAR Dataset")
features <- read.table("features.txt", colClasses = c("NULL", "character"))$V2
# features <- gsub("[.,()-]", "", tolower(features))
x.train <- read.table("train/X_train.txt", col.names = features)
y.train <- read.table("train/y_train.txt", col.names = "activity")
subject.train <- read.table("train/subject_train.txt", col.names = "subject")
train <- cbind(subject.train, x.train, y.train)
x.test <- read.table("test/X_test.txt", col.names = features)
y.test <- read.table("test/y_test.txt", col.names = "activity")
subject.test <- read.table("test/subject_test.txt", col.names = "subject")
test <- cbind(subject.test, x.test, y.test)

# Merge train and test sets

merged <- rbind(train, test)

# Extract only mean and standard deviation features

selected.names <- c("subject", grep("mean\\.\\.|std\\.\\.", names(merged), value = TRUE), "activity")
merged <- merged[,selected.names]

# Use descriptive activity names

activities <- read.table("activity_labels.txt", col.names = c("activity", "activitylabel"))
activities$activitylabel <- as.factor(gsub("_", "", tolower(activities$activitylabel)))
merged <- select(merge(merged, activities), -activity)

# Format features names

names(merged) <- gsub("\\.", "", tolower(names(merged)))

# Calculate averages

averages <- merged %>% group_by(activitylabel, subject) %>% summarise_each(funs(mean))

# Write averages

setwd("..")
write.table(averages, "averages.csv", row.name = FALSE)