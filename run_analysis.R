#Clear mem and set your working directory accordingly

rm(list=ls())

#download the file as activity.zip

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","activity.zip",mode="wb")


#extract all the zipped files
unzip("activity.zip")

#save the names of the files in activity.zip to character vector "names"
names<-unzip("activity.zip",list=TRUE)$Name

#From observing "names", save files from names[16:18] (test related files) & names[30:32] (training related files) in separate data frames called file_16, file_32 etc.

for(i in 1:length(names)){
      if(i %in% 16:18 | i %in% 30:32){
            tempfile<-read.csv(names[i],sep="",header=FALSE)
            assign(paste("file",as.character(i),sep="_"),tempfile)   
      }
}
#read features.txt's 2nd col as a vector "featurelist"
tempfile<-read.csv(names[2],sep="",header=FALSE,col.names=c("feature_id","feature"))
featurelist<-tempfile$feature

#Rename file_30 (training subject) and file_16 (test subject) variable to "subject_id"


colnames(file_16)<-"subject_id"
colnames(file_30)<-"subject_id"

#file_18 (test activity id) & file_32 (training activity id) cols are renamed as "activity_id"

colnames(file_18)<-"activity_id"
colnames(file_32)<-"activity_id"

#file_17 (test set) and file_31 (training set)'s 561 columns are assigned the names from "featurelist"

colnames(file_17)<-featurelist
colnames(file_31)<-featurelist

#add file_16's column subject_id to file_17's columns' containing feature list values. Repeat the same for file_31 and file_30. Rename to subject_id

file_17<-cbind(file_16$subject_id,file_17)
file_31<-cbind(file_30$subject_id,file_31)
colnames(file_17)[colnames(file_17)=="file_16$subject_id"] <- "subject_id"
colnames(file_31)[colnames(file_31)=="file_30$subject_id"] <- "subject_id"

#Do the same with file_18 & file_32's column "activity_id" 

file_17<-cbind(file_18$activity_id,file_17)
file_31<-cbind(file_32$activity_id,file_31)
colnames(file_17)[colnames(file_17)=="file_18$activity_id"] <- "activity_id"
colnames(file_31)[colnames(file_31)=="file_32$activity_id"] <- "activity_id"

#change names for better understanding and drop old table to make space
testset<-file_17
trainset<-file_31
rm(list=c("file_17","file_31","tempfile","file_16","file_18","file_30","file_32"))

#modify table variable names to be "match"-able
valid_column_names <- make.names(names=names(testset), unique=TRUE, allow_ = TRUE)
names(testset) <- valid_column_names
valid_column_names <- make.names(names=names(trainset), unique=TRUE, allow_ = TRUE)
names(trainset) <- valid_column_names

#Keep only the feature columns containing mean and std deviation and clear old tables
library(dplyr)
testsetmsd<-select(testset,matches("mean|std|subject_id|activity_id"))
trainsetmsd<-select(trainset,matches("mean|std|subject_id|activity_id"))
rm(list=c("testset","trainset","featurelist","i","names","valid_column_names"))

#join the two tables to make a master table and order according to subject_id
library(data.table)
mastertable<-data.table(arrange(rbind(testsetmsd,trainsetmsd),subject_id))

#map activity_id to their activity names using the table in activity_labels.txt and rename activity_id to activity

mastertable[,activity_id:=as.character(ifelse(activity_id==1,"Walking",ifelse(activity_id==2,"Walking_Upstairs",ifelse(activity_id==3,"Walking_Downstairs",ifelse(activity_id==4,"Sitting",ifelse(activity_id==5,"Standing","Laying"))))))]
mastertable<-dplyr::rename(mastertable,activity=activity_id)

#calculate mean for all numeric measurements by subject and then activity
library(plyr)
tidy<-ddply(mastertable,.(subject_id,activity),numcolwise(mean))

#write the output table as tidydata.txt
write.table(tidy,file="tidydata.txt",row.names=FALSE)

