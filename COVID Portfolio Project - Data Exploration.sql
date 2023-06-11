select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations
--order by 3,4

--Select Data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths 
-- Shows the likelihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location = 'Malaysia'
order by 1,2

-- Looking at Total Cases vs Populations 
-- Shows what percentage of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as Percent_Population
from PortfolioProject..CovidDeaths
-- where location = 'Malaysia'
order by 1,2

-- Looking at Country with Highest Infection Rate compared to Population
Select Location, population, MAX(total_cases) AS Highest_Infection_Count,  MAX((total_cases/population))*100 as Percent_Population_Infected
from PortfolioProject..CovidDeaths
-- where location = 'Malaysia'
Group by Location, Population
order by Percent_Population_Infected desc


-- Showing Country with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as Total_Death_Count
from PortfolioProject..CovidDeaths
-- where location = 'Malaysia'
where continent is not null
Group by Location
order by Total_Death_Count desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

--Showing continents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as Total_Death_Count
from PortfolioProject..CovidDeaths
-- where location = 'Malaysia'
where continent is not null
Group by continent
order by Total_Death_Count desc

-- GLOBAL NUMBERS
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location = 'Malaysia'
where continent	 is not null
--Group by date
order by 1,2

--Looking at Total Population vs Vaccinations
Select DISTINCT dea.continent, dea.location, dea.date, dea.population, CONVERT(bigint,vac.new_vaccinations)
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- USE CTE 
With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as 
(
Select DISTINCT dea.continent, dea.location, dea.date, dea.population, CONVERT(bigint,vac.new_vaccinations)
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac

--TEMP TABLE
--DROP Table if exists #PercentPopulationVaccinated

Create table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select DISTINCT dea.continent, dea.location, dea.date, dea.population, CONVERT(bigint,vac.new_vaccinations)
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View to store data for later visualizations 

Create View PercentPopulationVaccinated as
Select DISTINCT dea.continent, dea.location, dea.date, dea.population, CONVERT(bigint,vac.new_vaccinations) as new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select * from PercentPopulationVaccinated
