/* This do-file contains the second section of the work on dataset containing///
the covid vaccination details 

Startig with the raw data once again.

To find the summary of female_vac at the state-day level*/

bys date_year date_month date_day lgd_state_name: summ female_vac

/* To find total female_vaccinations at state-day level */

bys date_year date_month date_day lgd_state_name: egen total_female_vac = total(female_vac)
dupicates drop total_female_vac, force

/* To assign an identification varible for districts */

keep lgd_state_id lgd_state_name lgd_district_name
duplicates drop
bysort lgd_state_name (lgd_district_name) : generate district_order = _n
tostring district_order, replace 
generate lgd_district_id = lgd_state_id + "-" + district_order

/* continuing with the raw data */
use "C:\Users\dell\Downloads\covid_vaccination_2021_04_18.dta", clear

/* adding up the values of total_covishield and total_covaxin to the state-day 
level */

/* Total Covishield */
keep lgd_state_name lgd_district_name date_year date_month date_day total_covaxin total_covishield
bys lgd_state_name date_year date_month date_day: egen total_covish = total(total_covishield)
duplicates drop total_covish lgd_state_name, force

/* Total Covaxin */
bys lgd_state_name date_year date_month date_day: egen total_covax = total(total_covaxin)
duplicates drop 

/* To find the cummulative sum of total covishiled and covaxin vaccinations for/// 
each day */

bys lgd_state_name (date_year date_month date_day): gen cummu_covish = sum(total_covish)
bys lgd_state_name (date_year date_month date_day): gen cummu_covax = sum(total_covax)

/* Total Covishield,Covaxin,Male Female and Trans vaccinations at the state-day /// 
level */ 

clear all
use "C:\Users\dell\Downloads\covid_vaccination_2021_04_18.dta", clear //startimg with the raw data set again

keep total_covishield total_covaxin male_vac female_vac trans_vac lgd_state_name lgd_district_name date_year date_month date_day
local varlist total_covishield total_covaxin male_vac female_vac trans_vac 
foreach i in `varlist'{
bys lgd_state_name date_year date_month date_day: egen `i'_1 = total(`i')
}
duplicates drop

********************************the end*****************************************
