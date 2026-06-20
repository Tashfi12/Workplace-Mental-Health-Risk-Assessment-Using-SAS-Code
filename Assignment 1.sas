* Ccontents of MetaData;
Title "MetaData"
PROC CONTENTS data = Lab.Mental_Health;
RUN;
 

*Distribution;
PROC FREQ data=Lab.Mental_Health;
Title "Distribution of Mental Health Risk";
Table mental_health_risk / plots=freqplot nocum;
RUN;


*Missing Values;
PROC MEANS data=Lab.Mental_Health n nmiss;
Title "Missing Values";
RUN;

*Checking abnormal values of numeric features; 
PROC MEANS data=Lab.Mental_Health n min max;
var age stress_level sleep_hours depression_score anxiety_score;
RUN;


*Check inconsistent categorical labels;
PROC FREQ data=Lab.Mental_Health;
Title "Inconsistent check in categorical labels";
Tables gender / nocum nopercent;
Run;


*Frequency table for categorical features;
PROC FREQ data=Lab.Mental_Health order=freq;
Tables gender employment_status work_environment mental_health_history
       seeks_treatment mental_health_risk / missing;
RUN;



*Descrptive Statistics for numeric values; 
PROC MEANS data=Lab.Mental_Health n mean median std min max qrange;
Title "Descriptive Statistics";
Var age stress_level sleep_hours physical_activity_days
    depression_score anxiety_score social_support_score productivity_score;
RUN;


* Boxplots;
PROC SGPLOT data=Lab.Mental_Health;
Histogram depression_score;
Density depression_score;
Title "Histogram of Depression Score";
RUN;

PROC SGPLOT data=Lab.Mental_Health;
Vbox anxiety_score / category=mental_health_risk;
Title "Anxiety Score by Risk Category (Boxplot)";
RUN;

PROC SGPLOT data=Lab.Mental_Health;
Vbar mental_health_risk / datalabel stat=freq;
Title "Counts by Mental Health Risk Category";
RUN;

PROC SGPanel data = Lab.Mental_Health;
Title "Panel of Boxplots (Gender vs Depression_Score)";
Panelby gender;
Vbox depression_score;
RUN;


PROC CORR data = Lab.Mental_Health pearson spearman plots=matrix(histogram);
Var stress_level depression_score anxiety_score social_support_score productivity_score sleep_hours physical_activity_days;
RUN;

  
