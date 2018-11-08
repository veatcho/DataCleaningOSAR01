#Clear existing data and graphics
rm(list=ls())
graphics.off()
#Load Hmisc library
library(Hmisc)
library(tidyverse)

#Read Data
vandydata=read.csv(file = 'C:/Users/Veatcho/Downloads/OSAGenetics_DATA_2018-11-07_1203.csv')

#Read Data with duplicate row names (i.e. indicate no row names skip=1) and allow variables with missing values

vandybmi<-read.table(file = "C:/Users/Veatcho/Downloads/Potential_OSA_cases_18_88_vitals_bmi_raw.txt", skip = 1, header = FALSE, sep="\t")
vandyicd9<-read.table(file = "C:/Users/Veatcho/Downloads/Potential_OSA_cases_18_88_icd9.txt", skip=1, header=FALSE, sep="\t")
vandyosaicd10<-read.table(file = "C:/Users/Veatcho/Downloads/Potential_OSA_cases_18_88_icd10.txt", skip=1, header=FALSE, sep="\t")

#Identify only inds with codes on two ore more dates
#ICD9s: 327.20 (Organic sleep apnea, unspecified), 327.23 (Obstructive sleep apnea [adult, pediatric]), 327.29 (Other organic sleep apnea), 780.51 (Insomnia with sleep apnea), 780.53 (Hypersomnia with sleep apnea), 780.57 (Sleep apnea [NOS]), 
#ICD10s: G4730 (Sleep apnea, unspecified), G4733 (Obstructive sleep apnea [adult, pediatric]) and G4739 (Other sleep apnea)
vandyocsaicd9 <- 
  vandyicd9 %>%
  filter(grepl("leep apnea", V4)) %>%
  group_by(V1)

vandyocsaicd9<-mutate(vandyocsaicd9, codesascharacters=as.character(V2))
vandyocsaicd9distinct<-
  vandyocsaicd9 %>%
  group_by(V1) %>%
  mutate(codes.diffdates=n_distinct(codesascharacters))

EHROSA.icd9s.vandy<- filter(vandyocsaicd9distinct, codes.diffdates>=2)

#Find BMI at or close to first diagnosis code
vandybmi <- arrange(vandybmi, V2)
vandyosaicd9 <- arrange(vandyosaicd9, V2)
vandyosaicd10 <- arrange(vandyosaicd10, V2)
vandyosaicdsbmi<-full_join(vandyosaicds, vandybmi, by="V1")

#Generate new variable calculating difference in bmi vs icd date

#Setting Labels

label(data$study_id)="Study ID"
label(data$gender)="Gender"
label(data$race)="Race"
label(data$ethnicity)="Ethnicity"
label(data$dob)="Date of Birth"
label(data$deceased)="Deceased"
label(data$demographics_complete)="Complete?"
#Setting Units


#Setting Factors(will create new variable for factors)
data$gender.factor = factor(data$gender,levels=c("M","F","U"))
data$race.factor = factor(data$race,levels=c("B","A","W","H","I","U","M","N"))
data$ethnicity.factor = factor(data$ethnicity,levels=c("HL","NH","UN"))
data$deceased.factor = factor(data$deceased,levels=c("Y"))
data$demographics_complete.factor = factor(data$demographics_complete,levels=c("0","1","2"))

levels(data$gender.factor)=c("Male","Female","Unknown")
levels(data$race.factor)=c("African American","Asian/Pacific","Caucasian","Hispanic","Native American","Unknown","Multi race","Other")
levels(data$ethnicity.factor)=c("Hispanic/Latino","Not Hispanic/Latino","Unknown")
levels(data$deceased.factor)=c("Yes")
levels(data$demographics_complete.factor)=c("Incomplete","Unverified","Complete")

