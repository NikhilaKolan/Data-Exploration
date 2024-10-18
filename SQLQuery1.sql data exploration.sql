select *
from PortfolioProject..CovidDeaths
order by 3,4

select *
from PortfolioProject..CovidVaccinations
order by 3,4 


--select data 
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--total cases vs total deaths
Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2


---india 
Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

---total cases vs population
---- shows percentage of population got covid
Select Location, date, population, total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as Percentageofpopulationinfected
From PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

Select Location, date, population, total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as Percentageofpopulationinfected
From PortfolioProject..CovidDeaths

order by 1,2


---countries with highest infection rate comp to population

Select Location, population, Max(total_cases) as highestcovidcases, Max ((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)))*100 as Percentageofpopulationinfected
from PortfolioProject..CovidDeaths
group by location, population
order by Percentageofpopulationinfected desc


---countries with highest death count per population 

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc



-----continent highest death per population
Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

Select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc


--global numbers

Select  location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

Select  date, sum(cast(total_cases as int))
From PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

Select  date, sum(cast(new_cases as float) ) as newcasessum, sum(cast(new_deaths as float)) as newdeathssum,  sum(cast(new_deaths as float))/ nullif(sum(cast(new_cases as float)),0)*100 as deathpercentage

From PortfolioProject..CovidDeaths
where continent is not null
group by date  
order by 1,2



Select   sum(cast(new_cases as float) ) as newcasessum, sum(cast(new_deaths as float)) as newdeathssum,  sum(cast(new_deaths as float))/ nullif(sum(cast(new_cases as float)),0)*100 as deathpercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


select *
from PortfolioProject..CovidVaccinations

-----looking at total population vs vaccinations

select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date= vac.date


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date= vac.date
where dea.continent is not null
order by 1,2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as pollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date= vac.date
where dea.continent is not null
order by 2,3


---using CTE common table expression

with PopvsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--(rollingpeoplevaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100
from PopvsVac



-----creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


Select * 
From PercentPopulationVaccinated














