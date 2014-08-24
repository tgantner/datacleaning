#############################
# GETTING AND CLEANING DATA #
#   -- Course Project --    #
#############################

#####################################################
# 1. MERGINING TRAINING AND TEST DATA SETS INTO ONE #
#####################################################

# SET WORKING DIRECTORY
setwd("./Data Cleaning")

# DOWNLOAD ZIPPED FILES
ZIPfile <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(ZIPfile, destfile="./WearComp.zip")

# ASSIGN FILE NAMES TO PATH
x_train_file <-"./WearComp/UCI HAR Dataset/train/X_train.txt"
x_test_file <-"./WearComp/UCI HAR Dataset/test/X_test.txt"

sub_train_file <-"./WearComp/UCI HAR Dataset/train/subject_train.txt"
sub_test_file <-"./WearComp/UCI HAR Dataset/test/subject_test.txt"

y_train_file <-"./WearComp/UCI HAR Dataset/train/y_train.txt"
y_test_file <-"./WearComp/UCI HAR Dataset/test/y_test.txt"

feat_file <-"./WearComp/UCI HAR Dataset/features.txt"

act_lab_file <-"./WearComp/UCI HAR Dataset/activity_labels.txt"

# READ IN RAW FILES
x_train <-read.delim(x_train_file, header=FALSE, sep="")
x_test <-read.delim(x_test_file, header=FALSE, sep="")

sub_train <-read.delim(sub_train_file, header=FALSE, sep="")
sub_test <-read.delim(sub_test_file, header=FALSE, sep="")

y_train <-read.delim(y_train_file, header=FALSE, colClasses=c("factor"), sep="")
y_test <-read.delim(y_test_file, header=FALSE, colClasses=c("factor"), sep="")

feat_lab <-read.delim(feat_file, header=FALSE, sep="", stringsAsFactors=FALSE)[,2]

act_lab <-read.delim(act_lab_file, header=FALSE, sep="", stringsAsFactors=FALSE)

# MERGING FILES
data_train <-cbind(x_train, sub_train, y_train)
data_test <-cbind(x_test, sub_test, y_test)
data_merge <-rbind(data_train, data_test)

#######################################################
# 2. EXTRACT ONLY ON MEAN AND STD OF EACH MEASUREMENT #
#######################################################

# CREATE VECTOR WITH VARIABLE NAMES
var_names <-append(feat_lab, c("Subject", "Activity"), after=length(feat_lab))

# GET INDICES OF MEASUREMENTS WITH 'MEAN' OR 'STD' IN THEIR NAMES
keep_var_ind <-c(grep("mean|std", var_names, ignore.case=TRUE), length(var_names)-1, length(var_names))

# SUBSET DATA FILE
data_final <-data_merge[,keep_var_ind]

####################################################
# 3. USE DESCRIPTIVE ACTIVITY NAMES FOR ACTIVITIES #
####################################################

# REPLACE FACTOR LEVELS WITH MEANINGFUL NAMES
levels(data_final[,dim(data_final)[2]]) <-act_lab[,2]

##############################################
# 4. LABEL DATASET WITH DECRIPTIVE VAR NAMES #
##############################################

# ASSIGN DESCRIPTIVE VARIABLE NAMES
names(data_final) <-var_names[keep_var_ind]

###########################################################
# 5. CREATE SECOND TIDY DATASET WITH AVG OF EACH VARIABLE #
#    BY ACTIVITY AND SUBJECT                              #
###########################################################

# CREATE NEW DATASET BY AGGREGATING
agg_data <-aggregate(data_final[,1:(dim(data_final)[2]-2)], list(data_final$Subject, data_final$Activity), FUN=mean)

# RENAME VARIABLES TO REFLECT THE CHANGES
agg_data_rename_1 <-paste("Mean of", names(agg_data[-1:-2]), sep=" ")
agg_data_rename_2 <-append(c("Subject", "Activity"), agg_data_rename_1, 2)
names(agg_data) <-agg_data_rename_2

# WRITE NEW DATASET TO FILE
write.table(agg_data, "./Tidy_Data.txt", quote=FALSE, row.names=FALSE, sep="\t")

#################
# END OF SCRIPT #
#################

