# download and unzip the dataset:
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile = "./smartphone.zip",method = "curl")
unzip("./smartphone.zip")

# read activity_labels file:
activitylabels_raw <- read.table("./UCI HAR Dataset/activity_labels.txt")
activitylabels <- activitylabels_raw[,2]

# read features file, extract the measurements on mean and std, clean the names:
features_raw <- read.table("./UCI HAR Dataset/features.txt")
featuresextractnum <- grep(".*(mean|std).*",features_raw[,2])
features <- features_raw[featuresextractnum,2]
featuresclean <- gsub("[-()]","",features)

# read the files in test folder and extract the variables needed:
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt")
testextract <- as.data.frame(testdata[,featuresextractnum])
testactivities <- read.table("./UCI HAR Dataset/test/Y_test.txt")                   
testsubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read the files in train folder and extract the variables needed:
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainextract <- as.data.frame(traindata[,featuresextractnum])
trainactivities <- read.table("./UCI HAR Dataset/train/Y_train.txt")                   
trainsubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# merge the files and name the variables:
test <- cbind(testextract,testactivities,testsubjects)
train <- cbind(trainextract,trainactivities,trainsubjects)
smartphonedata <- rbind(test,train)
names(smartphonedata) <- c(as.character(featuresclean),"activities","subjects")

# turn activities and subjects into factors:
smartphonedata$activities <- factor(smartphonedata$activities,levels = activitylabels_raw[,1],labels = activitylabels_raw[,2])
smartphonedata$subjects <- factor(smartphonedata$subjects)

# create a dataset with the average of each variable group by activities and subjects:
dim(smartphonedata)
spsmart <- split(smartphonedata[,1:79],smartphonedata[,80:81])
spmean <- sapply(spsmart,colMeans)
write.table(spmean, "tidy.txt", row.names = FALSE)

