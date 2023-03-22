select *
from [Portfolio Project]..[covid deaths]
where continent is not null
order by 3,4 

select *
from [Portfolio Project]..[covid vaccinations]
order by 3,4 


select location, date, total_cases,new_cases,total_deaths, population 
from [Portfolio Project]..[covid deaths]
order by 1,2


select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from [Portfolio Project]..[covid deaths]
where location like '%state%'
order by 1,2



select location, date, total_cases,population, (total_cases/population)*100 as Percentageofpopulationinfected
from [Portfolio Project]..[covid deaths]
where location like '%state%'
order by 1,2



select location, max(total_cases)as HighestInfectionCount, population, max((total_cases/population)*100) as Percentageofpopulationinfected
from [Portfolio Project]..[covid deaths]
--where location like '%state%'
group by location , population
order by Percentageofpopulationinfected desc 



select location, max(cast(total_deaths as int)) as Totaldeathcount 
from [Portfolio Project]..[covid deaths]
--where location like '%state%'
where continent is not null 
group by location 
order by Totaldeathcount  desc 


select continent , max(cast(total_deaths as int)) as Totaldeathcount 
from [Portfolio Project]..[covid deaths]
--where location like '%state%'
where continent is not null 
group by continent 
order by Totaldeathcount  desc 



select date, sum(new_cases)as total_cases,sum(cast(new_deaths as int )) as total_deaths, 
sum (cast(new_deaths as int ))/sum (New_cases)*100 as DeathPercentage
from [Portfolio Project]..[covid deaths]
--where location like '%state%'
where continent is not null
group by date 
order by 1,2


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Cast(vac.new_vaccinations as int )) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
 from [Portfolio Project]..[covid deaths] dea 
join [Portfolio Project]..covidvaccinations vac 
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
order by 2,3


--TEMP TABLE 
Drop table if exists PercentPopulationVaccinated
 Create Table  #PercentPopulationVaccinated
 (
 continent nvarchar(255),
 Location nvarchar (255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric,
 )

 INSERT INTO #PercentPopulationVaccinated
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Cast(vac.new_vaccinations as int )) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
 from [Portfolio Project]..[covid deaths] dea 
join [Portfolio Project]..covidvaccinations vac 
on dea.location = vac.location
and dea.date = vac.date 
--where dea.continent is not null
order by 2,3
select *, (RollingPeoplevaccinated/Population)*100
from PercentPopulationVaccinated



create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Cast(vac.new_vaccinations as int )) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
 from [Portfolio Project]..[covid deaths] dea 
join [Portfolio Project]..covidvaccinations vac 
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null

select*
from PercentPopulationVaccinated
