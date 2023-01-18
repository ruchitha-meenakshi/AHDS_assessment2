This R script imports two CSV files (BMX_D.csv and DEMO_D.csv), picks columns from each dataset and generates two new data frames 
(BMX_new and DEMO_new). The script then modifies the column names to a more comprehensible format, combines the two data frames 
according to the SEQN column, and generates new categorical variables for Age, Gender, BMI, Race/Ethnicity, and Country of Birth.

The script then categorises Age as follows: 10 Years, 10-20 Years, 21-30 Years, 31-45 Years, 46-60 Years, 61-80 Years, and >80 
Years. Male and Female are derived from the Gender value. Underweight, Healthy weight, Overweight, and Obesity are the four BMI 
classifications. Mexican American, Other Hispanic, Non-Hispanic White, Non-Hispanic Black, and Other Races - Including 
Multi-Racial are race/ethnicity classifications. The country of birth is classified as Born in the 50 United States or the 
District of Columbia, Born in Mexico, Born Elsewhere, or Refused.

BMX_DEMO is the name of the final data collection, which comprises all the information of the updated columns.
