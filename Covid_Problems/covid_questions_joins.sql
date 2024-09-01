
---1. To find out the population vs the number of people vaccinated

select * from worldometer_data;
select * from covid_vaccine_statewise;

select round(
    (cv.Total_Doses_Administered * 100.0) / wd.MaxPopulation, 
    2
) as percentage
from 
    (select MAX(Population) as MaxPopulation
     from worldometer_data 
     where Continent = 'Asia') wd
join 
    (select Total_Doses_Administered
     from covid_vaccine_statewise 
     where state = 'India' 
     and Updated_On = (
         select max(Updated_On)
         from covid_vaccine_statewise 
         where state = 'India' 
         and Total_Doses_Administered is not null
     )
     and Total_Doses_Administered is not null) cv
on 1=1;





---2. To find out the percentage of different vaccine taken by people in a country

select
    Updated_On as Date,
    State,
    Covaxin_Doses_Administered * 100.0 / Total_Doses_Administered as Covaxin_Percentage,
    CoviShield_Doses_Administered * 100.0 / Total_Doses_Administered as CoviShield_Percentage,
    Sputnik_V_Doses_Administered * 100.0 / Total_Doses_Administered as Sputnik_V_Percentage
from 
   covid_vaccine_statewise
order by date asc;





---3. To find out percentage of people who took both the doses

select
    covid_1.updated_on as date,
    covid_1.state,
    case
        when coalesce(covid_1.first_dose_administered, 0) = 0 then 0
        else coalesce(covid_2.second_dose_administered, 0) * 100.0 / coalesce(covid_1.first_dose_administered, 1)
    end as percentage_both_doses
from 
    covid_vaccine_statewise covid_1
join 
    covid_vaccine_statewise covid_2
on 
    covid_1.state = covid_2.state
    and covid_1.updated_on = covid_2.updated_on  
order by 
    covid_1.updated_on asc;
