/* Detailed Data Expoloration of the Dataset */

*1) Check column types and names;
Title "MetaData";
PROC CONTENTS data = Lab.Mental_Health;
RUN;

*2) Descriptive statistics of numeric columns;
Title "Descriptive Statistics";
PROC MEANS data = Lab.Mental_Health N NMISS MEAN MEDIAN STD MIN MAX SKEWNESS;
VAR age stress_level sleep_hours depression_score anxiety_score productivity_score;
RUN;

*3) Categorical frequency table;
Title "Categorical Frequency Table";
PROC FREQ data = Lab.Mental_Health ;
TABLES gender*mental_health_risk / NOCOL NOPERCENT;
RUN;

*4) Correlation Matrix;
Title "Correlation Matrix";
PROC CORR data = Lab.Mental_Health;
VAR depression_score anxiety_score productivity_score sleep_hours;
RUN;



/* Detailed Pre-processing Step */

*1) Standardize casing and remove extra spaces to avoid errors;
DATA Lab.Mental_Clean;
SET Lab.Mental_Health;
gender = UPCASE(STRIP(gender));
employment_status = UPCASE(STRIP(employment_status));
work_environment = UPCASE(STRIP(work_environment));
mental_health_risk = PROPCASE(mental_health_risk);

*2) Handling Noise. Instead of deleting rows, transform values to valid ranges;
 IF stress_level > 10 THEN stress_level = 10;
 ELSE IF stress_level < 1  THEN stress_level = 1;
 ELSE IF sleep_hours > 10  THEN sleep_hours = 10;
 ELSE IF sleep_hours < 3   THEN sleep_hours = 3;

*3) Binary Encoding for Analysis;
IF mental_health_history = 'Yes' THEN history_num = 1; ELSE history_num = 0;
RUN;



/* Feature Engineering Step*/
DATA Lab.Mental_Features;
SET Lab.Mental_Clean;

*1) Psychological Load;
Psych_Load = depression_score + anxiety_score + stress_level;

*2) Wellness Index;
Wellness_Index = sleep_hours + physical_activity_days;

*3) Productivity Normalization; 
IF productivity_score > 0 THEN Log_Prod = LOG(productivity_score);
ELSE Log_Prod = 0;

*4) Age Category;
IF age < 30 THEN age_group = 'Young Adult';
ELSE IF age < 50 THEN age_group = 'Middle Aged';
ELSE age_group = 'Senior';

*5) Protective Ratio;
Support_Ratio = social_support_score / (stress_level + 1);
RUN;

*6) Feature Standardization;
PROC STDIZE data = Lab.Mental_Features OUT = Lab.Final_Dataset METHOD = STD;
VAR age depression_score anxiety_score stress_level productivity_score;
RUN;



/* Hypothesis Step */

*1) HYPOTHESIS 1: Independent T-Test;
TITLE "Impact of History on Total Psychological Load";
PROC TTEST data = Lab.Final_Dataset;
CLASS mental_health_history;
VAR Psych_Load;
RUN;

*2) HYPOTHESIS 2: Correlation;  
TITLE "Relationship Between Psych_Load Log_Prod";
PROC CORR data = Lab.Final_Dataset PEARSON;
VAR Psych_Load Log_Prod;
RUN;


*3) HYPOTHESIS 3: One-Way ANOVA Test;
TITLE "ANOVA for Total Psychological Load on Risk Category";
PROC ANOVA data = Lab.Final_Dataset;
CLASS mental_health_risk;
MODEL Psych_Load = mental_health_risk;
MEANS mental_health_risk / TUKEY; /* Identifies which risk groups differ */
RUN;

*4) HYPOTHESIS 4; Logistic Regression;
TITLE "Predictors of Mental Health Risk Levels";
PROC LOGISTIC data = Lab.Final_Dataset;
CLASS mental_health_risk (ref='Low'); 
MODEL mental_health_risk = social_support_score Wellness_Index;
RUN;

*5) HYPOTHESIS 5: Chi-Square Test of Independence;
TITLE "Age Group Association with Treatment-Seeking Behavior";
PROC FREQ data = Lab.Final_Dataset;
TABLES age_group * seeks_treatment / CHISQ;
RUN;

