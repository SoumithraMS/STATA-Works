/* This do-file contains the code to some of the questions related to the 
Covid 19 vaccination data set for India

SECTION-1

1 a. The first question pertains to standardizing the variables total_covishield
total_covaxin and female_vac */

egen total_covishield_stan1 = sd(total_covishield)
egen total_covaxin_stan1 = sd(total_covaxin)
egen total_female_vac_stan1 = sd(female_vac)

/* 1b. requires us to perform the same activity as above for the same variables 
but using a foreach loop */

local varlist total_covishield total_covaxin female_vac
foreach i in `varlist' {
egen `i'_stan_2 = sd(`i') 
}      
/* 1c. the same activity as above for the same variables but for each month*/

local varlist total_covishield total_covaxin female_vac
foreach i in `varlist' {
forvalues x =1/4 {
egen `i'_stan_3`x' = sd(`i') if date_month == `x'
}
} 
/* 2. On which day did the Jalandhar district in Punjab receive the highest/// 
doses of covishiled and coavxin vaccines? */

su total_covishield if lgd_state_name == "punjab"/// 
& lgd_district_name == "jalandhar"
tab date_day if total_covishield == 271597 & lgd_district_name == "jalandhar"

su total_covaxin if lgd_state_name == "punjab" & lgd_district_name== "jalandhar"
tab date_day if total_covaxin == 14377 & lgd_district_name == "jalandhar"

/*3.To rename date_day, date_month and date_year as day, month and year */

a.local varlist day month year
foreach i in `varlist'{
rename date_`i' `i '
}
/*b. to rename the variables male_vac, female_vac and trans_vac as total_vac_male,
total_vac_female and total_vac_trans */

local varlist male female trans
foreach i in `varlist'{
rename `i'_vac total_vac_`i'
}

/* 4. Consider Birbhum district in West Bengal. On how many days did this/// 
district have:
a.More covaxin shots than covishield shots?
b.More males getting vaccinated than females? */

a. tab date_day if total_covaxin> total_covishield & ///
lgd_district_name == "birbhum" & lgd_state_name =="west bengal"
/* Answer: 0 days */

b.tab date if total_vac_male> total_vac_female & lgd_district_name == "birbhum"///
 & lgd_state_name =="west bengal"
/*Answer: 58 days */

5./*Display the mean no of covishield vaccination on each day of March*/
forvalues x = 1/31{
summ total_covishield if month == 3 & day == `x'
display r(mean)
}
