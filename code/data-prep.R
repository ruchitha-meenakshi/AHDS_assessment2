# importing the csv files
BMX <- read.csv("~/Desktop/AHDS_assessment2_2331122/data_raw/BMX_D.csv")
DEMO <- read.csv("~/Desktop/AHDS_assessment2_2331122/data_raw/DEMO_D.csv")

#creating new data frame BMX_new by selecting the SEQN and BMXBMI from BMX dataset
BMX_new <- data.frame(BMX$SEQN, BMX$BMXBMI)

#creating new data frame DEMO_new by selecting the SEQN, RIAGENDR, RIDAGEYR, RIDARETH1, DMDBORN, DMDCITZ, DMDYRSUS from DEMO dataset
DEMO_new <- data.frame(DEMO$SEQN,DEMO$RIAGENDR, DEMO$RIDAGEYR, DEMO$RIDRETH1, DEMO$DMDBORN, DEMO$DMDCITZN, DEMO$DMDYRSUS)

#changing column names into understandable format
colnames(BMX_new) <- c("SEQN", "BMI")
colnames(DEMO_new) <- c("SEQN", "GENDER", "AGE", "RACE/ETHNICITY", "COUNTRY_OF_BIRTH", "CITIZENSHIP_STATUS", "LENGTH_OF_TIME_IN_US")

#merging the extracted columns into single data set by "SEQN"
BMX_DEMO <- merge(BMX_new, DEMO_new, by = "SEQN")

# categorizing Age into <10 Years, 10-20 Years, 21-30 Years, 31-45 Years, 46-60 Years, 61-80 Years, >80 Years categories
BMX_DEMO$AGE_factor <- ifelse(BMX_DEMO$AGE <= 10, "<10 Years", ifelse(BMX_DEMO$AGE < 21, "11-20 Years", ifelse(BMX_DEMO$AGE < 31, 
"21-30 Years", ifelse(BMX_DEMO$AGE < 46, "31-45 Years", ifelse(BMX_DEMO$AGE < 61, "46-60 Years", ifelse(BMX_DEMO$AGE <= 80, "61-80 
Years" , ifelse(BMX_DEMO$AGE > 80, ">80 Years", ifelse(""))))))))

# converting values 1 and 2 in Gender into Male and Female
BMX_DEMO$GENDER_factor <- factor(BMX_DEMO$GENDER,
                                 levels = c(1,2),
                                 labels = c("Male", "Female"))

# categorizing BMI into Underweight, Healthyweight, Overweight and Obesity categories
BMX_DEMO$BMI_factor <- ifelse(BMX_DEMO$BMI < 18.5, "Underweight", ifelse(BMX_DEMO$BMI < 25.0, "Healthyweight", ifelse(BMX_DEMO$BMI 
< 30.0, "Overweight", ifelse(BMX_DEMO$BMI > 30.0, "Obesity", ifelse("")))))

# categorizing the Race/Ethnicity into Mexican American, Other Hispanic,Non-Hispanic White, Non-Hispanic Black,Other Rac -Including Multi-Racial categories
BMX_DEMO$RACE_factor <- factor(BMX_DEMO$`RACE/ETHNICITY`,
                               levels = c(1,2,3,4,5),
                               labels = c("Mexican American", "Other Hispanic", "Non-Hispanic White", "Non-Hispanic Black", "Other Race - Including Multi-Racial"))

# categorizing the Country of birth into Born in 50 US States or Washington DC, Born in Mexico,Born Elsewhere,Refused categories
BMX_DEMO$COUNTRY_OF_BIRTH_Factor <- ordered(BMX_DEMO$COUNTRY_OF_BIRTH,
                                            levels = c(1,2,3,7),
                                            labels = c("Born in 50 US States or Washington, DC", "Born in Mexico", "Born Elsewhere", "Refused"))

# categorizing the Citizenship status into Citizen by birth or naturalization, Not a citizen of the US, Refused and Don't Know categories
BMX_DEMO$CITIZENSHIP_STATUS_factor <- ordered(BMX_DEMO$CITIZENSHIP_STATUS,
                                              levels = c(1,2,7,9),
                                              labels = c("Citizen by birth or naturalization", "Not a citizen of the US", "Refused", "Don't know"))

# categorizing the Length of stay in US into <10 Years, <30 Years, <50 Years, >50 Years categories
BMX_DEMO$LENGTH_OF_TIME_IN_US_factor <- as.factor(BMX_DEMO$LENGTH_OF_TIME_IN_US)
BMX_DEMO$LENGTH_OF_TIME_IN_US_factor <- ifelse(BMX_DEMO$LENGTH_OF_TIME_IN_US <= 3, "<10 YEARS", 
ifelse(BMX_DEMO$LENGTH_OF_TIME_IN_US <= 6, "<30 YEARS", ifelse(BMX_DEMO$LENGTH_OF_TIME_IN_US <= 8, "<50 YEARS", 
ifelse(BMX_DEMO$LENGTH_OF_TIME_IN_US == 9, ">50 YEARS", ifelse("NA")))))

head(BMX_DEMO)

BMX_DEMO_new <- BMX_DEMO[c("SEQN", "BMI_factor","AGE_factor", "GENDER_factor", "RACE_factor", "COUNTRY_OF_BIRTH_Factor", "CITIZENSHIP_STATUS_factor", "LENGTH_OF_TIME_IN_US_factor")]
head(BMX_DEMO_new)

#changing the BMI, AGE and LENGTH_OF_TIME_IN_US to factor variables
BMX_DEMO_new$BMI_factor <- as.factor(BMX_DEMO_new$BMI_factor)
BMX_DEMO_new$AGE_factor <- as.factor(BMX_DEMO_new$AGE_factor)
BMX_DEMO_new$LENGTH_OF_TIME_IN_US_factor <- as.factor(BMX_DEMO_new$LENGTH_OF_TIME_IN_US_factor)

BMX_DEMO_new <- na.omit(BMX_DEMO_new)

write.csv(BMX_DEMO_new,"~/Desktop/AHDS_assessment2_2331122/data_clean/BMX_DEMO_clean.csv")

