create database portfolio;
  use portfolio;
-- after imorting data from source  --right click on portfolio then choose table data import wizard then select browse location --import--
show tables;
describe asia_data1;

select * from asia_data1;

           -- observation of new cases and death cases on different locations
select location,date,new_cases,new_deaths from asia_data1;

      -- calculate death percentages OVER NEW CASES
select location,date,new_cases,new_deaths,(new_deaths/new_cases)*100 as deathpercentages
from asia_data1;

    -- excluding data where death% is null
select location,date,new_cases,new_deaths,(new_deaths/new_cases)*100 as deathpercentages
from asia_data1
where  new_deaths!=0 ;

       -- death percentage over population  --  -- provide first location's data
select population,location,sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,(sum(new_deaths)/population)*100 as deathpercentages
from asia_data1;
            
             -- to get all infomation country wise we use grouping
select location,population ,continent,sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,(sum(new_deaths)/population)*100 as deathpercentages
from asia_data1
where continent is not null
group by location
order by population;

-- continent wise data 
select continent,sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,(sum(new_deaths)/population)*100 as deathpercentages
from asia_data1
where continent is not null;

            -- joining 2 tables  using common column  *prerequisite
            -- 'da and va ' is the alias names for the given tables
            --  retrieve all data from tables
   select * from asia_data1 da
   join asia_vac1 va
   on da.location=va.location
   and da.date=va.date;
   
 
   describe asia_data1;
   select * from asia_vac1;
   
   -- retrieve specified column data
  select da.location,sum(new_cases) as total_cases,sum(da.new_deaths) as totaldeaths,((sum(da.new_deaths)/sum(new_cases))) *100 as deathrateovercases,(max(da.total_deaths)/population)as deathrateoverpopulation
  from asia_data1 da
   join asia_vac1 va
   on da.location=va.location
   and da.date=va.date
   where va.continent is not null
   group by location
   order by total_cases ;
   
   describe asia_vac1;
                       
                     --  data from both tables
select da.continent,da.location,da.date,da.population,va.people_vaccinated,
sum(va.people_vaccinated ) over (partition by da.location order by da.location,da.date) as rollingpeoplevaccinated 
from asia_data1 da
join asia_vac1 va
on da.location=va.location
and da.date=va.date
where va.continent is not null
group by da.location;

    -- using as keyword coping data from one table to another
    -- we extract important data from tables
    USE porfolio;
WITH new_data (Continent ,Location ,Date,Population ,People_vaccinated ,Rollingpeoplevaccinated )
as
(
select da.continent,da.location,da.date,da.population,va.people_vaccinated,
sum(va.people_vaccinated ) over (partition by da.location order by da.location,da.date) as rollingpeoplevaccinated 
 from asia_data1 da
join asia_vac1 va
  on da.location=va.location
  and da.date=va.date
where va.continent is not null
-- order by 2,3
)
select * from new_data;

 -- temporary table   
 -- my date is in form of text data so i don't want to convert it so  used  as it is
 -- you can use date as a datetime data type
 
 
drop table if exists percentagepeoplevaccinated; 
create table percentagepeoplevaccinated ( Continent text,Location text,date text,Population int
,people_vaccinated int,rolling_vaccinated double);
                               -- table created
describe asia_data1;
describe asia_vac1;

insert into percentagepeoplevaccinated
select da.continent,da.location,da.date,da.population,va.people_vaccinated,sum(va.people_vaccinated) over (partition by da.location order by da.location,da.date) as rolling_vaccinated
from asia_data1 da
join asia_vac1 va
  on da.location=va.location
  and da.date=va.date ;
-- where va.continent is not null;
-- order by 2,3
 -- (rollingpeoplevaccinated/da.population)*100 
 
 select * from  percentagepeoplevaccinated;
 
 
 -- lets create a view
 create view percentagepeoplevaccinated_view1
 as 
 select da.continent,da.location,da.date,da.population,va.people_vaccinated,sum(va.people_vaccinated) over (partition by da.location order by da.location,da.date) as rolling_vaccinated
from asia_data1 da
join asia_vac1 va
  on da.location=va.location
  and da.date=va.date ;
   
 select * from percentagepeoplevaccinated_view1
 -- now you can see  created "percentagepeoplevaccinated_view" in views