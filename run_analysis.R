path <- getwd()
zip_file <- "UCI_HAR_Dataset.zip"

# download the zip file only if it has not been downloaded already
if (!file.exists(file.path(path, zip_file))) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "UCI_HAR_Dataset.zip", "curl")
}

unzipped <- "UCI HAR Dataset"
# unzip the archive if we have not already done this
if (!file.exists(file.path(path, unzipped))) {
  unzip(zipfile=file.path(path, zip_file))
}

unzipped_path <- file.path(path, unzipped)
# list the contents of the archive recursively
list.files(unzipped_path, recursive = TRUE)

#- 'features_info.txt': Shows information about the variables used on the feature vector.
#- 'features.txt': List of all features.
#- 'activity_labels.txt': Links the class labels with their activity name.
#- 'train/X_train.txt': Training set.
#- 'train/y_train.txt': Training labels.
#- 'test/X_test.txt': Test set.
#- 'test/y_test.txt': Test labels.

# read the train set
train_set_file <- file.path(unzipped_path, "train/X_train.txt")
train_set_table <- data.table(read.table(train_set_file))

# read the train labels
train_labels_file <- file.path(unzipped_path, "train/y_train.txt")
train_labels_table <- data.table(read.table(train_labels_file))
setnames(train_labels_table, c("V1"), c("activityvalue"))

# add train labels as a new column for the train set
train_table <- cbind(train_set_table, train_labels_table)

# read the test set
test_set_file <- file.path(unzipped_path, "test/X_test.txt")
test_set_table <- data.table(read.table(test_set_file))

# read the test labels
test_labels_file <- file.path(unzipped_path, "test/y_test.txt")
test_labels_table <- data.table(read.table(test_labels_file))
setnames(test_labels_table, c("V1"), c("activityvalue"))

# add test labels as a new column for the test set
test_table <- cbind(test_set_table, test_labels_table)

# merge train and test tables
full_table <- rbind(train_table, test_table)
setkey(full_table, activityvalue)

# read activity labels
activities_file <- file.path(unzipped_path, "activity_labels.txt")
activities_table <- data.table(read.table(activities_file))
setnames(activities_table, c("V1", "V2"), c("activityvalue", "activitylabel"))

# merge activities into the full table and replace values with labels
full_table <- merge(full_table, activities_table, by="activityvalue", all.x=TRUE)

setkey(full_table, activitylabel)

# read train subjects values
train_subject_file <- file.path(unzipped_path, "train/subject_train.txt")
train_subject_table <- data.table(read.table(train_subject_file))
setnames(train_subject_table, c("V1"), c("subject"))

# read test subjects values
test_subject_file <- file.path(unzipped_path, "test/subject_test.txt")
test_subject_table <- data.table(read.table(test_subject_file))
setnames(test_subject_table, c("V1"), c("subject"))

subjects_table <- rbind(train_subject_table, test_subject_table)

full_table <- cbind(full_table, subjects_table)

setkey(full_table, activitylabel, subject)

# read features
features_file <- file.path(unzipped_path, "features.txt")
features_table <- data.table(read.table(features_file))
setnames(features_table, c("V1", "V2"), c("featurenumber", "featurename"))

# transform the number to a valid value in the full table
features_table <- mutate(features_table, featurenumber=paste0("V",featurenumber))

# filter out the columns that are not mean or std
mean_std_features <- features_table[grepl("mean\\(\\)|std\\(\\)", features_table$featurename),]

# filter out columns in full table according to new subset of features
full_table <- full_table[, c(key(full_table), mean_std_features$featurenumber), with = FALSE]

# melt table to make merging easier
full_table <- melt(full_table, key(full_table), variable.name = "featurenumber")

# merge with features table
full_table <- merge(full_table, features_table, by="featurenumber", all.x=TRUE)
setnames(full_table, c("featurenumber", "activitylabel", "featurevalue", "featurename"))

# create factors from columns
full_table$subject <- factor(full_table$subject)
full_table$activity <- factor(full_table$activitylabel)
full_table$feature <- factor(full_table$featurename)

# grab jerk features
full_table$jerk <- factor(grepl("Jerk", full_table$feature), labels = c(NA, "jerk"))
# grab magnitude features
full_table$magnitude <- factor(grepl("Mag", full_table$feature), labels = c(NA, "magnitude"))

y2 <- matrix(seq(1, 2), nrow = 2)
# grab time/frequency feature
x <- matrix(c(grepl("^t", full_table$feature), grepl("^f", full_table$feature)), ncol = nrow(y2))
full_table$timefreq <- factor(x %*% y2, labels = c("time", "freq"))

# grab instrument feature
x <- matrix(c(grepl("Acc", full_table$feature), grepl("Gyro", full_table$feature)), ncol = nrow(y2))
full_table$instrument <- factor(x %*% y2, labels = c("accelerometer", "gyroscope"))

# grab accelaration feature
x <- matrix(c(grepl("BodyAcc", full_table$feature), grepl("GravityAcc", full_table$feature)), ncol = nrow(y2))
full_table$acceleration <- factor(x %*% y2, labels = c(NA, "body", "gravity"))

# grab variable feature
x <- matrix(c(grepl("mean\\(\\)", full_table$feature), grepl("std\\(\\)", full_table$feature)), ncol = nrow(y2))
full_table$variable <- factor(x %*% y2, labels = c("mean", "std"))

# grab axis feature
y3 <- matrix(seq(1, 3), nrow = 3)
x <- matrix(c(grepl("-X", full_table$feature), grepl("-Y", full_table$feature), grepl("-Z", full_table$feature)), ncol = nrow(y3))
full_table$axis <- factor(x %*% y3, labels = c(NA, "X", "Y", "Z"))

setkey(full_table, subject, activity, timefreq, acceleration, instrument, jerk, magnitude, variable, axis)
tidy_full_table <- full_table[, list(count = .N, average = mean(value)), by = key(full_table)]

str(tidy_full_table)

key(tidy_full_table)

summary(tidy_full_table)

tidy_full_table[, .N, by = c(names(tidy_full_table)[grep("timefreq|instrument|jerk|magnitude|variable|axis", names(tidy_full_table))])]

tidy_dataset_file <- file.path(path, "TidyDataset.txt")

write.table(tidy_full_table, tidy_dataset_file, quote = FALSE, sep = "\t")
