import delimited "Base2.csv"
save "Base2.dta"
import excel "Base1.xls", sheet("base1") firstrow clear
append using "Base2.dta"
merge 1:1 var1 using "Base3.dta", generate(_merge1)
label variable var1 "Patient’s identification"
rename var1 id
label variable var2 "Patient’s sex"
rename var2 sex
label define sex 1 "male" 0 "female"
label values sex sex
label variable var3 "Chest pain type"
rename var3 chest
label define chest_pain_type 1 "typical angina" 2 "atypical angina" 3 "non-anginal pain" 4 "asymptomatic"
label values chest chest_pain_type
destring var4, generate(var4_2) force
list id var4 var4_2 if var4_2==.
replace var4_2=145 if id==8477
replace var4_2=108 if id==8617
list id var4 var4_2 if var4_2==.
codebook var4_2
drop var4
label variable var4_2 "Systolic blood pressure"
rename var4_2 systolic
label variable systolic "Systolic blood pressure (mmHg)"
destring var5, generate(var5_2) force
list id var5 var5_2 if var5_2==.
drop var5
label variable var5_2 "Serum cholestoral (mg/dl)"
rename var5_2 cholestoral
label variable var6 "Resting electrocardiographic results"
rename var6 electro
label define electrocardiographic 0 "normal" 1 "having ST-T wave abnormality" 2 "showing probable or definite left ventricular hypertrophy"
label values electro electrocardiographic
label variable var7 "Date of birth (mm/dd/yyyy)"
rename var7 Date_birth
label variable var8 "Diagnosis of heart disease (angiographic disease status)"
rename var8 disease
label define heart_disease 0 "< 50% diameter narrowing" 1 "> 50% diameter narrowing"
label values disease heart_disease
label variable var9 "Coronary angiography date"
rename var9 date_angiography
rename date_angiography date_angio
rename Date_birth date_birth
drop _merge1
label variable date_angio "Coronary angiography date (dd/mm/yyyy)"
egen float systolic_cat = cut(systolic), at(0 90 120 140 160 180 300) icodes
codebook systolic_cat
label variable systolic_cat "Systolic blood pressure (categorical)"
label define systolic_blood_categorical 0 "hipotensión" 1 "deseada/normal" 2 "prehipertensión" 3 "hipertensión grado 1" 4 "hipertensión grado 2" 5 "crisis hipertensiva"
label values systolic_cat systolic_blood_categorical
gen edad_angio=(date(date_angio,"DMY")-date( date_birth,"MDY"))/365.25
label variable edad_angio "Edad al momento de la angiografía coronaria (años)"
histogram edad_angio, percent normal kdensity by(sex)
graph box edad_angio, by(sex)
graph combine H_edad BP_edad, cols(1) xcommon
sum edad_angio, d
tabulate chest disease
